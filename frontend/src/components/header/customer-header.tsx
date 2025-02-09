import React from 'react';
import { ShoppingCartOutlined, UserOutlined, LogoutOutlined, LoginOutlined, UserAddOutlined, MinusOutlined, PlusOutlined, DeleteOutlined } from '@ant-design/icons';
import { Layout, Menu, Input, Badge, Space, Dropdown, Avatar, Button, theme, Tooltip, Popover, InputNumber, Switch } from 'antd';
import { Link } from 'react-router';
import { useLogout, useAuthenticated, useIsAuthenticated, useGetIdentity } from "@refinedev/core";
import { useCart } from '../../hooks/useCart';
import { useContext } from 'react';
import { ColorModeContext } from '../../contexts/color-mode';
import { AccountDto } from '../../../generated';
import { formatCurrency } from '../../utils/currency-formatter';

const { Header } = Layout;
const { Search } = Input;

const CustomerHeader: React.FC = () => {
  const { cartItems, updateQuantity, removeItem } = useCart();
  const me = useGetIdentity<AccountDto>();
  const { mutate: logout } = useLogout();
  const { data: isAuthenticated } = useIsAuthenticated();
  const { token } = theme.useToken();
  const { mode, setMode } = useContext(ColorModeContext);

  const profileMenu = (
    <Menu>
      <Menu.Item key="profile">
        <Link to="/account/profile">
          <UserOutlined /> Profile
        </Link>
      </Menu.Item>
      <Menu.Item key="orders">
        <Link to="/account/orders">
          <ShoppingCartOutlined /> My Orders
        </Link>
      </Menu.Item>
      <Menu.Item key="theme">
        <Space>
          Dark Mode
          <Switch
            checked={mode === 'dark'}
            onChange={() => setMode(mode === 'light' ? 'dark' : 'light')}
          />
        </Space>
      </Menu.Item>
      <Menu.Divider />
      <Menu.Item key="wallets">
      <Link to="/wallets">
      {formatCurrency(me.data?.balance ?? 0)}
        </Link>
        </Menu.Item>
      <Menu.Divider />
      <Menu.Item key="logout" onClick={() => logout()}>
        <LogoutOutlined /> Logout
      </Menu.Item>
    </Menu>
  );

  const renderAuthButtons = () => {
    if (isAuthenticated) {
      return (
        <Dropdown overlay={profileMenu} trigger={['click']}>
          <Avatar
            icon={<UserOutlined />}
            style={{ backgroundColor: token.colorPrimary }}
          />
        </Dropdown>
      );
    }

    return (
      <Space>
        <Link to="/login">
          <Button type="text" icon={<LoginOutlined />}>
            Login
          </Button>
        </Link>
        <Link to="/register">
          <Button type="primary" icon={<UserAddOutlined />}>
            Sign Up
          </Button>
        </Link>
      </Space>
    );
  };

  return (
    <Header style={{ background: token.colorBgContainer }}>
      <div style={{ maxWidth: '1200px', margin: '0 auto', padding: '0 24px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', height: '64px' }}>
          {/* Logo */}
          <Link to="/" style={{ fontSize: '20px', fontWeight: 'bold', color: token.colorText }}>
            Store Logo
          </Link>

          {/* Navigation Links */}
          <Menu 
            mode="horizontal" 
            style={{ 
              border: 'none',
              background: 'transparent',
              flex: 1,
              justifyContent: 'center'
            }}
          >
            <Menu.Item key="home">
              <Link to="/">Home</Link>
            </Menu.Item>
            <Menu.Item key="products">
              <Link to="/products">Products</Link>
            </Menu.Item>
  
          </Menu>

          {/* Right Icons */}
          <Space size="large">
          <Popover
                  placement="bottomRight"
                  trigger="hover"
                  content={
                    <div style={{ width: '300px', maxHeight: '400px', overflowY: 'auto' }}>
                      {cartItems.length === 0 ? (
                        <div style={{ textAlign: 'center', padding: '16px' }}>
                          <p>Your cart is empty</p>
                        </div>
                      ) : (
                        <div>
                          {cartItems.map((item) => (
                            <div key={item.id} style={{ padding: '8px 0', borderBottom: `1px solid ${token.colorBorder}` }}>
                              <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                                <img src={item.image} alt={item.name} style={{ width: '50px', height: '50px', objectFit: 'cover' }} />
                                <div style={{ flex: 1 }}>
                                  <div style={{ fontWeight: 'bold' }}>{item.name}</div>
                                  <div>{formatCurrency(item.price)}</div>
                                </div>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                                  <Button
                                    size="small"
                                    icon={<MinusOutlined />}
                                    onClick={() => updateQuantity(item.id, Math.max(1, (item.quantity || 1) - 1))}
                                  />
                                  <InputNumber
                                    min={1}
                                    value={item.quantity || 1}
                                    onChange={(value) => updateQuantity(item.id, value || 1)}
                                    style={{ width: '60px' }}
                                  />
                                  <Button
                                    size="small"
                                    icon={<PlusOutlined />}
                                    onClick={() => updateQuantity(item.id, (item.quantity || 1) + 1)}
                                  />
                                  <Button
                                    type="text"
                                    danger
                                    icon={<DeleteOutlined />}
                                    onClick={() => removeItem(item.id)}
                                  />
                                </div>
                              </div>
                            </div>
                          ))}
                          <div style={{ padding: '16px 0' }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
                              <strong>Total:</strong>
                              <span>{formatCurrency(cartItems.reduce((sum, item) => sum + (item.price * (item.quantity || 1)), 0))}</span>
                            </div>
                            <Link to="/cart">
                              <Button type="primary" block>View Cart</Button>
                            </Link>
                          </div>
                        </div>
                      )}
                    </div>
                  }
                >
                  <Badge count={cartItems.length} size="small">
                    <ShoppingCartOutlined style={{ fontSize: '20px', color: token.colorText, cursor: 'pointer' }} />
                  </Badge>
                </Popover>
            {isAuthenticated?.authenticated ? (
              <>
                <Dropdown overlay={profileMenu} trigger={['click']}>
                  <Avatar
                    icon={<UserOutlined />}
                    style={{ backgroundColor: token.colorPrimary, cursor: 'pointer' }}
                  />
                </Dropdown>
              </>
            ) : (
              <Link to="/login">
                <Button type="primary" icon={<LoginOutlined />}>
                  Login
                </Button>
              </Link>
            )}
          </Space>
        </div>
      </div>
    </Header>
  );
};

export default CustomerHeader;
