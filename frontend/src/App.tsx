import { Authenticated, I18nProvider, Refine } from "@refinedev/core";
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
import LandingPage from "./pages/customer/landing";
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

import {
  PromotionalCampaignsCreate,
  PromotionalCampaignsEdit,
  PromotionalCampaignsList,
  PromotionalCampaignsShow,
} from "./pages/promotional-campaigns";
import CustomerFooter from "./components/footer/customer-footer";
import CustomerProducts from "./pages/customer/products/list";
import CustomerDeals from "./pages/customer/deals";
import ProfilePage from "./pages/accounts/profile";
import CustomerOrders from "./pages/customer/orders";
import CartPage from "./pages/cart";
import { SecuritySettings } from "./pages/accounts/components/SecuritySettings";
import { WalletSettings } from "./pages/accounts/components/WalletSettings";
import { Provider } from "react-redux";
import { store } from "./store";
import { OrderSuccess } from "./pages/checkout/order-success";
import { OrderFailed } from "./pages/checkout/order-failed";
import CheckoutPage from "./pages/checkout";
import { DashboardPage } from "./pages/dashboard";
import { getResources } from "./config/resources";
import { useTranslation } from "react-i18next";
import CustomerHeader from "./components/customer/header/customer-header";
import CustomerOrderList from "./pages/customer/setting/CustomerOrderList";
import AccountLayout from "./pages/accounts/components/layout";
import { AccountDtoRoleEnum } from "../generated";
import { AdminHeader } from "./components/header";
import CustomerProductShow from "./pages/customer/products/show";

function App() {
  const { t, i18n } = useTranslation();

  const i18nProvider: I18nProvider = {
    translate: (key: string, options?: any): string => String(t(key, options)),
    changeLocale: (lang: string) => {
      i18n.changeLanguage(lang);
      console.log("changeLocale", lang);
    },
    getLocale: () => i18n.language,
  };
  return (
    <BrowserRouter>
      <RefineKbarProvider>
        <ColorModeContextProvider>
          <AntdApp>
            <Provider store={store}>
              <DevtoolsProvider>
                <Refine
                  dataProvider={dataProvider(API_URL, axiosInstance)}
                  notificationProvider={notificationProvider}
                  // accessControlProvider={accessControlProvider}
                  authProvider={authProvider}
                  routerProvider={routerBindings}
                  i18nProvider={i18nProvider}
                  resources={getResources()}
                  options={{
                    syncWithLocation: true,
                    warnWhenUnsavedChanges: true,
                    useNewQueryKeys: true,
                    title: { text: "8lind8ox", icon: <AppIcon /> },
                    projectId: "HC85dn-RQLFdc-7emtiC",
                  }}
                >
                  <Routes>
                    {/* Public Routes */}
                    <Route
                      element={
                        <ClientLayout
                          HeaderContent={() => <CustomerHeader />}
                          InnerContent={() => <Outlet />}
                          FooterContent={() => <CustomerFooter />}
                        />
                      }
                    >
                      {/* Main Customer Routes */}
                      <Route index element={<LandingPage />} />
                      <Route path="products" element={<CustomerProducts />} />
                      <Route
                        path="products/:id"
                        element={<CustomerProductShow />}
                      />
                      <Route path="deals" element={<CustomerDeals />} />
                      <Route path="blind-boxes" element={<BlindBoxesList />} />
                      <Route
                        path="blind-boxes/:id"
                        element={<BlindBoxesShow />}
                      />
                      <Route path="packs" element={<PacksList />} />
                      <Route path="packs/:id" element={<PacksShow />} />
                      <Route path="orders" element={<OrdersList />} />
                      <Route path="orders/:id" element={<CustomerOrders />} />

                      {/* Customer Account Routes */}
                      <Route
                        path="account"
                        element={
                          <Authenticated
                            key={"authenticated"}
                            fallback={<Navigate to="/login" />}
                          >
                            <AccountLayout />
                          </Authenticated>
                        }
                      >
                        <Route path="profile" element={<ProfilePage />} />
                        <Route path="security" element={<SecuritySettings />} />
                        <Route path="wallet" element={<WalletSettings />} />
                        <Route path="orders" element={<CustomerOrderList />} />
                        <Route path="orders/:id" element={<OrdersShow />} />
                      </Route>

                      {/* Cart and Checkout */}
                      <Route path="cart" element={<CartPage />} />
                      <Route
                        path="checkout"
                        element={
                          <Authenticated
                            key={"authenticated"}
                            fallback={<Navigate to="/login" />}
                          >
                            <Outlet />
                          </Authenticated>
                        }
                      >
                        <Route index element={<CheckoutPage />} />
                        <Route path="success" element={<OrderSuccess />} />
                        <Route path="failed" element={<OrderFailed />} />
                      </Route>
                    </Route>

                    {/* Auth Routes */}
                    <Route path="login" element={<Login />} />
                    <Route path="register" element={<Register />} />
                    <Route
                      path="forgot-password"
                      element={<ForgotPassword />}
                    />
                    <Route path="reset-password" element={<ResetPassword />} />
                    {/* Admin Routes */}
                    <Route
                      path="admin"
                      element={
                        localStorage.getItem("role") ===
                        AccountDtoRoleEnum.Admin ? (
                          <Authenticated
                            key="authenticated"
                            fallback={<Navigate to="/login" replace />}
                          >
                            <ThemedLayoutV2
                              Header={AdminHeader}
                              Sider={(props) => (
                                <ThemedSiderV2 {...props} fixed />
                              )}
                            >
                              <Outlet />
                            </ThemedLayoutV2>
                            //{" "}
                          </Authenticated>
                        ) : (
                          <Navigate to="/" />
                        )
                      }
                    >
                      <Route
                        index
                        element={<NavigateToResource resource="dashboard" />}
                      />
                      <Route path="dashboard" element={<DashboardPage />} />

                      {/* Admin Management Routes */}
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
                    </Route>

                    {/* Catch-all Error Route */}
                    <Route path="*" element={<ErrorComponent />} />
                  </Routes>

                  <RefineKbar />
                  <UnsavedChangesNotifier />
                  <DocumentTitleHandler />
                </Refine>
                <DevtoolsPanel />
              </DevtoolsProvider>
            </Provider>
          </AntdApp>
        </ColorModeContextProvider>
      </RefineKbarProvider>
    </BrowserRouter>
  );
}

export default App;
