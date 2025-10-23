// lib/core/helpers/app_dialogs.dart
import 'package:flutter/material.dart';

/// AppDialogs
/// - Loading (مودال لايمكن إغلاقه)
/// - Success / Error / Info
/// - Confirm (نعم / لا) مع Callbacks
/// - BottomSheet مخصص
///
class AppDialogs {
  AppDialogs._(); // static only

  // ----- Helpers -----
  static TextDirection _dir([bool rtl = true]) =>
      rtl ? TextDirection.rtl : TextDirection.ltr;

  static final ShapeBorder _dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

  static const EdgeInsets _contentPadding = EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 18,
  );

  // ------- Loading -------
  /// showLoading: يظهر مودال لا يمكن غلقه
  /// AppDialogs.showLoading(context, message: 'جاري حفظ البيانات...');
static void showLoading(
  BuildContext context, {
  String? message,
  bool rtl = true,
}) {
  showDialog(
    barrierDismissible: true, // ✅ السماح بالإغلاق عند الضغط خارج الديالوج
    context: context,
    builder: (c) => Directionality(
      textDirection: _dir(rtl),
      child: WillPopScope(
        onWillPop: () async => true, // ✅ السماح بالإغلاق بزر الرجوع أيضًا
        child: Dialog(
          shape: _dialogShape,
          child: Padding(
            padding: _contentPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 6),
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    message ?? 'جاري التحميل...',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  /// hideLoading: يقفل المودال لو مفتوح
  /// AppDialogs.hideLoading(context);

  static void hideLoading(BuildContext context) {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  // ------- Generic dialog renderer -------
  static Future<T?> _showBase<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
    bool rtl = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (c) => Directionality(
            textDirection: _dir(rtl),
            child: Dialog(shape: _dialogShape, child: child),
          ),
    );
  }

  // ------- Success / Error / Info -------
  // AppDialogs.showSuccess(
  //   context,
  //   title: 'تم بنجاح',
  //   message: 'تم حفظ العنصر',
  //   okLabel: 'تمام',
  //   onOk: () {
  //     print("🎯 بعد ما ضغطت تمام");
  //   },
  // );
  static Future<void> showSuccess(
    BuildContext context, String s, {
    String? title,
    String? message,
    String okLabel = 'حسناً',
    VoidCallback? onOk,
    bool rtl = true,
  }) async {
    await _showBase<void>(
      context,
      rtl: rtl,
      child: Padding(
        padding: _contentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 56,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            if (title != null)
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onOk?.call();
                },
                child: Text(okLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // AppDialogs.showError(
  //   context,
  //   title: 'حدث خطأ',
  //   message: 'فشل الاتصال',
  //   onOk: () {
  //     print("🚨 حصل خطأ وتم التعامل معاه");
  //   },
  // );

  static Future<void> showError(
    BuildContext context, {
    String? title,
    String? message,
    String okLabel = 'إغلاق',
    VoidCallback? onOk,
    bool rtl = true,
  }) async {
    await _showBase<void>(
      context,
      rtl: rtl,
      child: Padding(
        padding: _contentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.red),
            const SizedBox(height: 12),
            if (title != null)
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop();
                  onOk?.call();
                },
                child: Text(okLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showInfo(
    BuildContext context, {
    String? title,
    String? message,
    String okLabel = 'موافق',
    VoidCallback? onOk,
    bool rtl = true,
  }) async {
    await _showBase<void>(
      context,
      rtl: rtl,
      child: Padding(
        padding: _contentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, size: 56, color: Colors.blue),
            const SizedBox(height: 12),
            if (title != null)
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onOk?.call();
                },
                child: Text(okLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------- Confirm -------
  // AppDialogs.showConfirm(
  //   context,
  //   title: 'تأكيد',
  //   message: 'هل أنت متأكد من الحذف؟',
  //   onConfirm: () {
  //     print("🔥 تم الحذف");
  //   },
  //   onCancel: () {
  //     print("🚫 اتلغى");
  //   },
  // );
  static Future<void> showConfirm(
    BuildContext context, {
    String? title,
    String? message,
    String confirmLabel = 'نعم',
    String cancelLabel = 'لا',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool rtl = true,
  }) async {
    await _showBase<void>(
      context,
      rtl: rtl,
      child: Padding(
        padding: _contentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCancel?.call();
                    },
                    child: Text(cancelLabel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm?.call();
                    },
                    child: Text(confirmLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------- Bottom Sheet -------
  // AppDialogs.showCustomBottomSheet(context, child: Padding(
  //   padding: const EdgeInsets.all(16.0),
  //   child: Text('محتوى البوتوم شيت'),
  // ));
  static Future<T?> showCustomBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool rtl = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (c) => Directionality(
            textDirection: _dir(rtl),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    child,
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
