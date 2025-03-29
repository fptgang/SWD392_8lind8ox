import React from "react";
import { Create, useForm } from "@refinedev/antd";
import {
  Form,
  Input,
  Checkbox,
  Row,
  Col,
  Card,
  Typography,
  notification,
  InputNumber,
  DatePicker,
} from "antd";
import {
  CalendarOutlined,
  DollarOutlined,
  InfoCircleOutlined,
} from "@ant-design/icons";
import { useNavigation } from "@refinedev/core";
import { VoucherDto } from "../../../generated";

const { Title } = Typography;

export const VouchersCreate: React.FC = () => {
  const { push } = useNavigation();

  const { formProps, saveButtonProps } = useForm<VoucherDto>({
    onMutationSuccess: (data) => {
      notification.success({
        message: "Voucher Created Successfully",
        description: `Voucher "${data.data.code}" has been created.`,
      });
    },
    onMutationError: (error) => {
      notification.error({
        message: "Error Creating Voucher",
        description:
          error?.message ||
          "An unexpected error occurred while creating the voucher.",
      });
    },
  });

  return (
    <Create
      saveButtonProps={{
        ...saveButtonProps,
        style: { width: 150 },
        size: "large",
      }}
      headerButtons={<></>}
    >
      <Card bordered={false} className="shadow-sm">
        <Form
          {...formProps}
          layout="vertical"
          initialValues={{ isActive: true }}
        >
          <div className="mb-8">
            <Title level={5} className="mb-4 text-gray-800">
              Voucher Information
            </Title>
            <Row gutter={[24, 24]}>
              <Col xs={24} md={12}>
                <Form.Item
                  label={
                    <span className="font-semibold text-gray-700">
                      Account Id
                    </span>
                  }
                  name={["account", "accountId"]}
                  rules={[
                    {
                      required: true,
                      message: "Please enter the account id",
                    },
                  ]}
                  tooltip={{
                    title: "Enter the account id",
                    icon: <InfoCircleOutlined />,
                  }}
                >
                  <InputNumber
                    placeholder="Enter account id"
                    size="large"
                    className="w-full"
                  />
                </Form.Item>
              </Col>
              <Col xs={24} md={12}>
                <Form.Item
                  label={
                    <span className="font-semibold text-gray-700">
                      Discount Rate
                    </span>
                  }
                  name="discountRate"
                  rules={[
                    {
                      required: true,
                      message: "Please enter the discount rate",
                    },
                  ]}
                  tooltip={{
                    title: "Enter the discount rate (percentage)",
                    icon: <InfoCircleOutlined />,
                  }}
                >
                  <InputNumber
                    placeholder="Enter discount rate"
                    size="large"
                    min={0}
                    max={100}
                    style={{ width: "100%" }}
                    formatter={(value) => `${value}%`}
                    parser={(value: string | undefined) => {
                      if (!value) return 0;
                      const parsed = parseFloat(value.replace("%", ""));
                      return parsed > 100 ? 100 : parsed < 0 ? 0 : parsed;
                    }}
                  />
                </Form.Item>
              </Col>
              <Col xs={24} md={12}>
                <Form.Item
                  label={
                    <span className="font-semibold text-gray-700">
                      Limit Amount
                    </span>
                  }
                  name="limitAmount"
                  rules={[
                    {
                      required: true,
                      message: "Please enter the limit amount",
                    },
                  ]}
                  tooltip={{
                    title: "Enter the limit amount",
                    icon: <InfoCircleOutlined />,
                  }}
                >
                  <InputNumber
                    placeholder="Enter limit amount"
                    size="large"
                    min={0}
                    prefix={<DollarOutlined />}
                    style={{ width: "100%" }}
                  />
                </Form.Item>
              </Col>
              <Col xs={24} md={12}>
                <Form.Item
                  label={
                    <span className="font-semibold text-gray-700">
                      Expiration Date
                    </span>
                  }
                  name="expiredAt"
                  rules={[
                    {
                      required: true,
                      message: "Please enter the expiration date",
                    },
                  ]}
                  tooltip={{
                    title: "Enter the expiration date",
                    icon: <CalendarOutlined />,
                  }}
                >
                  <DatePicker
                    placeholder="Enter expiration date"
                    size="large"
                    style={{ width: "100%" }}
                  />
                </Form.Item>
              </Col>
            </Row>
          </div>
        </Form>
      </Card>
    </Create>
  );
};
