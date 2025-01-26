import { Authenticated, Refine } from "@refinedev/core";
import { DevtoolsPanel, DevtoolsProvider } from "@refinedev/devtools";
import { RefineKbar, RefineKbarProvider } from "@refinedev/kbar";

import { ErrorComponent, ThemedLayoutV2, ThemedSiderV2 } from "@refinedev/antd";
import "@refinedev/antd/dist/reset.css";

import routerBindings, {
  DocumentTitleHandler,
  NavigateToResource,
  UnsavedChangesNotifier,
} from "@refinedev/react-router";
import { App as AntdApp } from "antd";
import { BrowserRouter, Navigate, Outlet, Route, Routes } from "react-router";
import { authProvider } from "./authProvider";
import { AppIcon } from "./components/app-icon";
import { Header } from "./components/header";
import { ColorModeContextProvider } from "./contexts/color-mode";

import { ForgotPassword } from "./pages/forgotPassword";
import { Login } from "./pages/login";
import { Register } from "./pages/register";
import { accessControlProvider } from "./providers/access-control-provider";
import { dataProvider } from "./providers/data-provider";
import { API_URL } from "./utils/constants";

import {
  UsersCreate,
  AccountsEdit,
  AccountsList,
  AccountsShow,
} from "./pages/accounts";
import ResetPassword from "./pages/reset-password";
import { notificationProvider } from "./providers/notification-provider";
import axiosInstance from "./config/axios-config";
import ClientLayout from "./components/layout";
import Footer from "./components/ui/footer/footer";
import LandingPage from "./pages/landing";
import {
  BrandsCreate,
  BrandsEdit,
  BrandsList,
  BrandsShow,
} from "./pages/brands";
import {
  BlindBoxesCreate,
  BlindBoxesEdit,
  BlindBoxesList,
  BlindBoxesShow,
} from "./pages/blind-boxes";
import { PacksCreate, PacksEdit, PacksList, PacksShow } from "./pages/packs";
import {
  OrdersCreate,
  OrdersEdit,
  OrdersList,
  OrdersShow,
} from "./pages/orders";
import { ToysCreate, ToysEdit, ToysList, ToysShow } from "./pages/toys";
import {
  ProductsCreate,
  ProductsEdit,
  ProductsList,
  ProductsShow,
} from "./pages/products";
import {
  PromotionalCampaignsCreate,
  PromotionalCampaignsEdit,
  PromotionalCampaignsList,
  PromotionalCampaignsShow,
} from "./pages/promotional-campaigns";

