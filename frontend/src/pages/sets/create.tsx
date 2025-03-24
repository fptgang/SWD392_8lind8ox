import React from "react";
import { Create, useForm, useSelect } from "@refinedev/antd";
import {
  Form,
  Input,
  Checkbox,
  Row,
  Col,
  Card,
  Typography,
  notification,
  Select,
  InputNumber,
} from "antd";
import { InfoCircleOutlined } from "@ant-design/icons";
import { useNavigation } from "@refinedev/core";
import { SetDto } from "../../../generated/models/SetDto";
import { StockKeepingUnitDto } from "../../../generated/models/StockKeepingUnitDto";
import { BlindBoxDto } from "../../../generated/models/BlindBoxDto";

const { Title } = Typography;

export const SetsCreate: React.FC = () => {
  const { push } = useNavigation();
  const [selectedBlindBox, setSelectedBlindBox] = React.useState<BlindBoxDto>();
  const { formProps, saveButtonProps } = useForm<SetDto>({
    resource: "sets",
    onMutationSuccess: (data) => {
      notification.success({
        message: "Set Created Successfully",
        description: `Set with SKU "${data.data.sku?.name}" has been created.`,
      });
      push("/sets");
    },
    onMutationError: (error) => {
      notification.error({
        message: "Error Creating Set",
        description:
          error?.message ||
          "An unexpected error occurred while creating the set.",
      });
    },
  });

  // Fetch Blind Boxes for dropdown
  const { selectProps: blindBoxSelectProps, query: blindboxQuery } =
    useSelect<BlindBoxDto>({
      resource: "blind-boxes",
      optionLabel: "name",
      optionValue: "blindBoxId",
    });

  return (
    <Create
      saveButtonProps={{
        ...saveButtonProps,
        style: { width: 150 },
        size: "large",
      }}
    >
      <Typography.Title level={3}>Create New Set</Typography.Title>
      <Form
        {...formProps}
        layout="vertical"
        initialValues={{ isVisible: true }}
      >
        <Card bordered={false} className="shadow-sm">
          <div className="mb-8">
            <Title level={5} className="mb-4 text-gray-800">
              Set Information
            </Title>
            <Row gutter={[24, 24]}>
              <Col xs={24} md={12}>
                <Form.Item
                  label={
                    <span className="font-semibold text-gray-700">
                      Blind Box
                    </span>
                  }
                  name={["blindBox", "blindBoxId"]}
                  tooltip={{
                    title: "Select a Blind Box (Optional)",
                    icon: <InfoCircleOutlined />,
                  }}
                >
                  <Select
                    {...blindBoxSelectProps}
                    placeholder="Select a Blind Box"
                    size="large"
                    allowClear
                    onChange={(value) => {
                      setSelectedBlindBox(
                        blindboxQuery?.data?.data.find(
                          (b) => b.blindBoxId === value
                        )
                      );
                    }}
                    onClear={() => setSelectedBlindBox(undefined)}
                  />
                </Form.Item>
              </Col>
              <Col xs={24} md={12}>
                <Form.Item
                  label={
                    <span className="font-semibold text-gray-700">
                      Stock Keeping Unit (SKU)
                    </span>
                  }
                  name={["sku", "skuId"]}
                  rules={[
                    {
                      required: true,
                      message: "Please select a SKU",
                    },
                  ]}
                  tooltip={{
                    title: "Select a Stock Keeping Unit",
                    icon: <InfoCircleOutlined />,
                  }}
                >
                  <Select
                    placeholder="Select a SKU"
                    size="large"
                    allowClear
                    options={
                      selectedBlindBox?.skus?.map((sku) => ({
                        label: sku.name,
                        value: sku.skuId,
                      })) || []
                    }
                    onClick={() => {
                      console.log(selectedBlindBox, selectedBlindBox?.skus);
                    }}
                    disabled={!selectedBlindBox}
                  />
                </Form.Item>
              </Col>
              <Col xs={24} md={12}>
                <Form.Item
                  label={
                    <span className="font-semibold text-gray-700">
                      Number of slot in this Set
                    </span>
                  }
                  name={["numOfItems"]}
                >
                  <InputNumber
                    placeholder="Number of slots"
                    size="large"
                    min={1}
                    max={20}
                    style={{ width: "100%" }}
                  />
                </Form.Item>
              </Col>
              <Col xs={24} md={12}>
                <Form.Item
                  label={
                    <span className="font-semibold text-gray-700">
                      Visibility Status
                    </span>
                  }
                  name="isVisible"
                  valuePropName="checked"
                >
                  <Checkbox className="text-gray-700">
                    Show this set on the platform
                  </Checkbox>
                </Form.Item>
              </Col>
            </Row>
          </div>
        </Card>
      </Form>
    </Create>
  );
};
