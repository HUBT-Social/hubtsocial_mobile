import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import '../../utils/validators.dart';

class InputField extends StatefulWidget {
  const InputField({
    required this.controller,
    required this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.hintText,
    this.prefixIcon,
    this.autofillHints,
    this.validator,
    this.onFieldSubmitted,
    super.key,
  });

  const InputField.name({
    required TextEditingController controller,
    String? errorText,
    String hintText = 'Name',
    Widget? prefixIcon,
    TextInputAction textInputAction = TextInputAction.next,
    Key? key,
  }) : this(
          key: key,
          controller: controller,
          textInputAction: textInputAction,
          keyboardType: TextInputType.name,
          errorText: errorText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          autofillHints: const [AutofillHints.name],
          validator: Validators.required,
        );

  const InputField.email({
    required TextEditingController controller,
    String? errorText,
    String hintText = 'Email',
    Widget? prefixIcon,
    TextInputAction textInputAction = TextInputAction.next,
    Key? key,
  }) : this(
          key: key,
          controller: controller,
          textInputAction: textInputAction,
          keyboardType: TextInputType.emailAddress,
          errorText: errorText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          autofillHints: const [AutofillHints.email],
          validator: Validators.email,
        );

  const InputField.password({
    required TextEditingController controller,
    String? errorText,
    String hintText = 'Password',
    Widget? prefixIcon,
    TextInputAction textInputAction = TextInputAction.next,
    ValueChanged<String>? onFieldSubmitted,
    Key? key,
  }) : this(
          key: key,
          controller: controller,
          textInputAction: textInputAction,
          keyboardType: TextInputType.visiblePassword,
          autofillHints: const [AutofillHints.password],
          errorText: errorText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          validator: Validators.password,
          onFieldSubmitted: onFieldSubmitted,
        );

  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String? errorText;
  final String? hintText;
  final Widget? prefixIcon;
  final List<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscureText;
  late bool _isPassword;

  @override
  void initState() {
    _isPassword = widget.keyboardType == TextInputType.visiblePassword;
    _obscureText = _isPassword;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InputField oldWidget) {
    if (oldWidget.keyboardType != widget.keyboardType) {
      _isPassword = widget.keyboardType == TextInputType.visiblePassword;
      _obscureText = _isPassword;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final validator =
        widget.validator ?? Validators.getValidator(widget.keyboardType);

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      validator: validator,
      autofillHints: widget.autofillHints,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: context.colorScheme.outline),
        ),
        counterStyle: context.textTheme.bodyLarge
            ?.copyWith(color: context.colorScheme.onSurface),
        hintStyle: context.textTheme.bodyLarge
            ?.copyWith(color: context.colorScheme.outline),
        errorText: widget.errorText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        prefixIconColor: widget.errorText == null
            ? context.colorScheme.primary
            : context.colorScheme.error,
        suffixIconColor: widget.errorText == null
            ? context.colorScheme.primary
            : context.colorScheme.error,
        suffixIcon: _isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscureText = !_obscureText),
                icon: _obscureText
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility_sharp),
              )
            : null,
      ),
    );
  }
}
