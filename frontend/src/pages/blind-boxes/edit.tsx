import React, { useState, useEffect } from "react";
import { Edit, useForm, useSelect } from "@refinedev/antd";
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
} from "antd";
import {
  PlusOutlined,
  DeleteOutlined,
  InfoCircleOutlined,
} from "@ant-design/icons";
import { BlindBoxDto, ImageDto } from "../../../generated";
import api from "../../config/openapi-config";

const { Title } = Typography;

export const BlindBoxesEdit = () => {
  const { formProps, saveButtonProps, queryResult } = useForm<BlindBoxDto>();
  const [blindBoxImages, setBlindBoxImages] = useState<ImageDto[]>([]);
  const [newBlindBoxFiles, setNewBlindBoxFiles] = useState<File[]>([]);
  const [loading, setLoading] = useState(false);

  const blindBoxData = queryResult?.data?.data;

  useEffect(() => {
    if (blindBoxData?.images) {
      setBlindBoxImages(blindBoxData.images);
    }
  }, [blindBoxData]);

  const { selectProps: brandSelectProps } = useSelect({
    resource: "brands",
    optionLabel: "name",
    optionValue: "brandId",
    defaultValue: blindBoxData?.brand?.brandId,
  });

  const handleImageUpload = async () => {
    try {
      setLoading(true);

      // Upload new blind box images
      if (newBlindBoxFiles.length > 0) {
        await Promise.all(
          newBlindBoxFiles.map(async (file) => {
            await api.uploadImage({
              blindBoxId: blindBoxData?.blindBoxId,
              imageBlob: file,
            });
          })
        );
      }

      notification.success({
        message: "Images updated successfully",
      });
    } catch (error) {
      notification.error({
        message: "Error updating images",
      });
    } finally {
      setLoading(false);
      setNewBlindBoxFiles([]);
    }
  };

  const handleRemoveImage = async (imageId: number) => {
    try {
      await api.deleteImage({ imageId });
      setBlindBoxImages((prev) =>
        prev.filter((img) => img.imageId !== imageId)
      );
      notification.success({ message: "Image removed successfully" });
    } catch (error) {
      notification.error({ message: "Error removing image" });
    }
  };

  return (
    <Edit
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
              <Input.TextArea
                rows={4}
                placeholder="Detailed description..."
                showCount
                maxLength={500}
                className="resize-none"
              />
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
            {/* Existing Blind Box Images */}
            <Form.Item label="Blind Box Images">
              <div className="flex flex-wrap gap-4">
                {blindBoxImages.map((image) => (
                  <div key={image.imageId} className="relative group">
                    <img
                      src={image.imageUrl}
                      alt="Blind box"
                      className="w-32 h-32 object-cover rounded-lg"
                    />
                    <Button
                      type="primary"
                      danger
                      icon={<DeleteOutlined />}
                      onClick={() => handleRemoveImage(image.imageId!)}
                      className="absolute top-1 right-1 opacity-0 group-hover:opacity-100 transition-opacity"
                    />
                  </div>
                ))}
              </div>
            </Form.Item>

            {/* New Blind Box Images Upload */}
            <Form.Item label="Add New Images">
              <Upload
                multiple
                listType="picture-card"
                accept="image/*"
                beforeUpload={(file) => {
                  setNewBlindBoxFiles((prev) => [...prev, file]);
                  return false;
                }}
                onRemove={(file) => {
                  setNewBlindBoxFiles((prev) =>
                    prev.filter((f) => f.name !== file.fileName)
                  );
                }}
                fileList={newBlindBoxFiles as any}
              >
                <div>
                  <PlusOutlined />
                  <div style={{ marginTop: 8 }}>Upload</div>
                </div>
              </Upload>
              <Button
                type="primary"
                onClick={handleImageUpload}
                disabled={newBlindBoxFiles.length === 0}
                className="mt-4"
              >
                Upload New Images
              </Button>
            </Form.Item>

            <Row gutter={24}>
              {/* Existing form items from Create component */}
              <Col xs={24} md={12}>
                <Form.Item
                  label={
                    <span className="font-semibold text-gray-700">Brand</span>
                  }
                  name={["brand", "brandId"]}
                  rules={[{ required: true }]}
                  tooltip={{
                    title: "Associated brand",
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
              {/* Other form fields */}
            </Row>
          </div>

          {/* SKU Images Section */}
          <Divider className="my-8" />
          <Title level={5} className="mb-4 text-gray-800">
            SKU Images
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
                              `$ ${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
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
                        {blindBoxData?.skus && (
                          <>
                            <div className="flex flex-wrap gap-4">
                              {blindBoxData?.skus[index]?.image && (
                                <div
                                  key={blindBoxData?.skus[index]?.image.imageId}
                                  className="relative group"
                                >
                                  <img
                                    src={
                                      blindBoxData?.skus[index]?.image.imageUrl
                                    }
                                    alt="SKU"
                                    className="w-32 h-32 object-cover rounded-lg"
                                  />
                                  <Button
                                    type="primary"
                                    danger
                                    icon={<DeleteOutlined />}
                                    onClick={() =>
                                      handleRemoveImage(
                                        blindBoxData?.skus?.[index]?.image
                                          ?.imageId!
                                      )
                                    }
                                    className="absolute top-1 right-1 opacity-0 group-hover:opacity-100 transition-opacity"
                                  />
                                </div>
                              )}
                            </div>

                            <Form.Item label="Add New Image">
                              <Upload
                                listType="picture-card"
                                accept="image/*"
                                beforeUpload={async (file) => {
                                  try {
                                    const formData = new FormData();
                                    formData.append("file", file);
                                    await api.uploadImage({
                                      skuId: blindBoxData?.skus?.[index]?.skuId,
                                      imageBlob: file,
                                    });
                                    notification.success({
                                      message: "Image uploaded",
                                    });
                                  } catch (error) {
                                    notification.error({
                                      message: "Upload failed",
                                    });
                                  }
                                  return false;
                                }}
                              >
                                <div>
                                  <PlusOutlined />
                                  <div style={{ marginTop: 8 }}>Upload</div>
                                </div>
                              </Upload>
                            </Form.Item>
                          </>
                        )}
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
        </Form>
      </Card>
    </Edit>
  );
};
