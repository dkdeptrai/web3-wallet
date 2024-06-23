abstract class MarketService {
  Stream getStream();
  void subscribeToMarketUpdates(dynamic Function(dynamic) onData);
}
