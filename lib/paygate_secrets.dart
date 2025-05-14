import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaygateSecret {
  static final String sslStoreID = dotenv.env['SSL_STORE_ID'] ?? 'ssl_store_id';
  static final String sslStorePassword =
      dotenv.env['SSL_STORE_PASSWORD'] ?? 'ssl_store_password';
}
