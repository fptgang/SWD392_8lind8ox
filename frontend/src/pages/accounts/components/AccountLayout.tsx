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
      icon: <UserOutlined className="text-lg" />,
      label: "Profile",
    },
    {
      key: "security",
      icon: <LockOutlined className="text-lg" />,
      label: "Security",
    },
    {
      key: "wallet",
      icon: <WalletOutlined className="text-lg" />,
      label: "Wallet",
    },
    {
      key: "orders",
      icon: <ShoppingOutlined className="text-lg" />,
      label: "Orders",
    },
  ];

  const handleMenuClick = (key: string) => {
    navigate(`/account/${key}`);
  };

  return (
    <Layout className="min-h-screen bg-transparent">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 w-full">
        <div className="flex gap-8">
          <Sider
            width={200}
            className="rounded-lg shadow-sm overflow-hidden h-[calc(100vh-2rem)] mt-4"
          >
            <div className="p-4 border-b border-gray-100">
              <h2 className="text-lg font-medium text-gray-900">Account</h2>
            </div>
            <Menu
              mode="inline"
              selectedKeys={[location.pathname.split("/")[2] || "profile"]}
              items={menuItems}
              onClick={({ key }) => handleMenuClick(key)}
              className="border-none h-full pt-2"
            />
          </Sider>
          <Content className="flex-1 min-h-[280px] rounded-lg shadow-sm p-6 mt-4">
            <Outlet />
          </Content>
        </div>
      </div>
    </Layout>
  );
};

export default AccountLayout;
