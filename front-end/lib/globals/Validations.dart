class Validations {
  static Map<String, String> emailValidation = {
    'pattern': r'(^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$)',
    'errorMsg': 'Please enter a valid email'
  };

  static Map<String, String> phoneValidation = {
    'pattern': r'(^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$)',
    'errorMsg': 'Please enter a valid mobile number'
  };

  // (?=.*[a-z])	The string must contain at least 1 lowercase alphabetical character
  // (?=.*[A-Z])	The string must contain at least 1 uppercase alphabetical character
  // (?=.*[0-9])	The string must contain at least 1 numeric character
  // (?=.*[!@#$%^&*])	The string must contain at least one special character, but we are escaping reserved RegEx characters to avoid conflict
  // (?=.{8,})	The string must be eight characters or longer
  // static const passPattern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,}))';
  static Map<String, String> passValidation = {
    'pattern': r'(?=.{8,})',
    'errorMsg': 'Password must be at least 8 characters'
    // 'errorMsg': 'Please enter a strong password'
  };
}
