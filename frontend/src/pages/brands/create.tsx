import React from "react";
import { Create, useForm } from "@refinedev/antd";
import { Form, Input, Checkbox, Row, Col, Card, Typography, notification } from "antd";
import { InfoCircleOutlined } from "@ant-design/icons";
import { useNavigation } from "@refinedev/core";
import { BrandDto } from "../../../generated";

const { Title } = Typography;

export const BrandsCreate = () => {
    const { push } = useNavigation();

    const { formProps, saveButtonProps } = useForm<BrandDto>({
        onMutationSuccess: (data) => {
            notification.success({
                message: "Brand Created Successfully",
                description: `Brand "${data.data.name}" has been created.`,
            });
            push("/brands");
        },
        onMutationError: (error) => {
            notification.error({
                message: "Error Creating Brand",
                description: error?.message || "An unexpected error occurred while creating the brand.",
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
            <Typography.Title level={3}>Create New Brand</Typography.Title>
            <Form {...formProps} layout="vertical" initialValues={{ isVisible: true }}>
                <Card bordered={false} className="shadow-sm">
                    <div className="mb-8">
                        <Title level={5} className="mb-4 text-gray-800">Basic Information</Title>
                        <Row gutter={[24, 24]}>
                            <Col xs={24} md={12}>
                                <Form.Item
                                    label={<span className="font-semibold text-gray-700">Brand Name</span>}
                                    name="name"
                                    rules={[{ 
                                        required: true,
                                        message: "Please enter the brand name"
                                    }]}
                                    tooltip={{
                                        title: "Enter the brand name",
                                        icon: <InfoCircleOutlined />,
                                    }}
                                >
                                    <Input 
                                        placeholder="Enter brand name"
                                        size="large"
                                        allowClear
                                    />
                                </Form.Item>
                            </Col>
                            <Col xs={24}>
                                <Form.Item
                                    label={<span className="font-semibold text-gray-700">Description</span>}
                                    name="description"
                                    rules={[{ 
                                        required: true,
                                        message: "Please enter the brand description"
                                    }]}
                                    tooltip={{
                                        title: "Enter a description for the brand",
                                        icon: <InfoCircleOutlined />,
                                    }}
                                >
                                    <Input.TextArea
                                        placeholder="Enter brand description"
                                        rows={4}
                                        showCount
                                        maxLength={500}
                                        className="resize-none"
                                    />
                                </Form.Item>
                            </Col>
                            <Col xs={24}>
                                <Form.Item
                                    label={<span className="font-semibold text-gray-700">Visibility Status</span>}
                                    name="isVisible"
                                    valuePropName="checked"
                                >
                                    <Checkbox className="text-gray-700">
                                        Show this brand on the platform
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
