import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/config/app_colors.dart';

class Dialogs {
  static Future<void> showLoading(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return const _Dialog();
      },
    );
  }

  static void close(
    BuildContext context, {
    bool mounted = true,
  }) {
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }

  static Future<void> showErrorDialogWithMessage(
      BuildContext context, String message) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogCtx) {
        return _Dialog(
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_sharp,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogCtx);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showSuccessDialogWithMessage(
    BuildContext context,
    String message, {
    Function()? callBack,
  }) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return _Dialog(
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primary,
                  size: 60,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (callBack != null) {
                      callBack();
                    }
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showDialogWithMessage(
    BuildContext context,
    String message, {
    Function()? callBack,
    IconData? icon,
    bool showCancelBtn = true,
    Widget? title,
  }) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogCtx) {
        return _AlertDialog(
          title: title,
          actions: [
            if (showCancelBtn)
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(dialogCtx).pop();
                },
              ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                if (callBack != null) {
                  callBack();
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: AppColors.primary,
                    size: 60,
                  ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showDialogWithContent(
    BuildContext context,
    Widget content, {
    Function()? callBack,
    IconData? icon,
    bool showCancelBtn = true,
    Widget? title,
  }) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogCtx) {
        return _AlertDialog(
          title: title,
          actions: [
            if (showCancelBtn)
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(dialogCtx).pop();
                },
              ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                if (callBack != null) {
                  callBack();
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: AppColors.primary,
                    size: 60,
                  ),
                const SizedBox(
                  height: 15,
                ),
                content,
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Dialog extends StatelessWidget {
  const _Dialog({
    this.content,
  });

  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: content ??
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                Text('Cargando')
              ],
            ),
      ),
    );
  }
}

class _AlertDialog extends StatelessWidget {
  const _AlertDialog({
    this.content,
    this.actions,
    this.title,
  });

  final Widget? content;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: title,
      actions: actions,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: content ??
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                Text('Cargando')
              ],
            ),
      ),
    );
  }
}
