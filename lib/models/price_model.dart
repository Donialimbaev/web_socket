/* External Dependencies */
import 'dart:convert';

class PriceModel {
  final String symbol;
  final double price;
  PriceModel({required this.symbol, required this.price});

  static PriceModel? fromWebSocket(String data) {
    print('Parsing WebSocket data in PriceModel...');
    try {
      final json = jsonDecode(data);
      print('Decoded JSON:');
      print(json);
      final stream = json['data'];
      print('Extracted stream:');
      print(stream);
      if (stream == null) return null;
      final symbol = (stream['s'] as String).toUpperCase();
      print('Extracted symbol:');
      print(symbol);
      final priceStr = stream['p']?.toString();
      print('Extracted price string:');
      print(priceStr);
      if (priceStr == null) return null;
      final price = double.tryParse(priceStr) ?? 0.0;
      print('Parsed price:');
      print(price);
      return PriceModel(symbol: symbol, price: price);
    } catch (e) {
      print('Error parsing WebSocket data:');
      print(e);
      return null;
    }
  }
}
