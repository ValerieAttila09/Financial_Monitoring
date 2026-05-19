import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// A TextInputFormatter that formats input as a locale-aware currency (no
/// fractional digits) while preserving the caret position as naturally as
/// possible during typing and deletion.
class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter;

  CurrencyInputFormatter({String locale = 'id_ID', String symbol = ''})
      : _formatter = NumberFormat.currency(
            locale: locale, symbol: symbol, decimalDigits: 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Only keep digits
    final newDigits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newDigits.isEmpty) {
      return TextEditingValue(
          text: '', selection: TextSelection.collapsed(offset: 0));
    }

    // Format the numeric value
    final parsed = int.parse(newDigits);
    final formatted = _formatter.format(parsed);

    // Compute new caret position.
    // Strategy: map the index of the previous numeric digit caret position to
    // the corresponding position in the formatted string.

    // Count how many digits are to the right of caret in the raw digits
    final oldDigits = oldValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Determine numeric caret offset from the end in the new value.
    final caretOffsetFromEnd = newDigits.length -
        newValue.selection.extentOffset.clamp(0,
            newValue.text.length - (newValue.text.length - newDigits.length));

    // A simpler and more robust approach: compute the position by placing the
    // caret relative to the number of digits typed from the left.
    final digitsBeforeCaret = newValue.selection.extentOffset -
        RegExp(r'[^0-9]')
            .allMatches(
                newValue.text.substring(0, newValue.selection.extentOffset))
            .length;

    final clampedDigitsBefore = digitsBeforeCaret.clamp(0, newDigits.length);

    // Now find the index in the formatted string that corresponds to that many digits.
    var digitCount = 0;
    var targetIndex = 0;
    for (var i = 0; i < formatted.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(formatted[i])) {
        digitCount++;
      }
      if (digitCount >= clampedDigitsBefore) {
        targetIndex = i + 1;
        break;
      }
    }
    if (digitCount < clampedDigitsBefore) {
      targetIndex = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: targetIndex),
    );
  }
}
