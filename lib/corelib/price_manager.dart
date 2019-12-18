import 'package:decimal/decimal.dart';

final int DB_PRICE_INFLATION_FACTOR = 100000;

int inflatePrice(num price) {
  return int.parse(Decimal.parse(price.toString()) * DB_PRICE_INFLATION_FACTOR);
}

Decimal deflatePrice(int price) {
  Decimal decimalPrice = Decimal.parse(price.toString());
  return decimalPrice / Decimal.parse(DB_PRICE_INFLATION_FACTOR.toString());
}
