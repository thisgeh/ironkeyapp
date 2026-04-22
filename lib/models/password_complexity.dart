enum PasswordComplexity { low, medium, high }

extension PasswordComplexityExtension on PasswordComplexity {
  String get title {
    switch (this) {
      case PasswordComplexity.low:
        return 'Baixa';
      case PasswordComplexity.medium:
        return 'Média';
      case PasswordComplexity.high:
        return 'Alta';
    }
  }

  int get length {
    switch (this) {
      case PasswordComplexity.low:
        return 4;
      case PasswordComplexity.medium:
        return 4;
      case PasswordComplexity.high:
        return 4;
    }
  }
}
