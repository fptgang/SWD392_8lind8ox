import React from "react";
import { Create, useForm } from "@refinedev/antd";
import { Form, Input, Checkbox, Row, Col, Card, Typography, notification, InputNumber } from "antd";
import { InfoCircleOutlined } from "@ant-design/icons";
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
            push("/vouchers");
        },
        onMutationError: (error) => {
            notification.error({
                message: "Error Creating Voucher",
                description: error?.message || "An unexpected error occurred while creating the voucher.",
            });
        },
    });

    return (
        <Create 
            saveButtonProps={{
                ...saveButtonProps,
                style: { width: 150 },
                size: "large"
            }}
        >
            <Card bordered={false} className="shadow-sm">
                <Form {...formProps} layout="vertical" initialValues={{ isActive: true }}>
                    <div className="mb-8">
                        <Title level={5} className="mb-4 text-gray-800">Voucher Information</Title>
                        <Row gutter={[24, 24]}>
                            <Col xs={24} md={12}>
                                <Form.Item
                                    label={<span className="font-semibold text-gray-700">Voucher Code</span>}
                                    name="code"
                                    rules={[{ 
                                        required: true,
                                        message: "Please enter the voucher code"
                                    }]}
                                    tooltip={{
                                        title: "Enter a unique code for the voucher",
                                        icon: <InfoCircleOutlined />,
                                    }}
                                >
                                    <Input 
                                        placeholder="Enter voucher code"
                                        size="large"
                                        allowClear
                                    />
                                </Form.Item>
                            </Col>
                            <Col xs={24} md={12}>
                                <Form.Item
                                    label={<span className="font-semibold text-gray-700">Discount Rate</span>}
                                    name="discountRate"
                                    rules={[{ 
                                        required: true,
                                        message: "Please enter the discount rate"
                                    }]}
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
                                        style={{ width: '100%' }}
                                        formatter={value => `${value}%`}
                                        parser={(value: string | undefined) => {
                                            if (!value) return 0;
                                            const parsed = parseFloat(value.replace('%', ''));
                                            return parsed > 100 ? 100 : parsed < 0 ? 0 : parsed;
                                        }}
                                    />
                                </Form.Item>
                            </Col>
                            <Col xs={24}>
                                <Form.Item
                                    label={<span className="font-semibold text-gray-700">Description</span>}
                                    name="description"
                                    rules={[{ 
                                        required: true,
                                        message: "Please enter the voucher description"
                                    }]}
                                    tooltip={{
                                        title: "Enter a description for the voucher",
                                        icon: <InfoCircleOutlined />,
                                    }}
                                >
                                    <Input.TextArea
                                        placeholder="Enter voucher description"
                                        rows={4}
                                        showCount
                                        maxLength={500}
                                        className="resize-none"
                                    />
                                </Form.Item>
                            </Col>
                            <Col xs={24}>
                                <Form.Item
                                    label={<span className="font-semibold text-gray-700">Status</span>}
                                    name="state"
                                    initialValue="AVAILABLE"
                                >
                                    <Checkbox className="text-gray-700" checked>
                                        Available for use
                                    </Checkbox>
                                </Form.Item>
                            </Col>
                        </Row>
                    </div>
                </Form>
            </Card>
        </Create>
    );
};
