import 'dart:io';

class InternetService {
  Future<bool> checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.kindacode.com');
      if (response.isNotEmpty) {
        return true;
      }
    } on SocketException catch (err) {
      return false;
    }
    return false;
  }
}
