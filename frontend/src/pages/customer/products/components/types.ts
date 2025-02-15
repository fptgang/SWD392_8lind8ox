import {
  BlindBoxDto,
  BrandDto,
  StockKeepingUnitDto,
} from "../../../../../generated";

export interface FilterSidebarProps {
  searchFormProps: any;
  sorterProps: any;
  priceRange: [number, number];
  onPriceRangeChange: (range: [number, number]) => void;
  brands?: BrandDto[];
  selectedSort: string;
  onSortChange: (sort: string) => void;
  loading?: boolean;
}

export interface ProductCardProps {
  blindBox: BlindBoxDto;
  onCardClick: (id: number) => void;
  onAddToCart: (blindBox: BlindBoxDto, sku: StockKeepingUnitDto) => void;
}

export interface SortOption {
  label: string;
  value: string;
}
