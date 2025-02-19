import { useTranslate, useNavigation, useInfiniteList } from "@refinedev/core";
import { useSimpleList } from "@refinedev/antd";
import {
  Typography,
  List as AntdList,
  Tooltip,
  ConfigProvider,
  theme,
  Card,
  Col,
  Divider,
  Input,
  List,
  Row,
  Skeleton,
  Space,
  Spin,
} from "antd";
import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";
import InfiniteScroll from "react-infinite-scroll-component";
import { OrderDto } from "../../../../generated";
import { OrderStatus } from "../../order/status";

dayjs.extend(relativeTime);

type Props = {
  height?: string;
};

export const OrderTimeline = ({ height = "432px" }: Props) => {
  const { token } = theme.useToken();
  const { show } = useNavigation();

  const { data, isLoading, hasNextPage, fetchNextPage } =
    useInfiniteList<OrderDto>({
      resource: "orders",
      sorters: [
        {
          field: "createdAt",
          order: "desc",
        },
      ],
      pagination: {
        current: 1,
        pageSize: 8,
      },
    });

  const orders = data?.pages.flatMap((page) => page.data) || [];

  return (
    <div
      id="scrollableDiv"
      style={{
        display: "block",
        height: height,
        overflow: "auto",
      }}
    >
      <InfiniteScroll
        dataLength={orders.length}
        next={() => fetchNextPage()}
        hasMore={hasNextPage || false}
        loader={
          <Spin
            spinning
            style={{
              height: "56px",
              display: "flex",
              justifyContent: "center",
              marginTop: "16px",
            }}
          />
        }
        endMessage={<Divider plain>That&apos;s all, nothing more.</Divider>}
        scrollableTarget="scrollableDiv"
      >
        <List
          itemLayout="horizontal"
          dataSource={orders}
          renderItem={(item) => {
            return (
              <List.Item
                onClick={() => show("orders", item.orderId ??"")}
                style={{
                  cursor: "pointer",
                  height: "54px",
                  padding: "16px",
                }}
                actions={[
                  <Typography.Text
                    style={{
                      color: token.colorTextDescription,
                    }}
                    key={"createdAt"}
                  >
                    {dayjs(item.createdAt).fromNow()}
                  </Typography.Text>,
                ]}
              >
                <Skeleton
                  style={{ display: "flex", width: "100%" }}
                  avatar={false}
                  title={false}
                  paragraph={{ rows: 1, width: "100%" }}
                  loading={isLoading}
                  active
                >
                  <div
                    style={{
                      display: "flex",
                      alignItems: "center",
                    }}
                  >
                    <div style={{ width: "128px" }}>
                      <OrderStatus status={item.status ?? 'CANCELED'} />
                    </div>
                    <Typography.Text strong>
                      #{item.orderId}
                    </Typography.Text>
                  </div>
                </Skeleton>
              </List.Item>
            );
          }}
        />
      </InfiniteScroll>
    </div>
  );
};
