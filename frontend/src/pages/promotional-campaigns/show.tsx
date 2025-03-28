import React from "react";
import { Show } from "@refinedev/antd";
import { Typography, Row, Col, Avatar, Divider, List } from "antd";
import { HttpError, useMany, useShow, useTranslate } from "@refinedev/core";
import dayjs from "dayjs";
import { PromotionalCampaignDto, BlindBoxDto } from "../../../generated";

const { Title, Text } = Typography;

export const PromotionalCampaignsShow = () => {
  const translate = useTranslate();
  const { queryResult } = useShow<PromotionalCampaignDto>();
  const campaign = queryResult?.data?.data;

  const { data, isLoading, isError } = useMany<BlindBoxDto, HttpError>({
    resource: "blind-boxes",
    ids: campaign?.blindBoxCampaigns?.map((bc) => bc?.blindBoxId) ?? [],
  });

  const blindBoxes = data?.data;

  return (
    <Show isLoading={queryResult.isLoading}>
      <Title level={4}>{translate("Title :")}</Title>
      <Text>{campaign?.title}</Text>
      <Divider />

      <Title level={4}>{translate("Description :")}</Title>
      <Text>{campaign?.description}</Text>
      <Divider />

      <Title level={4}>{translate("Discount Rate :")}</Title>
      <Text>
        {campaign?.discountRate
          ? `${Math.round(campaign.discountRate * 100)}%`
          : "-"}
      </Text>
      <Divider />

      <Row>
        <Col span={12}>
          <Title level={4}>{translate("Start Date :")}</Title>
          <Text>
            {campaign?.startDate
              ? dayjs(campaign.startDate).format("YYYY-MM-DD")
              : "-"}
          </Text>
        </Col>
        <Col span={12}>
          <Title level={4}>{translate("End Date :")}</Title>
          <Text>
            {campaign?.endDate
              ? dayjs(campaign.endDate).format("YYYY-MM-DD")
              : "-"}
          </Text>
        </Col>
      </Row>
      <Divider />

      <Title level={4}>{translate("Select Blindboxes :")}</Title>
      <List className="max-h-[50vh] overflow-auto">
        {campaign?.blindBoxCampaigns?.map((bc) => (
          <List.Item key={bc.blindBoxId}>
            <Avatar
              src={
                blindBoxes?.find((b) => b.blindBoxId === bc.blindBoxId)
                  ?.images?.[0]?.imageUrl
              }
            />
            <Text>
              {blindBoxes?.find((b) => b.blindBoxId === bc.blindBoxId)?.name}
            </Text>
          </List.Item>
        ))}
      </List>
      <Divider />

      <Title level={4}>{translate("isVisible :")}</Title>
      <Text>{campaign?.isVisible ? "Yes" : "No"}</Text>
    </Show>
  );
};
