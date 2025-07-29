import 'package:flutter/material.dart';
import 'input_field_config.dart';
import 'input_field_variants.dart';

class InputField extends StatefulWidget {
  final InputFieldConfig config;

  const InputField({super.key, required this.config});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.config.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (cfg.label != null)
          Padding(
            padding:
                cfg.labelPadding ??
                const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: RichText(
              text: TextSpan(
                text: cfg.label!,
                style:
                    cfg.labelStyle ??
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                children: cfg.isRequired
                    ? [
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ]
                    : [],
              ),
            ),
          ),
        TextFormField(
          controller: cfg.controller,
          focusNode: cfg.focusNode,
          enabled: cfg.enabled,
          readOnly: cfg.readOnly,
          obscureText: isObscured,
          obscuringCharacter: cfg.obscureChar,
          validator:
              cfg.validator ??
              (cfg.isRequired
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "${cfg.label ?? cfg.hint ?? "This field"} is required";
                      }
                      return null;
                    }
                  : null),
          keyboardType: cfg.keyboardType,
          textInputAction: cfg.textInputAction,
          maxLength: cfg.maxLength,
          maxLines: cfg.maxLines ?? (cfg.expands ? null : 1),
          minLines: cfg.minLines,
          expands: cfg.expands,
          textAlign: cfg.textAlign,
          style: cfg.textStyle,
          onChanged: cfg.onChanged,
          onTap: cfg.onTap,
          onFieldSubmitted: cfg.onFieldSubmitted,
          autovalidateMode: cfg.autovalidateMode,
          inputFormatters: cfg.inputFormatters,
          decoration: InputFieldVariants.resolveDecoration(context, cfg)
              .copyWith(
                suffixIcon: cfg.isPassword
                    ? IconButton(
                        icon: Icon(
                          isObscured ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () =>
                            setState(() => isObscured = !isObscured),
                      )
                    : cfg.suffixIcon,
              ),
        ),
      ],
    );
  }
}
