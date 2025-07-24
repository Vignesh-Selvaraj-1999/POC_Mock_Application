import 'dart:async';
import 'package:flutter/material.dart';

typedef FetchItems<T> = Future<List<T>> Function(int page, String? search);
typedef LabelBuilder<T> = String Function(T item);
typedef ItemBuilder<T> = Widget Function(T item);


class GenericPaginatedDropdown<T> extends StatefulWidget {
  const GenericPaginatedDropdown({
    super.key,
    required this.fetchItems,
    required this.onChanged,
    required this.itemLabel,
    this.itemBuilder,
    this.selectedItem,
    this.hintText = 'Select item',
    this.isLoadingExternally = false,
    this.errorStyle,
    this.fontFamily,
    this.searchable = true,
    this.heading,
    this.viewportKey,
  });

  final FetchItems<T> fetchItems;
  final void Function(T?)? onChanged;
  final T? selectedItem;
  final String hintText;
  final LabelBuilder<T> itemLabel;
  final ItemBuilder<T>? itemBuilder;
  final bool isLoadingExternally;
  final TextStyle? errorStyle;
  final String? fontFamily;
  final bool searchable;
  final Widget? heading;
  final GlobalKey? viewportKey;
  @override
  GenericPaginatedDropdownState<T> createState() => GenericPaginatedDropdownState<T>();
}

