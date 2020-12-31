import 'dart:math';

//   Entropy(H) = L * log2(N)
//   L = Length of password
//   N = Number of special characters

class PasswordEntropy {
  String passwordEntropy(String value) {
    double logBase(num x, num base) => log(x) / log(base);

    final n =
        RegExp(r'[!"#$%&()*+,-./:;<=>?@[\]^_`{|}~]').allMatches(value).length;

    final l = value.length;

    return (l * logBase(n, 2)).toStringAsFixed(2);
  }
}
