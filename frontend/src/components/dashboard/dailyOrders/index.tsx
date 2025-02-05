import { Suspense } from "react";

import { Column, type ColumnConfig } from "@ant-design/plots";
import dayjs from "dayjs";
import { useThemedLayoutContext } from "@refinedev/antd";
import { useTranslate } from "@refinedev/core";

type Props = {
  data: ColumnConfig["data"];
  height: number;
};

export const DailyOrders = ({ data, height }: Props) => {
  const { mode } = useThemedLayoutContext();
  const t = useTranslate();

  const config: ColumnConfig = {
    data,
    xField: "timeText",
    yField: "value",
    seriesField: "state",
    animation: true,
    legend: false,
    theme: mode,
    columnStyle: {
      radius: [4, 4, 0, 0],
      fill:
        mode === "dark"
          ? "l(270) 0:#122849 1:#3C88E5"
          : "l(270) 0:#BAE0FF 1:#1677FF",
    },
    tooltip: {
      formatter: (datum) => {
        return {
          name: t("dashboard.orders.title"),
          value: new Intl.NumberFormat().format(Number(datum.value)),
        };
      },
    },
    xAxis: {
      line: {
        style: {
          fill: mode === "dark" ? "#262626" : "#D9D9D9",
        },
      },
      label: {
        formatter: (v) => {
          if (data.length > 7) {
            return dayjs(v).format("MM/DD");
          }

          return dayjs(v).format("ddd");
        },
      },
    },
    yAxis: {
      label: {
        formatter: (v) => {
          return new Intl.NumberFormat().format(Number(v));
        },
      },
    },
  };

  return (
    <Suspense>
      <Column {...config} height={height} />
    </Suspense>
  );
};