class GenericPaginatedDropdownState<T> extends State<GenericPaginatedDropdown<T>>
    with TickerProviderStateMixin {
  final TextEditingController _anchorController = TextEditingController();
  final FocusNode _anchorFocusNode = FocusNode();
  final GlobalKey _dropdownKey = GlobalKey();

  late final FocusScopeNode _overlayScope;
  late final AnimationController _animController;
  late final Animation<double> _opacityAnim;

  final List<T> _items = [];
  T? _selected;
  bool _expanded = false;
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  String? _search;
  Timer? _debounce;
  bool _isOpeningUpwards = false;
  @override
  void initState() {
    super.initState();
    _selected = widget.selectedItem;
    if (_selected != null) {
      _anchorController.text = widget.itemLabel(_selected as T);
    }

    _overlayScope = FocusScopeNode(debugLabel: 'DropdownOverlay');
    _overlayScope.addListener(_onOverlayFocusChange);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacityAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  double _spaceBelow(RenderBox anchorBox) {
    final anchorBottom = anchorBox.localToGlobal(Offset.zero).dy + anchorBox.size.height;
    final double bottomLimit = widget.viewportKey != null
        ? (widget.viewportKey!.currentContext!.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero)
        .dy
        + (widget.viewportKey!.currentContext!.size!.height)
        : MediaQuery.of(context).size.height;
    return bottomLimit - anchorBottom;
  }

  double _spaceAbove(RenderBox anchorBox) {
    final anchorTop = anchorBox.localToGlobal(Offset.zero).dy;
    final double topLimit = widget.viewportKey != null
        ? (widget.viewportKey!.currentContext!.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero)
        .dy
        : 0.0;
    return anchorTop - topLimit;
  }


  @override
  void didUpdateWidget(covariant GenericPaginatedDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      setState(() {
        _selected = widget.selectedItem;
        _anchorController.text = _selected != null
            ? widget.itemLabel(_selected as T)
            : '';
      });
    }
  }

  void closeIfTappedOutside(Offset globalPosition) {
    if (!_expanded) return;
    final RenderBox? rb = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (rb != null) {
      final local = rb.globalToLocal(globalPosition);
      if (!rb.size.contains(local)) _collapse();
    }
  }

  void _onOverlayFocusChange() {
    if (!_overlayScope.hasFocus && _expanded) _collapse();
  }

  void _toggleExpand() {
    final box = context.findRenderObject() as RenderBox;
    const double kMinHeightNeeded = 300;            // height of your overlay

    final bool openUpwards = _spaceBelow(box) < kMinHeightNeeded &&
        _spaceAbove(box)  > _spaceBelow(box);

    _isOpeningUpwards = openUpwards;
    if (_expanded) {
      _collapse();
    } else {
      setState(() => _expanded = true);
      _fetchData(reset: true);
      _animController.forward(from: 0);
      Future.microtask(() => _overlayScope.requestFocus());
    }
    debugPrint('below=${_spaceBelow(box)}  above=${_spaceAbove(box)}');

  }

  void _collapse() {
    if (!_expanded) return;
    setState(() => _expanded = false);
    _animController.reverse();
    _anchorFocusNode.requestFocus();
  }

  Future<void> _fetchData({bool reset = false}) async {
    if (_isLoading || (!_hasMore && !reset)) return;
    _isLoading = true;
    if (reset) {
      _items.clear();
      _page = 1;
      _hasMore = true;
    }
    final result = await widget.fetchItems(_page, _search);
    setState(() {
      final filtered = result.where((item) => item != _selected).toList();
      _items.addAll(filtered);
      _hasMore = result.length >= 10;
      _isLoading = false;
      _page++;
    });
  }

  void _onSearchChanged(String value) {
    _search = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchData(reset: true);
    });
  }

  void _selectItem(T item) {
    setState(() {
      _selected = item;
      _anchorController.text = widget.itemLabel(item);
    });
    widget.onChanged?.call(item);
    _collapse();
  }

  bool _shouldShowSelectedAtTop() {
    return _selected != null &&
        (_search == null ||
            _search!.isEmpty ||
            widget.itemLabel(_selected!).toLowerCase().contains(_search!.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.heading != null)
              Padding(                         // spacing is optional
                padding: const EdgeInsets.only(bottom: 6.0),
                child: widget.heading!,
              ),
            _expanded ? _buildDropdown() : _buildAnchorField(),
          ],
        )
    );
  }

  Widget _buildAnchorField() {
    return TextField(
      controller: _anchorController,
      focusNode: _anchorFocusNode,
      readOnly: true,
      style: widget.fontFamily != null
          ? TextStyle(fontFamily: widget.fontFamily)
          : null,
      onTap: _toggleExpand,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        border: const OutlineInputBorder(),
        suffixIcon: _selected != null
            ? IconButton(
          icon: const Icon(Icons.clear, size: 20),
          onPressed: () {
            setState(() => _selected = null);
            _anchorController.clear();
            widget.onChanged?.call(null);
          },
        )
            : null,
        errorStyle: widget.errorStyle ??
            const TextStyle(fontSize: 12, color: Colors.red),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    final showSel = _shouldShowSelectedAtTop();
    final totalCount = _items.length +
        (showSel ? 1 : 0) +
        (showSel && _items.isNotEmpty ? 1 : 0) +
        (_hasMore ? 1 : 0);

    return Align(
      alignment: _isOpeningUpwards ? Alignment.bottomCenter : Alignment.topCenter,
      child: FadeTransition(
        key: _dropdownKey,
        opacity: _opacityAnim,
        child: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          child: FocusScope(
            node: _overlayScope,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          autofocus: widget.searchable,
                          readOnly: !widget.searchable,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.arrow_drop_up),
                              onPressed: _collapse,
                            ),
                            hintText: widget.searchable ? 'Search...' : widget.hintText,
                            hintStyle:
                            const TextStyle(color: Colors.black, fontSize: 14),
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                   const Divider(height: 1),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (n) {
                          if (n.metrics.pixels == n.metrics.maxScrollExtent && !_isLoading) {
                            _fetchData();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount: totalCount,
                          itemBuilder: (context, index) {
                            int idx = index;

                            if (showSel && idx == 0) {
                              // Currently selected
                              return Container(
                                color: Colors.blue.shade50,
                                child: ListTile(
                                  leading: const Icon(Icons.check_circle,
                                      color: Colors.blue, size: 20),
                                  title: widget.itemBuilder?.call(_selected as T) ??
                                      Text(
                                        widget.itemLabel(_selected as T),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                  subtitle: const Text(
                                    "Currently selected",
                                    style:
                                    TextStyle(fontSize: 11, color: Colors.blue),
                                  ),
                                  onTap: () => _selectItem(_selected as T),
                                ),
                              );
                            }

                            if (showSel && idx == 1 && _items.isNotEmpty) {
                              return const Divider(height: 1, thickness: 1);
                            }

                            if (showSel) {
                              idx -= (1 + (_items.isNotEmpty ? 1 : 0));
                            }

                            if (idx < _items.length) {
                              final item = _items[idx];
                              return ListTile(
                                title: widget.itemBuilder?.call(item) ??
                                    Text(
                                      widget.itemLabel(item),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                onTap: () => _selectItem(item),
                              );
                            }

                            // loading indicator
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
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _overlayScope.removeListener(_onOverlayFocusChange);
    _overlayScope.dispose();
    _anchorController.dispose();
    _anchorFocusNode.dispose();
    _animController.dispose();
    super.dispose();
  }
}
