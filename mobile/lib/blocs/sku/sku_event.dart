abstract class StockKeepingUnitEvent {}

class GetStockKeepingUnits extends StockKeepingUnitEvent {
  final int pageKey;

  GetStockKeepingUnits(this.pageKey);
}

class GetNewReleaseStockKeepingUnits extends StockKeepingUnitEvent {}

class UpdateFilter extends StockKeepingUnitEvent {
  final String filter;

  UpdateFilter(this.filter);
}

class RefreshStockKeepingUnits extends StockKeepingUnitEvent {}
