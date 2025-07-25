import 'dart:async';
import 'package:flutter/material.dart';

// Type definitions
typedef FetchItems<T> = Future<List<T>> Function(int page, String? search);
typedef LabelBuilder<T> = String Function(T item);
typedef ItemBuilder<T> = Widget Function(T item);

// Generic Paginated Dropdown Widget
class GenericPaginatedDropdown<T> extends StatefulWidget {
  const GenericPaginatedDropdown({
    super.key,
    required this.fetchItems,
    required this.onChanged,
    required this.itemLabel,
    this.itemBuilder,
    this.selectedItem,
    this.selectedItems, // For multi-select
    this.hintText = 'Select item',
    this.isLoadingExternally = false,
    this.errorStyle,
    this.fontFamily,
    this.searchable = true,
    this.heading,
    this.dropdownHeight = 300,
    this.pageSize = 10,
    this.multiSelect = false, // New parameter
    this.onMultiChanged, // New callback for multi-select
  });

  final FetchItems<T> fetchItems;
  final void Function(T?)? onChanged;
  final void Function(List<T>)? onMultiChanged; // New callback
  final T? selectedItem;
  final List<T>? selectedItems; // New parameter
  final String hintText;
  final LabelBuilder<T> itemLabel;
  final ItemBuilder<T>? itemBuilder;
  final bool isLoadingExternally;
  final TextStyle? errorStyle;
  final String? fontFamily;
  final bool searchable;
  final Widget? heading;
  final double dropdownHeight;
  final int pageSize;
  final bool multiSelect; // New parameter

  @override
  State<GenericPaginatedDropdown<T>> createState() => _GenericPaginatedDropdownState<T>();
}

