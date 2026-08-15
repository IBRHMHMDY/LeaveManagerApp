// lib/shared/widgets/inputs/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
    this.onChanged,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode? _localFocusNode;
  TextEditingController? _localController;

  TextEditingController get _effectiveController => widget.controller ?? _localController!;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? _localFocusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _localFocusNode = FocusNode();
    }
    if (widget.controller == null) {
      _localController = TextEditingController();
    }
  }

  @override
  void dispose() {
    // تنظيف الذاكرة (Memory Leak Prevention) للمتحكمات المحلية 
    _localFocusNode?.dispose();
    _localController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) => widget.validator?.call(_effectiveController.text),
      initialValue: _effectiveController.text,
      builder: (FormFieldState<String> state) {
        
        return AnimatedBuilder(
          animation: Listenable.merge([_effectiveFocusNode, _effectiveController]),
          builder: (context, child) {
            final isFocused = _effectiveFocusNode.hasFocus;
            final isLabelUp = isFocused || _effectiveController.text.isNotEmpty;
            final hasError = state.hasError;
            
            final borderColor = hasError
                ? context.colorScheme.error
                : isFocused
                    ? context.colorScheme.primary
                    : context.colorScheme.outline.withOpacity(0.3);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: AppRadius.md,
                      border: Border.all(
                        color: borderColor,
                        width: isFocused ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          widget.icon,
                          size: 32,
                          color: isFocused
                              ? context.colorScheme.primary
                              : context.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        
                        Expanded(
                          child: SizedBox(
                            height: 60, // تثبيت الارتفاع بعد إزالة maxLines
                            child: Stack(
                              alignment: AlignmentDirectional.centerStart,
                              children: [
                                AnimatedAlign(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOutBack,
                                  alignment: isLabelUp 
                                      ? AlignmentDirectional.topStart 
                                      : AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: isLabelUp ? 8.0 : 0.0),
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeOutCubic,
                                      style: context.textTheme.labelMedium!.copyWith(
                                        color: isFocused
                                            ? context.colorScheme.primary
                                            : context.colorScheme.onSurfaceVariant.withOpacity(0.8),
                                        fontWeight: isLabelUp ? FontWeight.bold : FontWeight.w600,
                                        fontSize: isLabelUp ? 12 : 15,
                                      ),
                                      child: Text(widget.label),
                                    ),
                                  ),
                                ),
                                child!, // الحقل المعزول لمنع إعادة البناء
                              ],
                            ),
                          ),
                        ),
                        
                        if (widget.suffixIcon != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          widget.suffixIcon!,
                        ],
                      ],
                    ),
                  ),
                  if (hasError)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.xs,
                        right: AppSpacing.md,
                        left: AppSpacing.md,
                      ),
                      child: Text(
                        state.errorText ?? '',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: _effectiveController,
                focusNode: _effectiveFocusNode,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                readOnly: widget.readOnly,
                onTap: widget.onTap,
                obscureText: widget.obscureText,
                textInputAction: widget.textInputAction,
                onChanged: (val) {
                  state.didChange(val);
                  if (widget.onChanged != null) {
                    widget.onChanged!(val);
                  }
                },
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}