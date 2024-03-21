import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum EditableType {
  textField,
  date,
  selector,
}

class FciEditableTextField extends StatefulWidget {
  const FciEditableTextField({
    super.key,
    this.content,
    this.hintText = '',
    this.labelText,
    this.onEditPressed,
    this.inputFormatters,
    this.maxLength = 30,
    this.minLength = 0,
    this.onDataSelected,
    this.errorText = '',
  })  : type = EditableType.textField,
        options = const [];

  const FciEditableTextField.datePicker({
    super.key,
    this.content,
    this.hintText = '',
    this.labelText,
    this.onDataSelected,
    this.minLength = 0,
  })  : onEditPressed = null,
        inputFormatters = null,
        errorText = '',
        options = const [],
        maxLength = 10,
        type = EditableType.date;

  const FciEditableTextField.selector({
    super.key,
    this.content,
    this.hintText = '',
    this.labelText,
    this.onDataSelected,
    this.minLength = 0,
    this.options = const [],
  })  : onEditPressed = null,
        inputFormatters = null,
        maxLength = 10,
        errorText = '',
        type = EditableType.selector;

  final String? content;
  final String hintText;
  final String errorText;
  final String? labelText;

  final VoidCallback? onEditPressed;
  final ValueChanged<String>? onDataSelected;

  final EditableType type;

  final List<TextInputFormatter>? inputFormatters;
  final int maxLength;
  final int minLength;
  final List<String> options;

  @override
  // ignore: library_private_types_in_public_api
  _FciEditableTextFieldNameState createState() =>
      _FciEditableTextFieldNameState();
}

class _FciEditableTextFieldNameState extends State<FciEditableTextField> {
  final ctrl = TextEditingController();

  bool _editing = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    ctrl.text = widget.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!_editing) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.5),
        child: IntrinsicWidth(
          child: Row(
            children: [
              Text(
                ctrl.text.isEmpty ? widget.hintText : ctrl.text,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: Icon(_editing ? Icons.check : Icons.edit),
                color: theme.colorScheme.secondary,
                onPressed: _handleOnPressed,
              ),
            ],
          ),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            controller: ctrl,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              hintText: widget.hintText,
              labelText: widget.labelText,
              errorText: _hasError ? widget.errorText : null,
            ),
            onSubmitted: (_) => _finishEditing(),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 50,
          height: 32,
          child: IconButton(
            icon: Icon(_editing ? Icons.check : Icons.edit),
            color: theme.colorScheme.secondary,
            onPressed: _editing ? _finishEditing : _onEdit,
          ),
        ),
      ],
    );
  }

  void _handleOnPressed() {
    switch (widget.type) {
      case EditableType.textField:
        _editing ? _finishEditing() : _onEdit();
        break;
      case EditableType.date:
        _selectDate(context);
        break;
      case EditableType.selector:
        _showOptionsDialog();
        break;
      default:
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1940, 1, 1),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      if (mounted) {
        ctrl.clear();
        setState(() {
          final dt = DateTime(
            picked.year,
            picked.month,
            picked.day,
          );
          ctrl.text = DateFormat.yMd('es').format(dt);
          if (widget.onDataSelected != null) {
            widget.onDataSelected!(ctrl.text);
          }
        });
      }
    }
  }

  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Selecciona una opción'),
          children: widget.options
              .map(
                (option) => SimpleDialogOption(
                  child: Text(option),
                  onPressed: () {
                    setState(() {
                      if (widget.onDataSelected != null) {
                        widget.onDataSelected!(option);
                      }
                      ctrl.text = option;
                    });
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }

  void _onEdit() {
    setState(() {
      _editing = true;
    });
  }

  void _finishEditing() {
    setState(() {
      validateErrors();
      if (!_hasError) {
        _hasError = false;
        _editing = false;
        if (widget.content == ctrl.text) return;
        if (widget.onDataSelected != null) {
          widget.onDataSelected!(ctrl.text);
        }
      }
    });
  }

  void validateErrors() {
    if (ctrl.text.length < widget.minLength) {
      _hasError = true;
      return;
    }
    _hasError = false;
  }
}
