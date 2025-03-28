import React, { useState, useMemo } from "react";
import {
  useGo,
  useList,
  CrudOperators,
  CrudSorting,
  CrudFilters,
  useOne,
} from "@refinedev/core";
import { List, useTable } from "@refinedev/antd";
import {
  Row,
  Col,
  Button,
  Spin,
  Empty,
  Drawer,
  notification,
  Pagination,
} from "antd";
import { FilterOutlined } from "@ant-design/icons";
import {
  BlindBoxDto,
  BrandDto,
  PromotionalCampaignDto,
  StockKeepingUnitDto,
} from "../../../../generated";
import { FilterSidebar } from "./components/FilterSidebar";
import { ProductCard } from "./components/ProductCard";
import { SkuCardProps } from "./components/types";
import { useCart } from "../../../hooks/useCart";

interface SearchFormValues {
  search?: string;
  brandIds?: number[];
  inStock?: boolean;
  onSale?: boolean;
}

// Interface to represent a SKU with its parent blind box data
interface SkuWithParent {
  sku: StockKeepingUnitDto;
  blindBox: BlindBoxDto;
}

const CustomerProducts: React.FC = () => {
  const go = useGo();
  const { addToCart } = useCart();
  const [mobileFiltersVisible, setMobileFiltersVisible] = useState(false);
  const [priceRange, setPriceRange] = useState<[number, number]>([0, 30000]);
  const [selectedSort, setSelectedSort] = useState("createdAt:desc");
  const [pageSize, setPageSize] = useState(10);
  const [current, setCurrent] = useState(1);

  const { data: promoData } = useList<PromotionalCampaignDto>({
    resource: "promotional-campaigns",
    pagination: { pageSize: 100 },
  });

  const [filters, setFilters] = useState<CrudFilters>([]);
  const [sorters, setSorters] = useState<CrudSorting>([
    {
      field: "createdAt",
      order: "desc",
    },
  ]);

  const { data, isLoading } = useList<BlindBoxDto>({
    resource: "blind-boxes",
    filters,
    sorters,
    pagination: {
      current,
      pageSize,
    },
    meta: {
      include: ["skus", "images", "blindBoxCampaigns"],
    },
  });

  const tableProps = {
    dataSource: data?.data || [],
    loading: isLoading,
  };

  const searchFormProps = {
    onFinish: (values: SearchFormValues) => {
      const newFilters: CrudFilters = [];
      const { search, brandIds, inStock, onSale } = values;

      if (search) {
        newFilters.push({
          field: "search",
          operator: "contains",
          value: search,
        });
      }

      if (brandIds?.length) {
        newFilters.push({
          field: "brand",
          operator: "in",
          value: brandIds,
        });
      }

      if (priceRange[0] > 0 || priceRange[1] < 30000) {
        newFilters.push({
          field: "skus.price",
          operator: "between",
          value: priceRange,
        });
      }

      if (inStock) {
        newFilters.push({
          field: "skus.stock",
          operator: "gt",
          value: 0,
        });
      }

      if (onSale && promoData) {
        newFilters.push({
          field: "blindBoxCampaigns.promotionalCampaign",
          operator: "in",
          value: promoData?.data?.map((pc) => pc.campaignId),
        });
      }

      setFilters(newFilters);
      setCurrent(1); // Reset to first page when filters change
    },
  };

  const { data: brandsData, isLoading: isBrandsLoading } = useList<BrandDto>({
    resource: "brands",
    pagination: { pageSize: 100 },
  });

  const handleSortChange = (sortValue: string) => {
    const [field, order] = sortValue.split(":");
    setSelectedSort(sortValue);
    setSorters([{ field, order }] as CrudSorting);
  };

  const handleCardClick = (blindBoxId: number) => {
    go({
      to: `/products/${blindBoxId}`,
    });
  };

  const handleAddToCart = (blindBox: BlindBoxDto, sku: StockKeepingUnitDto) => {
    // Find active campaign if exists
    const hasActiveCampaign =
      blindBox.blindBoxCampaigns && blindBox.blindBoxCampaigns.length > 0;
    const activePromotionalCampaign =
      hasActiveCampaign &&
      blindBox.blindBoxCampaigns &&
      blindBox.blindBoxCampaigns[0]
        ? blindBox.blindBoxCampaigns[0].promotionalCampaignId
        : undefined;

    // Calculate price with possible discount
    const skuPrice = sku.price || 0;
    // We can't directly access discountRate, so using base price
    const campaignDiscount = 0;

    const price = skuPrice;

    // Safely get image URL if it exists
    const imageUrl = blindBox.images?.[0]?.imageUrl || "";

    addToCart({
      skuId: sku.skuId || 0,
      name: `${blindBox.name || ""} - ${sku.name || ""}`,
      price: price,
      subTotal: skuPrice,
      finalTotal: price,
      stock: sku.stock || 0,
      imageUrl: imageUrl,
      blindBoxId: blindBox.blindBoxId || 0,
      promotionalCampaignId: activePromotionalCampaign,
    });

    notification.success({
      message: "Added to Cart",
      description: `${blindBox.name || ""} - ${
        sku.name || ""
      } has been added to your cart.`,
    });
  };

  // Extract all SKUs from all blind boxes and pair them with their parent
  const skusWithParents = useMemo(() => {
    const result: SkuWithParent[] = [];

    tableProps.dataSource?.forEach((blindBox) => {
      const typedBlindBox = blindBox as BlindBoxDto;

      // Skip invalid blind boxes
      if (!typedBlindBox || !typedBlindBox.blindBoxId) {
        return;
      }

      // Add each SKU with its parent blind box
      typedBlindBox.skus?.forEach((sku) => {
        if (sku && sku.skuId) {
          result.push({
            sku,
            blindBox: typedBlindBox,
          });
        }
      });
    });

    return result;
  }, [tableProps.dataSource]);

  return (
    <List>
      <Row gutter={[24, 24]}>
        <Col xs={0} md={6}>
          <FilterSidebar
            searchFormProps={searchFormProps}
            sorterProps={sorters}
            priceRange={priceRange}
            onPriceRangeChange={setPriceRange}
            brands={brandsData?.data}
            selectedSort={selectedSort}
            onSortChange={handleSortChange}
            loading={isBrandsLoading}
          />
        </Col>

        <Col xs={24} md={0}>
          <Button
            type="primary"
            icon={<FilterOutlined />}
            onClick={() => setMobileFiltersVisible(true)}
            block
          >
            Filters & Sort
          </Button>

          <Drawer
            title="Filters & Sort"
            placement="left"
            onClose={() => setMobileFiltersVisible(false)}
            open={mobileFiltersVisible}
            width={300}
          >
            <FilterSidebar
              searchFormProps={searchFormProps}
              sorterProps={sorters}
              priceRange={priceRange}
              onPriceRangeChange={setPriceRange}
              brands={brandsData?.data}
              selectedSort={selectedSort}
              onSortChange={handleSortChange}
              loading={isBrandsLoading}
            />
          </Drawer>
        </Col>

        <Col xs={24} md={18}>
          {tableProps.loading ? (
            <div className="flex justify-center items-center min-h-[400px]">
              <Spin size="large" />
            </div>
          ) : !skusWithParents.length ? (
            <Empty
              image={Empty.PRESENTED_IMAGE_SIMPLE}
              description="No products found"
            />
          ) : (
            <Row gutter={[16, 16]}>
              {skusWithParents.map(({ blindBox, sku }) => (
                <Col
                  xs={24}
                  sm={12}
                  lg={8}
                  key={`${blindBox.blindBoxId}-${sku.skuId}`}
                >
                  <ProductCard
                    blindBox={blindBox}
                    sku={sku}
                    onCardClick={handleCardClick}
                    onAddToCart={handleAddToCart}
                    promos={promoData?.data}
                  />
                </Col>
              ))}
            </Row>
          )}
          <Pagination
            className="m-4"
            total={data?.total || 0}
            pageSizeOptions={[10, 20, 50, 100]}
            current={current}
            pageSize={pageSize}
            showQuickJumper
            onChange={(page, pageSize) => {
              setCurrent(page);
              setPageSize(pageSize);
              console.log(page, pageSize);
            }}
            showSizeChanger={true}
            showTotal={(total) => `Total ${total} items`}
          />
        </Col>
      </Row>
    </List>
  );
};

export default CustomerProducts;
