class AppData {
  static String server_url = 'http://192.168.1.54/toplearn_shop/connect.php/';

  static bool checkMobileNumber(String number) {
    bool res = false;
    dynamic mobile = int.tryParse(number);

    if (mobile != null) {
      if (mobile.toString().length == 10) {
        if (mobile.toString().substring(0, 1) == '9') {
          res = true;
        }
      }
    }
    return res;
  }
}
