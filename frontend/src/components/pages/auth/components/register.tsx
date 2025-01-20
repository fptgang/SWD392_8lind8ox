import React from "react";
import {
  type RegisterPageProps,
  type RegisterFormTypes,
  useRouterType,
  useLink,
  useActiveAuthProvider,
  useTranslate,
  useRouterContext,
  useRegister,
} from "@refinedev/core";
import { ThemedTitleV2 } from "@refinedev/antd";
import {
  layoutStyles,
  containerStyles,
  titleStyles,
  headStyles,
  bodyStyles,
} from "./styles";
import {
  Row,
  Col,
  Layout,
  Card,
  Typography,
  Form,
  Input,
  Button,
  type LayoutProps,
  type CardProps,
  type FormProps,
  Divider,
  theme,
  Select,
} from "antd";
import { Option } from "antd/es/mentions";

type RegisterProps = RegisterPageProps<LayoutProps, CardProps, FormProps>;
/**
 * **refine** has register.yml page form which is served on `/register.yml` route when the `authProvider` configuration is provided.
 *
 * @see {@link https://refine.dev/docs/ui-frameworks/antd/components/antd-auth-page/#register} for more details.
 */
export const RegisterPage: React.FC<RegisterProps> = ({
  providers,
  loginLink,
  wrapperProps,
  contentProps,
  renderContent,
  formProps,
  title,
  hideForm,
  mutationVariables,
}) => {
  const { token } = theme.useToken();
  const [form] = Form.useForm<RegisterFormTypes>();
  const translate = useTranslate();
  const routerType = useRouterType();
  const Link = useLink();
  const { Link: LegacyLink } = useRouterContext();

  const ActiveLink = routerType === "legacy" ? LegacyLink : Link;

  const authProvider = useActiveAuthProvider();
  const { mutate: register, isLoading } = useRegister<RegisterFormTypes>({
    v3LegacyAuthProviderCompatible: Boolean(authProvider?.isLegacy),
  });

  const PageTitle =
    title === false ? null : (
      <div
        style={{
          display: "flex",
          justifyContent: "center",
          marginBottom: "32px",
          fontSize: "20px",
        }}
      >
        {title ?? <ThemedTitleV2 collapsed={false} />}
      </div>
    );

  const CardTitle = (
    <Typography.Title
      level={3}
      style={{
        color: token.colorPrimaryTextHover,
        ...titleStyles,
      }}
    >
      {translate("pages.register.yml.title", "Sign up for your account")}
    </Typography.Title>
  );

  const renderProviders = () => {
    if (providers && providers.length > 0) {
      return (
        <>
          {providers.map((provider) => {
            return (
              <Button
                key={provider.name}
                type="default"
                block
                icon={provider.icon}
                style={{
                  display: "flex",
                  justifyContent: "center",
                  alignItems: "center",
                  width: "100%",
                  marginBottom: "8px",
                }}
                onClick={() =>
                  register({
                    ...mutationVariables,
                    providerName: provider.name,
                  })
                }
              >
                {provider.label}
              </Button>
            );
          })}
          {!hideForm && (
            <Divider>
              <Typography.Text
                style={{
                  color: token.colorTextLabel,
                }}
              >
                {translate(
                  "pages.register.yml.divider",
                  translate("pages.login.divider", "or")
                )}
              </Typography.Text>
            </Divider>
          )}
        </>
      );
    }
    return null;
  };

  const CardContent = (
    <Card
      title={CardTitle}
      headStyle={headStyles}
      bodyStyle={bodyStyles}
      style={{
        ...containerStyles,
        backgroundColor: token.colorBgElevated,
      }}
      {...(contentProps ?? {})}
    >
      {renderProviders()}
      {!hideForm && (
        <Form<RegisterFormTypes>
          layout="vertical"
          form={form}
          onFinish={(values) => register({ ...mutationVariables, ...values })}
          requiredMark={false}
          {...formProps}
        >
          <Form.Item
            name={["role"]}
            label={translate(
              "pages.register.yml.role",
              "Are u here as a freelancer or client?"
            )}
            rules={[
              {
                required: true,
                message: translate(
                  "pages.register.yml.errors.requiredRole",
                  "Role is required"
                ),
              },
            ]}
          >
            <Select
              placeholder={translate("pages.register.yml.fields.role", "Role")}
              allowClear
              size="large"
            >
              <Option value="FREELANCER">
                {translate("pages.register.yml.roles.admin", "Freelancer")}
              </Option>
              <Option value="CLIENT">
                {translate("pages.register.yml.roles.client", "Client")}
              </Option>
            </Select>
          </Form.Item>

          <Form.Item
            name={["firstName"]}
            label={translate("pages.register.yml.firstName", "First Name")}
            rules={[
              {
                required: true,
                message: translate(
                  "pages.register.yml.errors.requiredFirstName",
                  "First name is required"
                ),
              },
            ]}
          >
            <Input size="large" placeholder="John" />
          </Form.Item>
          <Form.Item
            name={["lastName"]}
            label={translate("pages.register.yml.lastName", "Last Name")}
            rules={[
              {
                required: true,
                message: translate(
                  "pages.register.yml.errors.requiredLastName",
                  "Last Name name is required"
                ),
              },
            ]}
          >
            <Input size="large" placeholder="Doe" />
          </Form.Item>

          <Form.Item
            name="email"
            label={translate("pages.register.yml.email", "Email")}
            rules={[
              {
                required: true,
                message: translate(
                  "pages.register.yml.errors.requiredEmail",
                  "Email is required"
                ),
              },
              {
                type: "email",
                message: translate(
                  "pages.register.yml.errors.validEmail",
                  "Invalid email address"
                ),
              },
            ]}
          >
            <Input
              size="large"
              placeholder={translate(
                "pages.register.yml.fields.email",
                "Email"
              )}
            />
          </Form.Item>
          <Form.Item
            name="password"
            label={translate("pages.register.yml.fields.password", "Password")}
            rules={[
              {
                required: true,
                message: translate(
                  "pages.register.yml.errors.requiredPassword",
                  "Password is required"
                ),
              },
            ]}
          >
            <Input type="password" placeholder="●●●●●●●●" size="large" />
          </Form.Item>
          <Form.Item
            name="confirmPassword"
            label={translate(
              "pages.register.yml.fields.confirmPassword",
              "Confirm Password"
            )}
            rules={[
              {
                required: true,
                message: translate(
                  "pages.register.yml.errors.requiredConfirmPassword",
                  "Confirm Password is required"
                ),
              },
            ]}
          >
            <Input type="password" placeholder="●●●●●●●●" size="large" />
          </Form.Item>
          <div className="flex justify-between mb-6">
            {loginLink ?? (
              <Typography.Text
                style={{
                  fontSize: 12,
                  marginLeft: "auto",
                }}
              >
                {translate(
                  "pages.register.yml.buttons.haveAccount",
                  translate(
                    "pages.login.buttons.haveAccount",
                    "Have an account?"
                  )
                )}{" "}
                <ActiveLink
                  style={{
                    fontWeight: "bold",
                    color: token.colorPrimaryTextHover,
                  }}
                  to="/login"
                >
                  {translate(
                    "pages.register.yml.signin",
                    translate("pages.login.signin", "Sign in")
                  )}
                </ActiveLink>
              </Typography.Text>
            )}
          </div>
          <Form.Item
            style={{
              marginBottom: 0,
            }}
          >
            <Button
              type="primary"
              size="large"
              htmlType="submit"
              loading={isLoading}
              block
            >
              {translate("pages.register.yml.buttons.submit", "Sign up")}
            </Button>
          </Form.Item>
        </Form>
      )}
      {hideForm && loginLink !== false && (
        <div
          style={{
            marginTop: hideForm ? 16 : 8,
          }}
        >
          <Typography.Text
            style={{
              fontSize: 12,
            }}
          >
            {translate(
              "pages.register.yml.buttons.haveAccount",
              translate("pages.login.buttons.haveAccount", "Have an account?")
            )}{" "}
            <ActiveLink
              style={{
                fontWeight: "bold",
                color: token.colorPrimaryTextHover,
              }}
              to="/login"
            >
              {translate(
                "pages.register.yml.signin",
                translate("pages.login.signin", "Sign in")
              )}
            </ActiveLink>
          </Typography.Text>
        </div>
      )}
    </Card>
  );

  return (
    <Layout style={layoutStyles} {...(wrapperProps ?? {})}>
      <Row
        justify="center"
        align={hideForm ? "top" : "middle"}
        style={{
          padding: "16px 0",
          minHeight: "100dvh",
          paddingTop: hideForm ? "15dvh" : "16px",
        }}
      >
        <Col xs={22}>
          {renderContent ? (
            renderContent(CardContent, PageTitle)
          ) : (
            <>
              {PageTitle}
              {CardContent}
            </>
          )}
        </Col>
      </Row>
    </Layout>
  );
};
