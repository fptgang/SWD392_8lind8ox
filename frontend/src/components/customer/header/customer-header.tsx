import React, { useContext } from "react";
import { Layout } from "antd";
import { useIsAuthenticated } from "@refinedev/core";
import { Navigation } from "./Navigation";
import { CartPopover } from "./CartPopover";
import { UserMenu } from "./UserMenu";
import { Logo } from "./Logo";
import { useTheme } from "antd-style";

const { Header } = Layout;

const CustomerHeader: React.FC = () => {
  const { data: isAuthenticated } = useIsAuthenticated();
  const theme = useTheme();
  return (
    <Header
      className="shadow-sm"
      style={{ backgroundColor: theme.colorBgElevated }}
    >
      <div className="max-w-7xl mx-auto px-6">
        <div className="flex justify-between items-center h-16">
          <Logo />
          <Navigation />
          <div className="flex items-center space-x-4">
            <CartPopover />
            <UserMenu isAuthenticated={isAuthenticated?.authenticated} />
          </div>
        </div>
      </div>
    </Header>
  );
};

export default CustomerHeader;
