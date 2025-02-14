import React, { useContext } from "react";
import { Layout, theme } from "antd";
import { useIsAuthenticated } from "@refinedev/core";
import { ColorModeContext } from "../../contexts/color-mode";
import { Navigation } from "./Navigation";
import { CartPopover } from "./CartPopover";
import { UserMenu } from "./UserMenu";
import { Logo } from "./Logo";

const { Header } = Layout;

const CustomerHeader: React.FC = () => {
  const { data: isAuthenticated } = useIsAuthenticated();

  return (
    <Header className="shadow-sm">
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
