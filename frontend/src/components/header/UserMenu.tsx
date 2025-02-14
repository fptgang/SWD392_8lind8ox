import React, { useContext } from "react";
import { Menu, Dropdown, Avatar, Button, Space, Switch, theme } from "antd";
import {
  UserOutlined,
  ShoppingCartOutlined,
  LogoutOutlined,
  LoginOutlined,
} from "@ant-design/icons";
import { Link } from "react-router";
import { useLogout, useGetIdentity } from "@refinedev/core";
import { ColorModeContext } from "../../contexts/color-mode";
import { AccountDto } from "../../../generated";
import { formatCurrency } from "../../utils/currency-formatter";

interface UserMenuProps {
  isAuthenticated?: boolean;
}

export const UserMenu: React.FC<UserMenuProps> = ({ isAuthenticated }) => {
  const { mutate: logout } = useLogout();
  const { data: me } = useGetIdentity<AccountDto>();
  const { mode, setMode } = useContext(ColorModeContext);
  const { token } = theme.useToken();

  const profileMenu = (
    <Menu>
      <Menu.Item key="profile">
        <Link to="/account/profile">
          <UserOutlined className="mr-2" /> Profile
        </Link>
      </Menu.Item>
      <Menu.Item key="orders">
        <Link to="/account/orders">
          <ShoppingCartOutlined className="mr-2" /> My Orders
        </Link>
      </Menu.Item>
      <Menu.Item key="theme">
        <Space>
          Dark Mode
          <Switch
            checked={mode === "dark"}
            onChange={() => setMode(mode === "light" ? "dark" : "light")}
          />
        </Space>
      </Menu.Item>
      <Menu.Divider />
      <Menu.Item key="wallets">
        <Link to="/wallets">{formatCurrency(me?.balance ?? 0)}</Link>
      </Menu.Item>
      <Menu.Divider />
      <Menu.Item key="logout" onClick={() => logout()}>
        <LogoutOutlined className="mr-2" /> Logout
      </Menu.Item>
    </Menu>
  );

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
    <Dropdown overlay={profileMenu} trigger={["click"]}>
      <Avatar
        icon={<UserOutlined />}
        className="cursor-pointer"
        style={{ backgroundColor: token.colorPrimary }}
      />
    </Dropdown>
  );
};
