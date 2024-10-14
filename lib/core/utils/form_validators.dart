class FormValidators {
  // Validate integer fields
  static String? validateInteger(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    final intValue = int.tryParse(value);
    if (intValue == null) {
      return '$fieldName must be a valid integer';
    }
    return null;
  }

  // Validate double fields
  static String? validateDouble(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return '$fieldName must be a valid number';
    }
    return null;
  }

  // Validate string fields
  static String? validateString(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Validate dropdown selection
  static String? validateDropdown(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please select a $fieldName';
    }
    return null;
  }
}
