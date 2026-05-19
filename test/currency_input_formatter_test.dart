import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upsm_flutter/utils/currency_input_formatter.dart';

void main() {
  group('CurrencyInputFormatter', () {
    final formatter = CurrencyInputFormatter(locale: 'en_US', symbol: '');

    test('formats digits with thousand separators', () {
      final old = TextEditingValue.empty;
      final updated = formatter.formatEditUpdate(
          old,
          const TextEditingValue(
              text: '1234', selection: TextSelection.collapsed(offset: 4)));
      expect(updated.text, '1,234');
      expect(updated.selection.baseOffset, greaterThan(0));
    });

    test('preserves caret roughly when typing in the middle', () {
      // simulate typing '5' into '1,234' after the '1' -> '15,234'
      final old = const TextEditingValue(
          text: '1,234', selection: TextSelection.collapsed(offset: 1));
      final newVal = const TextEditingValue(
          text: '15,234', selection: TextSelection.collapsed(offset: 2));
      final updated = formatter.formatEditUpdate(old, newVal);
      expect(updated.text, '15,234');
      // caret should be after the '5' -> offset > 0
      expect(updated.selection.baseOffset, greaterThanOrEqualTo(1));
    });

    test('empty input returns empty', () {
      final old = const TextEditingValue(
          text: '1,000', selection: TextSelection.collapsed(offset: 5));
      final updated = formatter.formatEditUpdate(
          old,
          const TextEditingValue(
              text: '', selection: TextSelection.collapsed(offset: 0)));
      expect(updated.text, '');
      expect(updated.selection.baseOffset, 0);
    });
  });
}
