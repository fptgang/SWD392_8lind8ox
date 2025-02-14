import React from "react";
import {
  Card,
  Typography,
  Space,
  Input,
  Select,
  Form,
  Button,
  Checkbox,
  InputNumber,
  Slider,
  Radio,
  Tag,
  theme,
} from "antd";
import {
  SearchOutlined,
  FilterOutlined,
  ClearOutlined,
  ShopOutlined,
  DollarOutlined,
  SortAscendingOutlined,
  TagsOutlined,
} from "@ant-design/icons";
import { FilterSidebarProps, SortOption } from "./types";

const { Title, Text } = Typography;
const { useToken } = theme;

const sortOptions: SortOption[] = [
  { label: "Newest First", value: "createdAt:desc" },
  { label: "Oldest First", value: "createdAt:asc" },
  { label: "Price: Low to High", value: "price:asc" },
  { label: "Price: High to Low", value: "price:desc" },
  { label: "Name A-Z", value: "name:asc" },
  { label: "Name Z-A", value: "name:desc" },
];

export const FilterSidebar: React.FC<FilterSidebarProps> = ({
  searchFormProps,
  sorterProps,
  priceRange,
  onPriceRangeChange,
  brands,
  selectedSort,
  onSortChange,
  loading,
}) => {
  const { token } = useToken();
  const [form] = Form.useForm();

  const handleReset = () => {
    form.resetFields();
    onPriceRangeChange([0, 1000]);
    onSortChange("createdAt:desc");
    searchFormProps.onFinish({});
  };

  return (
    <Card className="sticky top-24">
      <Form
        {...searchFormProps}
        form={form}
        layout="vertical"
        className="space-y-4"
      >
        <div>
          <Title level={5} className="flex items-center gap-2 mb-4">
            <SortAscendingOutlined />
            Sort By
          </Title>
          <Radio.Group
            value={selectedSort}
            onChange={(e) => onSortChange(e.target.value)}
            className="w-full space-y-2"
          >
            <Space direction="vertical" className="w-full">
              {sortOptions.map((option) => (
                <Radio key={option.value} value={option.value}>
                  {option.label}
                </Radio>
              ))}
            </Space>
          </Radio.Group>
        </div>

        <div>
          <Title level={5} className="flex items-center gap-2 mb-4">
            <FilterOutlined />
            Filters
          </Title>

          <Form.Item name="search" className="mb-4">
            <Input
              prefix={<SearchOutlined />}
              placeholder="Search products..."
              allowClear
            />
          </Form.Item>

          <Form.Item
            name="brandIds"
            label={
              <Space>
                <ShopOutlined />
                <Text>Brands</Text>
              </Space>
            }
          >
            <Select
              mode="multiple"
              placeholder="Select brands"
              allowClear
              options={brands?.map((brand) => ({
                label: brand.name,
                value: brand.brandId,
              }))}
              optionFilterProp="label"
              className="w-full"
              loading={loading}
            />
          </Form.Item>

          <Form.Item
            label={
              <Space>
                <DollarOutlined />
                <Text>Price Range</Text>
              </Space>
            }
          >
            <Slider
              range
              min={0}
              max={1000}
              value={priceRange}
              onChange={(value) =>
                onPriceRangeChange(value as [number, number])
              }
              tooltip={{
                formatter: (value) => `$${value}`,
              }}
            />
            <div className="flex justify-between mt-2">
              <InputNumber
                style={{ width: "45%" }}
                min={0}
                max={priceRange[1]}
                value={priceRange[0]}
                onChange={(value) =>
                  onPriceRangeChange([value || 0, priceRange[1]])
                }
                formatter={(value) => `$ ${value}`}
              />
              <InputNumber
                style={{ width: "45%" }}
                min={priceRange[0]}
                max={1000}
                value={priceRange[1]}
                onChange={(value) =>
                  onPriceRangeChange([priceRange[0], value || 1000])
                }
                formatter={(value) => `$ ${value}`}
              />
            </div>
          </Form.Item>

          <Form.Item name="inStock" valuePropName="checked">
            <Checkbox>In Stock Only</Checkbox>
          </Form.Item>

          <Form.Item name="onSale" valuePropName="checked">
            <Checkbox>
              <Space>
                <TagsOutlined />
                On Sale
              </Space>
            </Checkbox>
          </Form.Item>
        </div>

        <div className="flex gap-2">
          <Button
            type="primary"
            htmlType="submit"
            icon={<FilterOutlined />}
            block
          >
            Apply Filters
          </Button>
          <Button onClick={handleReset} icon={<ClearOutlined />}>
            Reset
          </Button>
        </div>
      </Form>

      {/* Active Filters Display */}
      <div className="mt-4">
        <Text type="secondary" className="text-sm">
          Active Filters:
        </Text>
        <div className="mt-2 flex flex-wrap gap-2">
          {searchFormProps.form?.getFieldValue("search") && (
            <Tag
              closable
              onClose={() => {
                form.setFieldValue("search", "");
                searchFormProps.onFinish(form.getFieldsValue());
              }}
            >
              Search: {searchFormProps.form?.getFieldValue("search")}
            </Tag>
          )}
          {searchFormProps.form
            ?.getFieldValue("brandIds")
            ?.map((brandId: number) => {
              const brand = brands?.find((b) => b.brandId === brandId);
              return (
                <Tag
                  key={brandId}
                  closable
                  onClose={() => {
                    const currentBrands = form
                      .getFieldValue("brandIds")
                      .filter((id: number) => id !== brandId);
                    form.setFieldValue("brandIds", currentBrands);
                    searchFormProps.onFinish(form.getFieldsValue());
                  }}
                >
                  Brand: {brand?.name}
                </Tag>
              );
            })}
          {searchFormProps.form?.getFieldValue("inStock") && (
            <Tag
              closable
              onClose={() => {
                form.setFieldValue("inStock", false);
                searchFormProps.onFinish(form.getFieldsValue());
              }}
            >
              In Stock Only
            </Tag>
          )}
          {searchFormProps.form?.getFieldValue("onSale") && (
            <Tag
              closable
              onClose={() => {
                form.setFieldValue("onSale", false);
                searchFormProps.onFinish(form.getFieldsValue());
              }}
            >
              On Sale
            </Tag>
          )}
        </div>
      </div>
    </Card>
  );
};
