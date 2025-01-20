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
                accessControlProvider={accessControlProvider}
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
