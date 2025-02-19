import React from "react";
import { Menu } from "antd";
import { Link } from "react-router";

export const Navigation: React.FC = () => {
  return (
    <Menu
      mode="horizontal"
      className="flex-1 justify-center border-none bg-transparent"
      selectedKeys={[window.location.pathname]}
    >
      <Menu.Item key="/">
        <Link to="/">Home</Link>
      </Menu.Item>
      <Menu.Item key="/products">
        <Link to="/products">Products</Link>
      </Menu.Item>
    </Menu>
  );
};
