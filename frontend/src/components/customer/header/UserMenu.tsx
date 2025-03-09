import React, { useContext } from "react";
import { Menu, Dropdown, Avatar, Button, Space, Switch, theme } from "antd";
import type { MenuProps } from "antd";
import {
  UserOutlined,
  ShoppingCartOutlined,
  LogoutOutlined,
  LoginOutlined,
} from "@ant-design/icons";
import { Link } from "react-router";
import { useLogout, useGetIdentity } from "@refinedev/core";
import { ColorModeContext } from "../../../contexts/color-mode";
import { AccountDto } from "../../../../generated";
import { formatCurrency } from "../../../utils/currency-formatter";

interface UserMenuProps {
  isAuthenticated?: boolean;
}

export const UserMenu: React.FC<UserMenuProps> = ({ isAuthenticated }) => {
  const { mutate: logout } = useLogout();
  const { data: me } = useGetIdentity<AccountDto>();
  const { mode, setMode } = useContext(ColorModeContext);
  const { token } = theme.useToken();

  const profileMenuItems: MenuProps['items'] = [
    {
      key: "profile",
      label: (
        <Link to="/account/profile">
          <UserOutlined className="mr-2" /> Profile
        </Link>
      ),
    },
    {
      key: "orders",
      label: (
        <Link to="/account/orders">
          <ShoppingCartOutlined className="mr-2" /> My Orders
        </Link>
      ),
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
      key: "wallets",
      label: (
        <Link to="/wallets">{formatCurrency(me?.balance ?? 0)}</Link>
      ),
    },
    {
      type: "divider",
    },
    {
      key: "logout",
      label: (
        <span onClick={() => logout()}>
          <LogoutOutlined className="mr-2" /> Logout
        </span>
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
      <Avatar
        icon={<UserOutlined />}
        className="cursor-pointer"
        style={{ backgroundColor: token.colorPrimary }}
      />
    </Dropdown>
  );
};