class _GenericPaginatedDropdownState<T> extends State<GenericPaginatedDropdown<T>> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _fieldKey = GlobalKey();

  final List<T> _items = [];
  T? _selected;
  List<T> _selectedMultiple = []; // For multi-select
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  String? _search;
  Timer? _debounce;
  StateSetter? _dialogSetState;

  @override
  void initState() {
    super.initState();
    if (widget.multiSelect) {
      _selectedMultiple = widget.selectedItems ?? [];
      _updateDisplayText();
    } else {
      _selected = widget.selectedItem;
      if (_selected != null) {
        _controller.text = widget.itemLabel(_selected as T);
      }
    }
  }

  void _updateDisplayText() {
    if (widget.multiSelect) {
      if (_selectedMultiple.isEmpty) {
        _controller.text = '';
      } else if (_selectedMultiple.length == 1) {
        _controller.text = widget.itemLabel(_selectedMultiple.first);
      } else {
        _controller.text = '${_selectedMultiple.length} items selected';
      }
    }
  }

  @override
  void didUpdateWidget(GenericPaginatedDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.multiSelect) {
      if (widget.selectedItems != oldWidget.selectedItems) {
        _selectedMultiple = widget.selectedItems ?? [];
        _updateDisplayText();
      }
    } else {
      if (widget.selectedItem != oldWidget.selectedItem) {
        _selected = widget.selectedItem;
        if (_selected != null) {
          _controller.text = widget.itemLabel(_selected as T);
        } else {
          _controller.clear();
        }
      }
    }

    // Handle fetchItems function change
    if (widget.fetchItems != oldWidget.fetchItems) {
      if (_items.isNotEmpty || _isLoading) {
        _resetAndRefetch();
      }
    }

    // Handle other property changes
    if (widget.itemLabel != oldWidget.itemLabel) {
      if (widget.multiSelect) {
        _updateDisplayText();
      } else if (_selected != null) {
        _controller.text = widget.itemLabel(_selected as T);
      }
    }

    if (widget.searchable != oldWidget.searchable && !widget.searchable) {
      _search = null;
      if (_items.isNotEmpty) {
        _resetAndRefetch();
      }
    }
  }

  void _resetAndRefetch() {
    setState(() {
      _items.clear();
      _page = 1;
      _hasMore = true;
      _search = null;
    });

    if (!_isLoading) {
      _fetchData(reset: true);
    }
  }

  void _showDropdown() {
    if (!mounted) return;

    final RenderBox? box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Offset position = box.localToGlobal(Offset.zero);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double dropdownHeight = widget.dropdownHeight;

    final double spaceBelow = screenHeight - position.dy - box.size.height;
    final double spaceAbove = position.dy;
    final bool openUpwards = spaceBelow < dropdownHeight && spaceAbove > spaceBelow;

    double dialogPositionFromBottom;

    if (openUpwards) {
      dialogPositionFromBottom = screenHeight - position.dy + 8;
    } else {
      dialogPositionFromBottom = screenHeight - position.dy - box.size.height - dropdownHeight - 8;
    }

    _fetchData(reset: true);

    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            _dialogSetState = setDialogState;
            return Padding(
              padding: EdgeInsets.only(
                bottom: dialogPositionFromBottom,
                left: position.dx,
                right: MediaQuery.of(context).size.width - position.dx - box.size.width,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: dropdownHeight,
                    child: _buildDropdownDialog(),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      _dialogSetState = null;
    });
  }

  Future<void> _fetchData({bool reset = false}) async {
    if (_isLoading || (!_hasMore && !reset)) return;

    setState(() => _isLoading = true);
    _dialogSetState?.call(() => _isLoading = true);

    try {
      if (reset) {
        _items.clear();
        _page = 1;
        _hasMore = true;
      }

      final result = await widget.fetchItems(_page, _search);

      if (mounted) {
        List<T> filtered;
        if (widget.multiSelect) {
          filtered = result.where((item) => !_selectedMultiple.contains(item)).toList();
        } else {
          filtered = result.where((item) => item != _selected).toList();
        }

        _items.addAll(filtered);
        _hasMore = result.length >= widget.pageSize;

        if (result.isNotEmpty) {
          _page++;
        }

        setState(() {});
        _dialogSetState?.call(() {});
      }
    } catch (e) {
      print('Error loading items: $e');
      if (mounted) {
        setState(() => _hasMore = false);
        _dialogSetState?.call(() => _hasMore = false);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _dialogSetState?.call(() => _isLoading = false);
      }
    }
  }

  void _onSearchChanged(String value) {
    _search = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        _fetchData(reset: true);
      }
    });
  }

  void _selectItem(T item) {
    if (widget.multiSelect) {
      setState(() {
        if (_selectedMultiple.contains(item)) {
          _selectedMultiple.remove(item);
        } else {
          _selectedMultiple.add(item);
        }
        _updateDisplayText();
      });
      _dialogSetState?.call(() {});
      widget.onMultiChanged?.call(_selectedMultiple);
    } else {
      setState(() {
        _selected = item;
        _controller.text = widget.itemLabel(item);
      });
      widget.onChanged?.call(item);
      Navigator.pop(context);
    }
  }

  void _clearSelection() {
    setState(() {
      if (widget.multiSelect) {
        _selectedMultiple.clear();
        _updateDisplayText();
        widget.onMultiChanged?.call(_selectedMultiple);
      } else {
        _selected = null;
        _controller.clear();
        widget.onChanged?.call(null);
      }
    });
  }

  Widget _buildAnchorField() {
    return GestureDetector(
      onTap: _showDropdown,
      child: Container(
        key: _fieldKey,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _getDisplayText(),
                style: TextStyle(
                  fontSize: 16,
                  color: _hasSelection()
                      ? Colors.black87
                      : Colors.grey.shade600,
                ),
              ),
            ),
            if (_hasSelection())
              GestureDetector(
                onTap: _clearSelection,
                child: const Icon(Icons.clear, size: 20, color: Colors.grey),
              )
            else
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey.shade600,
              ),
          ],
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (widget.multiSelect) {
      if (_selectedMultiple.isEmpty) {
        return widget.hintText;
      } else if (_selectedMultiple.length == 1) {
        return widget.itemLabel(_selectedMultiple.first);
      } else {
        return '${_selectedMultiple.length} items selected';
      }
    } else {
      return _selected != null ? widget.itemLabel(_selected as T) : widget.hintText;
    }
  }

  bool _hasSelection() {
    return widget.multiSelect ? _selectedMultiple.isNotEmpty : _selected != null;
  }

  Widget _buildDropdownDialog() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (widget.searchable)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          if (widget.searchable) const Divider(height: 1),
          if (widget.multiSelect && _selectedMultiple.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_selectedMultiple.length} item(s) selected',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
          if (widget.multiSelect && _selectedMultiple.isNotEmpty) const Divider(height: 1),
          Expanded(
            child: _DropdownListView(
              items: _items,
              selected: _selected,
              selectedMultiple: _selectedMultiple,
              hasMore: _hasMore,
              isLoading: _isLoading,
              search: _search,
              onSelectItem: _selectItem,
              onLoadMore: () => _fetchData(),
              itemLabel: widget.itemLabel,
              itemBuilder: widget.itemBuilder,
              multiSelect: widget.multiSelect,
            ),
          ),
        ],
      ),
    );
  }

  // Getter for selected items (for external use)
  List<T> get selectedItems => widget.multiSelect ? _selectedMultiple : (_selected != null ? [_selected!] : []);

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.heading != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: widget.heading!,
          ),
        _buildAnchorField(),
      ],
    );
  }
}

