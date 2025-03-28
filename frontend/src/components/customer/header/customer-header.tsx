import React, { useContext, useState, useEffect } from "react";
import { Layout, Badge, Button, Tooltip } from "antd";
import { useIsAuthenticated, useNavigation } from "@refinedev/core";
import { Navigation } from "./Navigation";
import { CartPopover } from "./CartPopover";
import { UserMenu } from "./UserMenu";
import { Logo } from "./Logo";
import { useTheme } from "antd-style";
import { BellOutlined, GiftOutlined } from "@ant-design/icons";
import NotificationPopover from "./NotificationPopover";
import { motion } from "framer-motion";

const { Header } = Layout;

const CustomerHeader: React.FC = () => {
  const { data: isAuthenticated } = useIsAuthenticated();
  const { push } = useNavigation();
  const theme = useTheme();
  const [dailyBoxAvailable, setDailyBoxAvailable] = useState(false);
  const [openedBoxCount, setOpenedBoxCount] = useState(0);

  // Check if daily box is available
  useEffect(() => {
    const lastOpenedDate = localStorage.getItem("lastBoxOpenedDate");
    const today = new Date().toDateString();

    setDailyBoxAvailable(lastOpenedDate !== today);

    // Get total opened box count
    const count = localStorage.getItem("openedBoxCount");
    if (count) {
      setOpenedBoxCount(parseInt(count));
    }
  }, []);

  const handleOpenBoxClick = () => {
    push("/open");
  };

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
            {/* <Tooltip 
              title={dailyBoxAvailable ? "Open it now!" : "Check your blind box collection"} 
              placement="bottom"
            >
              <Badge count={dailyBoxAvailable ? 1 : 0} size="small" offset={[-2, 2]}>
                <motion.div
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                >
                  <Button
                    type="text"
                    icon={
                      <GiftOutlined 
                        style={{ 
                          color: dailyBoxAvailable ? theme.colorPrimary : undefined,
                          fontSize: '20px' 
                        }} 
                      />
                    }
                    className={dailyBoxAvailable ? "animate-pulse" : ""}
                    onClick={handleOpenBoxClick}
                  >
                    <span className="hidden sm:inline ml-1">
                      Open{openedBoxCount > 0 && <span className="text-xs ml-1">({openedBoxCount})</span>}
                    </span>
                  </Button>
                </motion.div>
              </Badge>
            </Tooltip> */}
            <NotificationPopover />
            <CartPopover />
            <UserMenu isAuthenticated={isAuthenticated?.authenticated} />
          </div>
        </div>
      </div>
    </Header>
  );
};

export default CustomerHeader;
