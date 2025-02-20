import React from "react";
import { Breadcrumb, Layout, Menu } from "antd";
import { ThemedHeaderV2 } from "@refinedev/antd";
import CustomerHeader from "../customer/header/customer-header";

const { Header, Content, Footer } = Layout;

interface AppProps {
  HeaderContent: React.FC;
  InnerContent: React.FC;
  FooterContent: React.FC;
}

export const ClientLayout: React.FC<AppProps> = ({
  HeaderContent,
  InnerContent,
  FooterContent,
}) => {
  return (
    <Layout>
      <CustomerHeader />

      <Content>
        <InnerContent />
      </Content>
      <Footer style={{ textAlign: "center" }}>
        <FooterContent />
      </Footer>
    </Layout>
  );
};

export default ClientLayout;
