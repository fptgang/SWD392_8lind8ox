import { IResourceItem, useTranslate } from "@refinedev/core";
import { UserOutlined, ShopOutlined, GiftOutlined, ShoppingCartOutlined, RobotOutlined, TagsOutlined, InboxOutlined, AppstoreOutlined } from "@ant-design/icons";

export const getResources = (): IResourceItem[] => {
  return [
    {
      name: "dashboard",
      icon: <AppstoreOutlined />,
      list: "/admin/dashboard",
      meta: {
        label: "Dashboard",
        icon: <AppstoreOutlined />,
      },
    },
    {
      name: "accounts",
      list: "/admin/accounts",
      create: "/admin/accounts/create",
      edit: "/admin/accounts/edit/:id",
      show: "/admin/accounts/show/:id",
      meta: {
        label: "Accounts",
        canDelete: true,
        icon: <UserOutlined />,
        parent: "user-management"
      },
    },
    {
      name: "brands",
      list: "/admin/brands",
      create: "/admin/brands/create",
      edit: "/admin/brands/edit/:id",
      show: "/admin/brands/show/:id",
      meta: {
        label: "Brands",
        icon: <ShopOutlined />,
        parent: "catalog"
      },
    },
    {
      name: "packs",
      list: "/admin/packs",
      create: "/admin/packs/create",
      edit: "/admin/packs/edit/:id",
      show: "/admin/packs/show/:id",
      meta: {
        label: "Packs",
        icon: <GiftOutlined />,
        parent: "catalog"
      },
    },
    {
      name: "orders",
      list: "/admin/orders",
      create: "/admin/orders/create",
      edit: "/admin/orders/edit/:id",
      show: "/admin/orders/show/:id",
      meta: {
        label: "Orders",
        icon: <ShoppingCartOutlined />,
        parent: "sales"
      },
    },
    {
      name: "promotional-campaigns",
      list: "/admin/promotional-campaigns",
      create: "/admin/promotional-campaigns/create",
      edit: "/admin/promotional-campaigns/edit/:id",
      show: "/admin/promotional-campaigns/show/:id",
      meta: {
        label: "Promotions",
        icon: <TagsOutlined />,
        parent: "marketing"
      },
    },
    {
      name: "blind-boxes",
      list: "/admin/blind-boxes",
      create: "/admin/blind-boxes/create",
      edit: "/admin/blind-boxes/edit/:id",
      show: "/admin/blind-boxes/show/:id",
      meta: {
        label: "Blind Boxes",
        icon: <InboxOutlined />,
        parent: "catalog"
      },
    },
    {
      name: "catalog",
      icon: <ShopOutlined />,
    },
    {
      name: "sales",
      icon: <ShoppingCartOutlined />,
    },
    {
      name: "marketing",
      icon: <TagsOutlined />,
    },
    {
      name: "user-management",
      icon: <UserOutlined />,
    },
  ];
};

export const useResourceItems = (): IResourceItem[] => {
  const t = useTranslate();
  const resources = getResources();

  return resources.map(resource => ({
    ...resource,
    meta: {
      ...resource.meta,
      label: resource.meta?.label ? t(`resources.${resource.name}.label`) : resource.name
    }
  }));
};