function App() {
  return (
    <BrowserRouter>
      <RefineKbarProvider>
        <ColorModeContextProvider>
          <AntdApp>
            <DevtoolsProvider>
              <Refine
                dataProvider={dataProvider(API_URL, axiosInstance)}
                notificationProvider={notificationProvider}
                // accessControlProvider={accessControlProvider}
                authProvider={authProvider}
                routerProvider={routerBindings}
                resources={[
                  {
                    name: "accounts",
                    list: "/admin/accounts",
                    create: "/admin/accounts/create",
                    edit: "/admin/accounts/edit/:id",
                    show: "/admin/accounts/show/:id",
                    meta: {
                      label: "Accounts",
                      canDelete: true,
                    },
                  },
                  {
                    name: "brands",
                    list: "/admin/brands",
                    create: "/admin/brands/create",
                    edit: "/admin/brands/edit/:id",
                    show: "/admin/brands/show/:id",
                  },
                  {
                    name: "packs",
                    list: "/admin/packs",
                    create: "/admin/packs/create",
                    edit: "/admin/packs/edit/:id",
                    show: "/admin/packs/show/:id",
                  },
                  {
                    name: "orders",
                    list: "/admin/orders",
                    create: "/admin/orders/create",
                    edit: "/admin/orders/edit/:id",
                    show: "/admin/orders/show/:id",
                  },
                  {
                    name: "toys",
                    list: "/admin/toys",
                    create: "/admin/toys/create",
                    edit: "/admin/toys/edit/:id",
                    show: "/admin/toys/show/:id",
                  },
                  {
                    name: "promotional-campaigns",
                    list: "/admin/promotional-campaigns",
                    create: "/admin/promotional-campaigns/create",
                    edit: "/admin/promotional-campaigns/edit/:id",
                    show: "/admin/promotional-campaigns/show/:id",
                  },
                  {
                    name: "blind-boxes",
                    list: "/admin/blind-boxes",
                    create: "/admin/blind-boxes/create",
                    edit: "/admin/blind-boxes/edit/:id",
                    show: "/admin/blind-boxes/show/:id",
                  },
                  {
                    name: "products",
                    list: "/admin/products",
                    create: "/admin/products/create",
                    edit: "/admin/products/edit/:id",
                    show: "/admin/products/show/:id",
                  },
                ]}
                options={{
                  syncWithLocation: true,
                  warnWhenUnsavedChanges: true,
                  useNewQueryKeys: true,
                  title: { text: "8lind8ox", icon: <AppIcon /> },
                }}
              >
                <Routes>
                  <Route
                    element={
                      <ClientLayout
                        HeaderContent={() => <Header />}
                        InnerContent={() => <Outlet />}
                        FooterContent={() => <Footer />}
                      />
                    }
                  >
                    <Route index element={<LandingPage />} />
                    <Route
                      path="/settings"
                      element={<Navigate to="/admin" />}
                    />
                    <Route path="/reset-password" element={<ResetPassword />} />
                    <Route path="*" element={<ErrorComponent />} />
                  </Route>
                  <Route
                    path="/admin"
                    element={
                      localStorage.getItem("role") === "ADMIN" ? (
                        <Authenticated
                          key="authenticated-inner"
                          fallback={<Navigate to={"/"} replace />}
                        >
                          <ThemedLayoutV2
                            Header={Header}
                            Sider={(props) => (
                              <ThemedSiderV2 {...props} fixed />
                            )}
                          >
                            <Outlet />
                          </ThemedLayoutV2>
                        </Authenticated>
                      ) : (
                        <Navigate to="/" />
                      )
                    }
                  >
                    <Route
                      index
                      element={<NavigateToResource resource="accounts" />}
                    />
                    <Route path="accounts">
                      <Route index element={<AccountsList />} />
                      <Route path="create" element={<UsersCreate />} />
                      <Route path="edit/:id" element={<AccountsEdit />} />
                      <Route path="show/:id" element={<AccountsShow />} />
                    </Route>
                    <Route path="brands">
                      <Route index element={<BrandsList />} />
                      <Route path="create" element={<BrandsCreate />} />
                      <Route path="edit/:id" element={<BrandsEdit />} />
                      <Route path="show/:id" element={<BrandsShow />} />
                    </Route>
                    <Route path="blind-boxes">
                      <Route index element={<BlindBoxesList />} />
                      <Route path="create" element={<BlindBoxesCreate />} />
                      <Route path="edit/:id" element={<BlindBoxesEdit />} />
                      <Route path="show/:id" element={<BlindBoxesShow />} />
                    </Route>
                    <Route path="packs">
                      <Route index element={<PacksList />} />
                      <Route path="create" element={<PacksCreate />} />
                      <Route path="edit/:id" element={<PacksEdit />} />
                      <Route path="show/:id" element={<PacksShow />} />
                    </Route>
                    <Route path="orders">
                      <Route index element={<OrdersList />} />
                      <Route path="create" element={<OrdersCreate />} />
                      <Route path="edit/:id" element={<OrdersEdit />} />
                      <Route path="show/:id" element={<OrdersShow />} />
                    </Route>
                    <Route path="toys">
                      <Route index element={<ToysList />} />
                      <Route path="create" element={<ToysCreate />} />
                      <Route path="edit/:id" element={<ToysEdit />} />
                      <Route path="show/:id" element={<ToysShow />} />
                    </Route>
                    <Route path="products">
                      <Route index element={<ProductsList />} />
                      <Route path="create" element={<ProductsCreate />} />
                      <Route path="edit/:id" element={<ProductsEdit />} />
                      <Route path="show/:id" element={<ProductsShow />} />
                    </Route>
                    <Route path="promotional-campaigns">
                      <Route index element={<PromotionalCampaignsList />} />
                      <Route
                        path="create"
                        element={<PromotionalCampaignsCreate />}
                      />
                      <Route
                        path="edit/:id"
                        element={<PromotionalCampaignsEdit />}
                      />
                      <Route
                        path="show/:id"
                        element={<PromotionalCampaignsShow />}
                      />
                    </Route>

                    <Route path="*" element={<ErrorComponent />} />
                  </Route>
                  <Route
                    element={
                      <Authenticated
                        key="authenticated-outer"
                        fallback={<Outlet />}
                      >
                        {localStorage.getItem("role") === "ADMIN" ? (
                          <NavigateToResource />
                        ) : (
                          <Navigate to="/" />
                        )}
                      </Authenticated>
                    }
                  >
                    <Route path="/login" element={<Login />} />
                    <Route path="/register" element={<Register />} />
                    <Route
                      path="/forgot-password"
                      element={<ForgotPassword />}
                    />
                  </Route>
                </Routes>

                <RefineKbar />
                <UnsavedChangesNotifier />
                <DocumentTitleHandler />
              </Refine>
              <DevtoolsPanel />
            </DevtoolsProvider>
          </AntdApp>
        </ColorModeContextProvider>
      </RefineKbarProvider>
    </BrowserRouter>
  );
}

export default App;
