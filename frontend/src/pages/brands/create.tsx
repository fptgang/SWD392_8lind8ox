import React from "react";
import { Create, useForm, useSelect } from "@refinedev/antd";
import { Form, Input, Select, Checkbox, DatePicker } from "antd";
import { useTranslate } from "@refinedev/core";
import dayjs from "dayjs";

export const BrandsCreate = () => {
    const translate = useTranslate();
    const { formProps, saveButtonProps, query } = useForm();

    const { selectProps: brandSelectProps } = useSelect({
        resource: "brands",
        optionLabel: "name",
    });

    return (
      <Create saveButtonProps={saveButtonProps}>
          <Form {...formProps} layout="vertical">
              <Form.Item
                label={translate("brands.fields.brandId")}
                name={"brandId"}
                rules={[
                    {
                        required: true,
                    },
                ]}
              >
                  <Select {...brandSelectProps} />
              </Form.Item>
              <Form.Item
                label={translate("brands.fields.name")}
                name={["name"]}
                rules={[
                    {
                        required: true,
                    },
                ]}
              >
                  <Input />
              </Form.Item>
              <Form.Item
                label={translate("brands.fields.isVisible")}
                valuePropName="checked"
                name={["isVisible"]}
                rules={[
                    {
                        required: true,
                    },
                ]}
              >
                  <Checkbox>Is Visible</Checkbox>
              </Form.Item>
              <Form.Item
                label={translate("brands.fields.createdAt")}
                name={["createdAt"]}
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
                label={translate("brands.fields.updatedAt")}
                name={["updatedAt"]}
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
          </Form>
      </Create>
    );
};
