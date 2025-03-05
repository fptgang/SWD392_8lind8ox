import React from "react";
import { useShow, useTranslate, useOne } from "@refinedev/core";
import {
    Show,
    TagField,
    TextField,
    MarkdownField,
    BooleanField,
    DateField,
} from "@refinedev/antd";
import { Typography } from "antd";

const { Title } = Typography;

export const BrandsShow = () => {
    const translate = useTranslate();
    const { query } = useShow();
    const { data, isLoading } = query;

    const record = data?.data;

    const { data: brandData, isLoading: brandIsLoading } = useOne({
        resource: "brands",
        id: record?.brandId || "",
        queryOptions: {
            enabled: !!record,
        },
    });

    return (
      <Show isLoading={isLoading}>
          <Title level={5}>{translate("brands.fields.brandId")}</Title>
          {brandIsLoading ? <>Loading...</> : <>{brandData?.data?.name}</>}
          <Title level={5}>{translate("brands.fields.name")}</Title>
          <TextField value={record?.name} />
          <Title level={5}>{translate("brands.fields.description")}</Title>
          <MarkdownField value={record?.description} />
          <Title level={5}>{translate("brands.fields.isVisible")}</Title>
          <BooleanField value={record?.isVisible} />
          <Title level={5}>{translate("brands.fields.createdAt")}</Title>
          <DateField value={record?.createdAt} />
          <Title level={5}>{translate("brands.fields.updatedAt")}</Title>
          <DateField value={record?.updatedAt} />
      </Show>
    );
};
