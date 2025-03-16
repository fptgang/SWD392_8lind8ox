import React, { useState } from "react";
import { Create, useForm, useSelect } from "@refinedev/antd";
import {
  Form,
  Input,
  Select,
  Checkbox,
  InputNumber,
  Upload,
  Button,
  Card,
  Row,
  Col,
  Typography,
  Space,
  Divider,
  notification,
  UploadFile,
} from "antd";
import {
  PlusOutlined,
  DeleteOutlined,
  InfoCircleOutlined,
} from "@ant-design/icons";
import { BlindBoxDto, BrandDto } from "../../../generated";
import axios from "axios";
import api from "../../config/openapi-config";
import WysiwygQuill from "./components/wysiwyg";

const { Title } = Typography;

export const BlindBoxesCreate = () => {
  const [blindBoxImages, setBlindBoxImages] = useState<UploadFile[]>([]);
  const [skuImages, setSkuImages] = useState<{ [key: number]: UploadFile }>({});
  const [loading, setLoading] = useState(false);

  const { formProps, saveButtonProps, onFinish, form } = useForm<BlindBoxDto>({
    onMutationSuccess: async (data) => {
      const blindBox = data.data;
      try {
        setLoading(true);

        // Upload blind box images
        if (blindBoxImages.length > 0) {
          blindBoxImages.map(async (file) => {
            await api.uploadImage({
              blindBoxId: blindBox.blindBoxId,
              imageBlob: file.originFileObj,
            });
          });
        }

        // Upload SKU images
        if (blindBox.skus) {
          console.log("Uploading SKU images...", blindBox.skus);
          blindBox.skus.map(async (sku, index) => {
            const skuFile = skuImages[index];
            if (skuFile) {
              await api.uploadImage({
                skuId: sku.skuId,
                imageBlob: skuFile.originFileObj,
              });
            }
          });
        }

        notification?.success({
          message: "Blind box created successfully with all images",
        });
      } catch (error) {
        notification?.error({
          message: "Error uploading images",
          description: "Blind box was created but some images failed to upload",
        });
      } finally {
        setLoading(false);
      }
    },
  });

  const { selectProps: brandSelectProps } = useSelect<BrandDto>({
    resource: "brands",
    optionLabel: "name",
    optionValue: "brandId",
    debounce: 300,
    pagination: { pageSize: 100 },
  });

  //   const handleBlindBoxImageUpload = (fileList: File[]) => {
  //     setBlindBoxImages(fileList);
  //   };

  //   const handleSkuImageUpload = (index: number, file: File) => {
  //     setSkuImages((prev) => ({ ...prev, [index]: file }));
  //   };

  return (
    <Create
      saveButtonProps={{
        ...saveButtonProps,
        style: { width: 150 },
        size: "large",
        loading,
      }}
    >
      <Card bordered={false} className="shadow-sm">
        <Form {...formProps} layout="vertical">
          {/* Basic Information Section */}
          <div className="mb-8">
            <Title level={5} className="mb-4 text-gray-800">
              Basic Information
            </Title>
            <Row gutter={24}>
              <Col xs={24} md={12}>
                <Form.Item
                  label={
                    <span className="font-semibold text-gray-700">Brand</span>
                  }
                  name={["brand", "brandId"]}
                  rules={[{ required: true }]}
                  tooltip={{
                    title: "Select associated brand",
                    icon: <InfoCircleOutlined />,
                  }}
                >
                  <Select
                    {...brandSelectProps}
                    placeholder="Select brand"
                    size="large"
                    showSearch
                  />
                </Form.Item>
              </Col>
              <Col xs={24} md={12}>
                <Form.Item
                  label={
                    <span className="font-semibold text-gray-700">
                      Blind Box Name
                    </span>
                  }
                  name={["name"]}
                  rules={[{ required: true }]}
                >
                  <Input
                    placeholder="Enter blind box name"
                    size="large"
                    allowClear
                  />
                </Form.Item>
              </Col>
            </Row>

            <Form.Item
              label={
                <span className="font-semibold text-gray-700">Description</span>
              }
              name="description"
              rules={[{ required: true }]}
            >
              {/* <Input.TextArea
                rows={4}
                placeholder="Detailed description..."
                showCount
                maxLength={500}
                className="resize-none"
              /> */}
              <WysiwygQuill />
            </Form.Item>

            <Form.Item
              label={
                <span className="font-semibold text-gray-700">Visibility</span>
              }
              name={["isVisible"]}
              valuePropName="checked"
            >
              <Checkbox className="text-gray-700">
                Visible to customers
              </Checkbox>
            </Form.Item>
            {/* Blind Box Images Upload */}
            <Form.Item
              label="Blind Box Images (Multiple)"
              valuePropName="blindBoxImages"
              getValueFromEvent={(e) =>
                Array.isArray(e) ? e : e && e.blindBoxImages
              }
              rules={[{ required: true }]}
            >
              <Upload
                multiple
                listType="picture-card"
                accept="image/*"
                beforeUpload={(file) => {
                  //   handleBlindBoxImageUpload([...blindBoxImages, file]);
                  return false;
                }}
                onChange={(info) => {
                  if (info.fileList.length > 0) {
                    setBlindBoxImages([...info.fileList]);
                  }
                }}
                onRemove={(file) => {
                  setBlindBoxImages((prev) =>
                    prev.filter((f) => f.name !== file.name)
                  );
                }}
                fileList={blindBoxImages as any}
              >
                <div>
                  <PlusOutlined />
                  <div style={{ marginTop: 8 }}>Upload</div>
                </div>
              </Upload>
            </Form.Item>

            <Row gutter={24}>{/* Other form items */}</Row>
          </div>

          <Divider className="my-8" />

          {/* SKU Management Section */}
          <div className="mb-6">
            <Title level={5} className="mb-4 text-gray-800">
              SKU Configuration
            </Title>
            <Form.List name="skus">
              {(fields, { add, remove }) => (
                <>
                  {fields.map(({ key, name, ...restField }, index) => (
                    <Card
                      key={key}
                      className="mb-4 shadow-sm border-0 bg-gray-50"
                      title={`SKU ${name + 1}`}
                      extra={
                        <Button
                          type="text"
                          danger
                          icon={<DeleteOutlined />}
                          onClick={() => remove(name)}
                        />
                      }
                    >
                      <Row gutter={16}>
                        <Col xs={24} md={8}>
                          <Form.Item
                            {...restField}
                            label="SKU Name"
                            name={[name, "name"]}
                            rules={[{ required: true }]}
                          >
                            <Input placeholder="Unique SKU name" allowClear />
                          </Form.Item>
                        </Col>

                        <Col xs={24} md={6}>
                          <Form.Item
                            {...restField}
                            label="Price"
                            name={[name, "price"]}
                            rules={[{ required: true }]}
                          >
                            <InputNumber
                              min={0}
                              className="w-full"
                              placeholder="0.00"
                              formatter={(value) =>
                                `$ ${value}`.replace(
                                  /\B(?=(\d{3})+(?!\d))/g,
                                  ","
                                )
                              }
                            />
                          </Form.Item>
                        </Col>

                        <Col xs={24} md={6}>
                          <Form.Item
                            {...restField}
                            label="Stock"
                            name={[name, "stock"]}
                            rules={[{ required: true }]}
                          >
                            <InputNumber
                              min={0}
                              className="w-full"
                              placeholder="Available quantity"
                            />
                          </Form.Item>
                        </Col>

                        <Col xs={24} md={4}>
                          <Form.Item
                            {...restField}
                            label="Spec Count"
                            name={[name, "specCount"]}
                            rules={[{ required: true }]}
                          >
                            <InputNumber
                              min={0}
                              className="w-full"
                              placeholder="Number of specs"
                            />
                          </Form.Item>
                        </Col>

                        <Col xs={24}>
                          <Form.Item
                            label="SKU Image (Single)"
                            rules={[{ required: true }]}
                          >
                            <Upload
                              listType="picture-card"
                              accept="image/*"
                              beforeUpload={(file) => {
                                // handleSkuImageUpload(index, file);
                                return false;
                              }}
                              onChange={(info) => {
                                if (info.fileList.length > 0) {
                                  setSkuImages((prev) => ({
                                    ...prev,
                                    [index]: info.fileList[0],
                                  }));
                                }
                              }}
                              onRemove={() => {
                                setSkuImages((prev) => {
                                  const newState = { ...prev };
                                  delete newState[index];
                                  return newState;
                                });
                              }}
                              fileList={
                                skuImages[index]
                                  ? [skuImages[index] as any]
                                  : []
                              }
                            >
                              {!skuImages[index] && (
                                <div>
                                  <PlusOutlined />
                                  <div style={{ marginTop: 8 }}>Upload</div>
                                </div>
                              )}
                            </Upload>
                          </Form.Item>
                        </Col>

                        <Col xs={24}>
                          <Form.Item
                            {...restField}
                            label="Visibility"
                            name={[name, "isVisible"]}
                            valuePropName="checked"
                          >
                            <Checkbox>Show this SKU to customers</Checkbox>
                          </Form.Item>
                        </Col>
                      </Row>
                    </Card>
                  ))}

                  <Button
                    type="dashed"
                    onClick={() => add()}
                    block
                    icon={<PlusOutlined />}
                    className="h-12 border-2 border-dashed border-blue-200 hover:border-blue-500"
                  >
                    Add New SKU
                  </Button>
                </>
              )}
            </Form.List>
          </div>
        </Form>
      </Card>
    </Create>
  );
};
