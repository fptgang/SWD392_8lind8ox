import React from "react";
import { Menu } from "antd";
import type { MenuProps } from "antd";
import { Link } from "react-router";

export const Navigation: React.FC = () => {
  const items: MenuProps["items"] = [
    {
      key: "/",
      label: <Link to="/">Home</Link>,
    },
    {
      key: "/products",
      label: <Link to="/products">Products</Link>,
    },
    {
      key: "/cases",
      label: <Link to="/case">Buy Selected</Link>,
    },
  ];

  return (
    <Menu
      mode="horizontal"
      className="flex-1 justify-center border-none bg-transparent"
      selectedKeys={[window.location.pathname]}
      items={items}
    />
  );
};
