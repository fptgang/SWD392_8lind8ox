import React from "react";
import { Layout, Menu } from "antd";
import {
  UserOutlined,
  ShoppingOutlined,
  LockOutlined,
  WalletOutlined,
} from "@ant-design/icons";
import { useLocation, useNavigate } from "react-router";
import { useTranslate } from "@refinedev/core";
const { Sider } = Layout;

export const AccountSider: React.FC = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const t = useTranslate();

  const menuItems = [
    {
      key: "profile",
      icon: <UserOutlined className="text-lg" />,
      label: t("account.menu.profile"),
    },
    {
      key: "security",
      icon: <LockOutlined className="text-lg" />,
      label: t("account.menu.security"),
    },
    {
      key: "wallet",
      icon: <WalletOutlined className="text-lg" />,
      label: t("account.menu.wallet"),
    },
    {
      key: "orders",
      icon: <ShoppingOutlined className="text-lg" />,
      label: t("account.menu.orders"),
    },
  ];

  return (
    <Sider
      width={200}
      className="bg-white rounded-lg shadow-sm overflow-hidden h-[calc(100vh-2rem)] mt-4"
    >
      <div className="p-4 border-b border-gray-100">
        <h2 className="text-lg font-medium ">{t("account.title")}</h2>
      </div>
      <Menu
        mode="inline"
        selectedKeys={[location.pathname.split("/")[2] || "profile"]}
        items={menuItems}
        onClick={({ key }) => navigate(`/account/${key}`)}
        className="border-none h-full pt-2"
      />
    </Sider>
  );
};
