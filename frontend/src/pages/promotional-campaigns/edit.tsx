import React from "react";
import { Edit, useForm } from "@refinedev/antd";
import {
  Form,
  Input,
  DatePicker,
  Checkbox,
  InputNumber,
  Row,
  Select,
  Avatar,
} from "antd";
import { useSelect, useTranslate } from "@refinedev/core";
import dayjs from "dayjs";
import { PercentageOutlined } from "@ant-design/icons";
import { BlindBoxDto, PromotionalCampaignDto } from "../../../generated";

export const PromotionalCampaignsEdit = () => {
  const translate = useTranslate();
  const { formProps, saveButtonProps, query } =
    useForm<PromotionalCampaignDto>();

  const promotionsData = query?.data?.data;

  const { queryResult: blindBoxesQueryResult } = useSelect<BlindBoxDto>({
    resource: "blind-boxes",
    optionLabel: "name",
    optionValue: "blindBoxId",
    pagination: { pageSize: 100 },
  });

  return (
    <Edit saveButtonProps={saveButtonProps}>
      <Form {...formProps} layout="vertical">
        <Form.Item
          label={translate("Title :")}
          name={["title"]}
          rules={[
            {
              required: true,
            },
          ]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          label={translate("Description :")}
          name="description"
          rules={[
            {
              required: true,
            },
          ]}
        >
          <Input.TextArea rows={5} />
        </Form.Item>
        <Form.Item
          label={translate("Discount Rate :")}
          name={["discountRate"]}
          rules={[
            {
              required: true,
            },
          ]}
          getValueProps={(value) => ({
            value: value ? Math.round(value * 100) : undefined,
          })}
          normalize={(value) => value / 100}
        >
          <InputNumber
            placeholder="e.g. 20"
            min={0}
            max={100}
            formatter={(value) => `${Math.round(value)}`}
            parser={(value) => value?.replace("%", "")}
            // style={{ width: "100%" }}
            suffix={<PercentageOutlined />}
          />
        </Form.Item>
        <Row>
          <Form.Item
            className="w-1/2 min-w-fit"
            label={translate("Start Date :")}
            name={["startDate"]}
            rules={[
              {
                required: true,
              },
            ]}
            getValueProps={(value) => ({
              value: value ? dayjs(value) : undefined,
            })}
          >
            <DatePicker />
          </Form.Item>
          <Form.Item
            className="w-1/2 min-w-fit"
            label={translate("End Date :")}
            name={["endDate"]}
            rules={[
              {
                required: true,
              },
            ]}
            getValueProps={(value) => ({
              value: value ? dayjs(value) : undefined,
            })}
          >
            <DatePicker />
          </Form.Item>
        </Row>
        <Form.Item
          label={translate("Select Blindboxes :")}
          name={["blindBoxIds"]}
          rules={[
            {
              required: true,
            },
          ]}
          className="w-full"
        >
          <Select
            mode="multiple"
            placeholder="Select Blindboxes"
            defaultValue={promotionsData?.blindBoxCampaigns?.map(
              (bc) => bc.blindBoxId
            )}
          >
            {blindBoxesQueryResult?.data?.data.map((blindBox) => (
              <Select.Option
                key={blindBox.blindBoxId}
                value={blindBox.blindBoxId}
              >
                <Avatar
                  src={blindBox.images ? blindBox.images[0]?.imageUrl : ""}
                  className="mr-2"
                  size={24}
                />
                {blindBox.name}
              </Select.Option>
            ))}
          </Select>
        </Form.Item>
        <Form.Item
          label={translate("isVisible :")}
          valuePropName="checked"
          name={["isVisible"]}
          //   rules={[
          //     {
          //       required: true,
          //     },
          //   ]}
        >
          <Checkbox>Is Visible</Checkbox>
        </Form.Item>
      </Form>
    </Edit>
  );
};