class _DropdownListView<T> extends StatefulWidget {
  const _DropdownListView({
    required this.items,
    required this.selected,
    required this.selectedMultiple,
    required this.hasMore,
    required this.isLoading,
    required this.search,
    required this.onSelectItem,
    required this.onLoadMore,
    required this.itemLabel,
    required this.multiSelect,
    this.itemBuilder,
  });

  final List<T> items;
  final T? selected;
  final List<T> selectedMultiple;
  final bool hasMore;
  final bool isLoading;
  final String? search;
  final void Function(T) onSelectItem;
  final VoidCallback onLoadMore;
  final String Function(T) itemLabel;
  final Widget Function(T)? itemBuilder;
  final bool multiSelect;

  @override
  State<_DropdownListView<T>> createState() => _DropdownListViewState<T>();
}

class _DropdownListViewState<T> extends State<_DropdownListView<T>> {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer(const Duration(milliseconds: 200), () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50 &&
          !widget.isLoading &&
          widget.hasMore) {
        widget.onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showSelected;
    if (widget.multiSelect) {
      showSelected = widget.selectedMultiple.isNotEmpty &&
          (widget.search == null || widget.search!.isEmpty);
    } else {
      showSelected = widget.selected != null &&
          (widget.search == null ||
              widget.search!.isEmpty ||
              widget.itemLabel(widget.selected!).toLowerCase().contains(widget.search!.toLowerCase()));
    }

    int selectedCount = widget.multiSelect ? widget.selectedMultiple.length : (showSelected ? 1 : 0);
    final totalCount = widget.items.length +
        selectedCount +
        (selectedCount > 0 && widget.items.isNotEmpty ? 1 : 0) +
        (widget.hasMore || widget.isLoading ? 1 : 0);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: totalCount,
        itemBuilder: (context, index) {
          int idx = index;

          // Show selected items at top
          if (showSelected && idx < selectedCount) {
            T selectedItem;
            if (widget.multiSelect) {
              selectedItem = widget.selectedMultiple[idx];
            } else {
              selectedItem = widget.selected!;
            }

            return InkWell(
              onTap: () => widget.onSelectItem(selectedItem),
              child: Container(
                color: Colors.blue.shade50,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      widget.multiSelect ? Icons.check_box : Icons.check_circle,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.itemBuilder?.call(selectedItem) ??
                              Text(
                                widget.itemLabel(selectedItem),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                          Text(
                            widget.multiSelect ? "Selected" : "Currently selected",
                            style: const TextStyle(fontSize: 11, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Show divider after selected items
          if (showSelected && idx == selectedCount && widget.items.isNotEmpty) {
            return const Divider(height: 1, thickness: 1);
          }

          // Adjust index for selected items and divider
          if (showSelected) {
            idx -= (selectedCount + (widget.items.isNotEmpty ? 1 : 0));
          }

          // Show regular items
          if (idx < widget.items.length) {
            final item = widget.items[idx];
            final isSelected = widget.multiSelect ? widget.selectedMultiple.contains(item) : item == widget.selected;

            return InkWell(
              onTap: () => widget.onSelectItem(item),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    if (widget.multiSelect)
                      Icon(
                        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                        color: isSelected ? Colors.blue : Colors.grey,
                        size: 20,
                      ),
                    if (widget.multiSelect) const SizedBox(width: 12),
                    Expanded(
                      child: widget.itemBuilder?.call(item) ??
                          Text(
                            widget.itemLabel(item),
                            style: const TextStyle(fontSize: 14),
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Show loading indicator at bottom
          if (widget.isLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
