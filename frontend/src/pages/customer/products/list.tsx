import React, { useState } from "react";
import {
  useGo,
  useList,
  CrudOperators,
  CrudSorting,
  BaseRecord,
} from "@refinedev/core";
import { List, useTable } from "@refinedev/antd";
import { Row, Col, Button, Spin, Empty, Drawer, notification } from "antd";
import { FilterOutlined } from "@ant-design/icons";
import {
  BlindBoxDto,
  BrandDto,
  StockKeepingUnitDto,
} from "../../../../generated";
import { FilterSidebar } from "./components/FilterSidebar";
import { ProductCard } from "./components/ProductCard";

const CustomerProducts: React.FC = () => {
  const go = useGo();
  const [mobileFiltersVisible, setMobileFiltersVisible] = useState(false);
  const [priceRange, setPriceRange] = useState<[number, number]>([0, 1000]);
  const [selectedSort, setSelectedSort] = useState("createdAt:desc");

  const { tableProps, searchFormProps, sorters, setSorters } =
    useTable<BlindBoxDto>({
      syncWithLocation: true,
      resource: "blind-boxes",
      onSearch: (values) => {
        const filters = [];
        const { search, brandIds, inStock, onSale } = values;

        if (search) {
          filters.push({
            field: "search",
            operator: "contains" as CrudOperators,
            value: search,
          });
        }

        if (brandIds?.length) {
          filters.push({
            field: "brand.brandId",
            operator: "in" as CrudOperators,
            value: brandIds,
          });
        }

        if (priceRange[0] > 0 || priceRange[1] < 1000) {
          filters.push({
            field: "price",
            operator: "between" as CrudOperators,
            value: priceRange,
          });
        }

        if (inStock) {
          filters.push({
            field: "stock",
            operator: "gt" as CrudOperators,
            value: 0,
          });
        }

        if (onSale) {
          filters.push({
            field: "promotionalCampaignId",
            operator: "isNotNull" as CrudOperators,
            value: true,
          });
        }

        return filters;
      },
      sorters: {
        initial: [
          {
            field: "createdAt",
            order: "desc",
          },
        ],
      },
    });

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
    notification.success({
      message: "Added to Cart",
      description: `${blindBox.name} - ${sku.name} has been added to your cart.`,
    });
  };

  return (
    <List>
      <Row gutter={[24, 24]}>
        {/* Desktop Filters */}
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

        {/* Mobile Filters Button & Drawer */}
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

        {/* Products Grid */}
        <Col xs={24} md={18}>
          {tableProps.loading ? (
            <div className="flex justify-center items-center min-h-[400px]">
              <Spin size="large" />
            </div>
          ) : !tableProps.dataSource?.length ? (
            <Empty
              image={Empty.PRESENTED_IMAGE_SIMPLE}
              description="No products found"
            />
          ) : (
            <Row gutter={[16, 16]}>
              {tableProps.dataSource?.map((blindBox: BaseRecord) => (
                <Col xs={24} sm={12} lg={8} key={blindBox.blindBoxId}>
                  <ProductCard
                    blindBox={blindBox}
                    onCardClick={handleCardClick}
                    onAddToCart={handleAddToCart}
                  />
                </Col>
              ))}
            </Row>
          )}
        </Col>
      </Row>
    </List>
  );
};

export default CustomerProducts;
