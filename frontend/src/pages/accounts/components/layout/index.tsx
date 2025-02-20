import React from "react";
import { Layout } from "antd";
import { Outlet } from "react-router";
import { AccountSider } from "./components/AccountSider";

const { Content } = Layout;

export const AccountLayout: React.FC = () => {
  return (
    <Layout className="min-h-screen ">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 w-full">
        <div className="flex gap-8">
          <AccountSider />
          <Content className="flex-1  min-h-[280px] rounded-lg shadow-sm p-6 mt-4">
            <Outlet />
          </Content>
        </div>
      </div>
    </Layout>
  );
};

export default AccountLayout;
