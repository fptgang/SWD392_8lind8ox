import React from "react";
import { useShow, useOne } from "@refinedev/core";
import {
    Show,
    TagField,
    TextField,
    DateField,
    NumberField,
} from "@refinedev/antd";
import { Typography, Card, Row, Col, Collapse, Descriptions, Tag } from "antd";

const { Title } = Typography;
const { Panel } = Collapse;

export const OrdersShow = () => {
    const { queryResult } = useShow();
    const { data, isLoading } = queryResult;
    const record = data?.data;

    const { data: accountData, isLoading: accountIsLoading } = useOne({
        resource: "accounts",
        id: record?.accountId || "",
        queryOptions: {
            enabled: !!record,
        },
    });

    const getStatusColor = (status: string) => {
        switch (status) {
            case "COMPLETED":
                return "green";
            case "PENDING":
                return "blue";
            case "CANCELLED":
                return "red";
            default:
                return "gray";
        }
    };

    return (
        <Show isLoading={isLoading}>
            <Row gutter={[16, 16]}>
                {/* Order Details */}
                <Col span={24}>
                    <Card title="Order Details" bordered={false}>
                        <Descriptions column={2}>
                            <Descriptions.Item label="Status">
                                <Tag color={getStatusColor(record?.status)}>
                                    {record?.status}
                                </Tag>
                            </Descriptions.Item>
                            <Descriptions.Item label="Total Price">
                                <NumberField
                                    value={record?.totalPrice}
                                    options={{
                                        style: "currency",
                                        currency: "USD",
                                    }}
                                />
                            </Descriptions.Item>
                            <Descriptions.Item label="Created At">
                                <DateField value={record?.createdAt} />
                            </Descriptions.Item>
                            <Descriptions.Item label="Updated At">
                                <DateField value={record?.updatedAt} />
                            </Descriptions.Item>
                        </Descriptions>
                    </Card>
                </Col>

                {/* Account Information */}
                <Col span={24}>
                    <Card title="Customer Information" bordered={false}>
                        {accountIsLoading ? (
                            "Loading..."
                        ) : (
                            <Descriptions column={2}>
                                <Descriptions.Item label="Name">
                                    {accountData?.data?.firstName}{" "}
                                    {accountData?.data?.lastName}
                                </Descriptions.Item>
                                <Descriptions.Item label="Email">
                                    {accountData?.data?.email}
                                </Descriptions.Item>
                                <Descriptions.Item label="Balance">
                                    <NumberField
                                        value={accountData?.data?.balance}
                                        options={{
                                            style: "currency",
                                            currency: "USD",
                                        }}
                                    />
                                </Descriptions.Item>
                                <Descriptions.Item label="Verified">
                                    <Tag
                                        color={
                                            accountData?.data?.isVerified
                                                ? "green"
                                                : "red"
                                        }
                                    >
                                        {accountData?.data?.isVerified
                                            ? "Verified"
                                            : "Not Verified"}
                                    </Tag>
                                </Descriptions.Item>
                            </Descriptions>
                        )}
                    </Card>
                </Col>

                {/* Order Items */}
                <Col span={24}>
                    <Card title="Order Items" bordered={false}>
                        <Collapse accordion>
                            {record?.orderDetails?.map((item: any) => (
                                <Panel
                                    header={`Item ${item.orderDetailId}`}
                                    key={item.orderDetailId}
                                >
                                    <Descriptions column={2}>
                                        <Descriptions.Item label="Blind Box ID">
                                            {item.blindBoxId || "N/A"}
                                        </Descriptions.Item>
                                        <Descriptions.Item label="Original Price">
                                            <NumberField
                                                value={item.originalProductPrice}
                                                options={{
                                                    style: "currency",
                                                    currency: "USD",
                                                }}
                                            />
                                        </Descriptions.Item>
                                        <Descriptions.Item label="Discount Price">
                                            <NumberField
                                                value={item.discountPrice}
                                                options={{
                                                    style: "currency",
                                                    currency: "USD",
                                                }}
                                            />
                                        </Descriptions.Item>
                                        <Descriptions.Item label="Unbox Request">
                                            {item.requestUnbox ? "Yes" : "No"}
                                        </Descriptions.Item>
                                        <Descriptions.Item label="Created At">
                                            <DateField value={item.createdAt} />
                                        </Descriptions.Item>
                                    </Descriptions>
                                </Panel>
                            ))}
                        </Collapse>
                    </Card>
                </Col>
            </Row>
        </Show>
    );
};