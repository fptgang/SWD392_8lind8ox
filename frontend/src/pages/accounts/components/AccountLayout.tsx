import React from "react";
import { Layout, Menu } from "antd";
import {
  UserOutlined,
  ShoppingOutlined,
  LockOutlined,
  WalletOutlined,
} from "@ant-design/icons";
import { Outlet, useLocation, useNavigate } from "react-router";

const { Sider, Content } = Layout;

export const AccountLayout: React.FC = () => {
  const location = useLocation();
  const navigate = useNavigate();

  const menuItems = [
    {
      key: "profile",
      icon: <UserOutlined />,
      label: "Profile",
    },
    {
      key: "security",
      icon: <LockOutlined />,
      label: "Security",
    },
    {
      key: "wallet",
      icon: <WalletOutlined />,
      label: "Wallet",
    },
    {
      key: "orders",
      icon: <ShoppingOutlined />,
      label: "Orders",
    },
  ];

  const handleMenuClick = (key: string) => {
    navigate(`/account/${key}`);
  };

  return (
    <Layout style={{ minHeight: "100vh", backgroundColor: "transparent" }} className="mx-90">
      <Sider
        width={250}
        style={{
          backgroundColor: "white",
          padding: "24px 0",
          borderRight: "1px solid #f0f0f0",
        }}
      >
        <Menu
          mode="inline"
          selectedKeys={[location.pathname.split("/")[2] || "profile"]}
          items={menuItems}
          onClick={({ key }) => handleMenuClick(key)}
          style={{ border: "none" }}
        />
      </Sider>
      <Content style={{ padding: "24px 40px", minHeight: 280 }}>
        <Outlet />
      </Content>
    </Layout>
  );
};

export default AccountLayout;