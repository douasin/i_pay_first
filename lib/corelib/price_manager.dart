import 'package:decimal/decimal.dart';

final int dbPriceInflationFactor = 100000;

int inflatePrice(String price) {
  return (Decimal.parse(price) * Decimal.fromInt(dbPriceInflationFactor))
      .toInt();
}

Decimal deflatePrice(int price) {
  Decimal decimalPrice = Decimal.parse(price.toString());
  return decimalPrice / Decimal.parse(dbPriceInflationFactor.toString());
}
