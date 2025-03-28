import React, { useContext } from "react";
import { Menu, Dropdown, Avatar, Button, Space, Switch, theme, Typography, Divider } from "antd";
import type { MenuProps } from "antd";
import {
  UserOutlined,
  ShoppingCartOutlined,
  LogoutOutlined,
  LoginOutlined,
  CheckCircleOutlined,
  WalletOutlined,
  SettingOutlined,
} from "@ant-design/icons";
import { Link, useNavigate } from "react-router";
import { useLogout, useGetIdentity } from "@refinedev/core";
import { ColorModeContext } from "../../../contexts/color-mode";
import { AccountDto, AccountDtoRoleEnum } from "../../../../generated";
import { formatCurrency } from "../../../utils/currency-formatter";

const { Text } = Typography;

interface UserMenuProps {
  isAuthenticated?: boolean;
}

export const UserMenu: React.FC<UserMenuProps> = ({ isAuthenticated }) => {
  const { mutate: logout } = useLogout();
  const { data: me } = useGetIdentity<AccountDto>();
  const { mode, setMode } = useContext(ColorModeContext);
  const { token } = theme.useToken();
  const nav = useNavigate();

  const profileMenuItems: MenuProps['items'] = [
    {
      key: "profile-info",
      label: (
        <div className="p-2">
          <div className="flex items-center mb-2">
            <Avatar
              size={48}
              src={me?.avatarUrl}
              icon={<UserOutlined />}
              className="mr-3"
              style={{ backgroundColor: token.colorPrimary }}
            />
            <div>
              <Text strong className="block">
                {me?.firstName || ""} {me?.lastName || ""}
                {/*{me?.isVerified && (*/}
                {/*  <CheckCircleOutlined className="ml-1 text-blue-500"/>*/}
                {/*)}*/}
              </Text>
              <Text type="secondary" className="block">
                {me?.email}
              </Text>
            </div>
          </div>
          <div className="flex items-center bg-gray-50 p-2 rounded mt-2">
            <WalletOutlined className="text-green-500 mr-2" />
            <div>
              <Text type="secondary" className="block text-xs">
                Wallet Balance
              </Text>
              <Text strong className="text-green-500">
                {formatCurrency(me?.balance ?? 0)}
              </Text>
            </div>
          </div>
          <Divider className="my-2" />
        </div>
      ),
      disabled: true,
      style: { cursor: "default" },
    },
    {
      key: "orders",
      label: (
        <Link to="/account/orders">
          <Space>
            <ShoppingCartOutlined />
            <span>My Orders</span>
          </Space>
        </Link>
      ),
    },
    {
      key: "settings",
      label: (
        <Space>
          <SettingOutlined />
          <span>Settings</span>
        </Space>
      ),
      onClick: () => nav("/settings"),
    },
    {
      key: "theme",
      label: (
        <Space onClick={(e: any) => e.stopPropagation()}>
          Dark Mode
          <Switch
            checked={mode === "dark"}
            onChange={() => setMode(mode === "light" ? "dark" : "light")}
          />
        </Space>
      ),
    },
    {
      type: "divider",
    },
    {
      key: "logout",
      label: (
        <Space onClick={() => logout()}>
          <LogoutOutlined />
          <span>Logout</span>
        </Space>
      ),
    },
  ];

  if (!isAuthenticated) {
    return (
      <Space>
        <Link to="/login">
          <Button type="text" icon={<LoginOutlined />}>
            Login
          </Button>
        </Link>
      </Space>
    );
  }

  return (
    <Dropdown overlay={<Menu items={profileMenuItems} />} trigger={["click"]}>
      <Button
        type="text"
        className="flex items-center justify-center hover:bg-gray-100 px-3 h-10 rounded-full"
      >
        <Space>
          <Avatar
            size="small"
            icon={<UserOutlined />}
            style={{ backgroundColor: token.colorPrimary }}
            src={me?.avatarUrl}
          />
          <span className="hidden sm:inline">
            {me?.firstName || "Account"}
            {/*{me?.isVerified && (*/}
            {/*  <CheckCircleOutlined className="ml-1 text-blue-500"/>*/}
            {/*)}*/}
          </span>
        </Space>
      </Button>
    </Dropdown>
  );
};
