import React, { useState } from "react";
import { BaseRecord, useTranslate, useMany, useCreate } from "@refinedev/core";
import {
  useTable,
  List,
  ShowButton,
  UrlField,
  TagField,
  BooleanField,
  DateField,
  Edit,
  useForm,
  SaveButton,
} from "@refinedev/antd";
import {
  Table,
  Space,
  Button,
  Drawer,
  Form,
  Input,
  InputNumber,
  Select,
  Switch,
  message,
  Upload,
  UploadFile,
  notification,
} from "antd";
import { VideoDto } from "../../../generated";
import { ToyDto, ToyDtoRarityEnum } from "../../../generated/models/ToyDto";
import { PlusOutlined } from "@ant-design/icons";
import api from "../../config/openapi-config";

export const VideosList = () => {
  const translate = useTranslate();
  const [drawerVisible, setDrawerVisible] = useState(false);
  const [currentVideo, setCurrentVideo] = useState<VideoDto | null>(null);
  const [images, setImages] = useState<UploadFile[]>([]);

  const { mutate: createToy } = useCreate();
  const { formProps, form } = useForm<ToyDto>();

  const {
    tableProps,
    tableQuery: { refetch },
  } = useTable<VideoDto>({
    syncWithLocation: true,
    sorters: {
      initial: [
        {
          field: "createdAt",
          order: "asc",
        },
      ],
    },
  });

  const openCreateToyDrawer = (video: VideoDto) => {
    setCurrentVideo(video);
    setDrawerVisible(true);
  };

  const closeDrawer = () => {
    setDrawerVisible(false);
    form.resetFields();
  };

  const handleCreateToy = async () => {
    try {
      await form.validateFields();
      const values = form.getFieldsValue() as ToyDto;

      api
        .createToy({
          toyDto: {
            ...values,
            isVisible: values.isVisible || false,
          },
        })
        .then(async (data) => {
          const toy = data;
          try {
            await api.updateSlot({
              slotId: currentVideo?.slotId || 0,
              slotDto: {
                toy: {
                  toyId: toy.toyId,
                },
              },
            });
            if (images.length > 0) {
              images.map(async (file) => {
                await api.uploadImage({
                  toyId: toy.toyId,
                  imageBlob: file.originFileObj,
                });
              });
            }

            await api.verifiedVideo({
              videoId: currentVideo?.videoId || 0,
            });

            notification?.success({
              message: "Toycreated successfully with all images",
            });
            setImages([]);
          } catch (error) {
            notification?.error({
              message: "Error uploading images",
              description: "Toywas created but some images failed to upload",
            });
          }
        });

      closeDrawer();
      refetch();
    } catch (error) {
      console.error("Validation failed:", error);
    }
  };

  const handleReject = async (videoId: number) => {
    await api.deleteVideo({
      videoId: videoId,
    });
    refetch();
  };

  return (
    <>
      <List>
        <Table {...tableProps} rowKey="id">
          <Table.Column
            dataIndex={["videoId"]}
            title={translate("Id")}
            sorter={(a, b) => (a.videoId || 0) - (b.videoId || 0)}
          />

          <Table.Column
            dataIndex={["url"]}
            title={translate("Url")}
            render={(value: any) => <UrlField value={value} />}
          />
          <Table.Column
            dataIndex="description"
            title={translate("Description")}
          />
          <Table.Column
            dataIndex={["isVisible"]}
            title={translate("Is Visible")}
            render={(value: any) => <BooleanField value={value} />}
          />
          <Table.Column
            dataIndex={["createdAt"]}
            title={translate("Created At")}
            render={(value: any) => <DateField value={value} />}
            sorter={(a, b) => {
              const dateA = a.createdAt ? new Date(a.createdAt).getTime() : 0;
              const dateB = b.createdAt ? new Date(b.createdAt).getTime() : 0;
              return dateA - dateB;
            }}
          />
          <Table.Column
            dataIndex={["updatedAt"]}
            title={translate("Updated At")}
            render={(value: any) => <DateField value={value} />}
          />
          <Table.Column
            dataIndex={["isVerified"]}
            title={translate("Is Verified")}
            render={(value: any) => <BooleanField value={value} />}
            sorter={(a, b) => {
              const valueA = a.isVerified ? 1 : 0;
              const valueB = b.isVerified ? 1 : 0;
              return valueA - valueB;
            }}
          />
          <Table.Column
            title={translate("table.actions")}
            dataIndex="actions"
            render={(_, record: VideoDto) => (
              <Space>
                <ShowButton
                  hideText
                  size="small"
                  recordItemId={record.videoId}
                />
                {!record.isVerified && (
                  <>
                    <Button
                      type="primary"
                      size="small"
                      onClick={() => handleReject(record.videoId || 0)}
                    >
                      Reject
                    </Button>
                    <Button
                      type="primary"
                      size="small"
                      variant="solid"
                      color="cyan"
                      onClick={() =>
                        record.videoId && openCreateToyDrawer(record)
                      }
                    >
                      Create Toy
                    </Button>
                  </>
                )}
              </Space>
            )}
          />
        </Table>
      </List>

      <Drawer
        title="Create Toy"
        width={520}
        onClose={closeDrawer}
        open={drawerVisible}
        extra={
          <Space>
            <Button onClick={closeDrawer}>Cancel</Button>
            <Button type="primary" onClick={handleCreateToy}>
              Create
            </Button>
          </Space>
        }
      >
        <Form {...formProps} layout="vertical">
          <Form.Item
            name="name"
            label="Name"
            rules={[{ required: true, message: "Please enter toy name" }]}
          >
            <Input />
          </Form.Item>

          <Form.Item
            name="description"
            label="Description"
            rules={[{ required: true, message: "Please enter description" }]}
          >
            <Input.TextArea rows={4} />
          </Form.Item>

          <Form.Item
            name="weight"
            label="Weight"
            rules={[{ required: true, message: "Please enter weight" }]}
          >
            <InputNumber min={0} step={0.1} style={{ width: "100%" }} />
          </Form.Item>

          <Form.Item
            name="rarity"
            label="Rarity"
            rules={[{ required: true, message: "Please select rarity" }]}
          >
            <Select>
              <Select.Option value={ToyDtoRarityEnum.Regular}>
                Regular
              </Select.Option>
              <Select.Option value={ToyDtoRarityEnum.Secret}>
                Secret
              </Select.Option>
            </Select>
          </Form.Item>

          <Form.Item
            name="isVisible"
            label="Visibility"
            valuePropName="checked"
          >
            <Switch />
          </Form.Item>
          <Form.Item
            label="Toys Images (Multiple)"
            valuePropName="blindBoxImages"
            getValueFromEvent={(e) => (Array.isArray(e) ? e : e && e.Images)}
            rules={[{ required: true }]}
          >
            <Upload
              multiple
              listType="picture-card"
              accept="image/*"
              beforeUpload={(file) => {
                return false;
              }}
              onChange={(info) => {
                if (info.fileList.length > 0) {
                  setImages([...info.fileList]);
                }
              }}
              onRemove={(file) => {
                setImages((prev) => prev.filter((f) => f.name !== file.name));
              }}
              fileList={images as any}
            >
              <div>
                <PlusOutlined />
                <div style={{ marginTop: 8 }}>Upload</div>
              </div>
            </Upload>
          </Form.Item>
        </Form>
      </Drawer>
    </>
  );
};
