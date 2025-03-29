import React, {useEffect, useState} from "react";
import {
  Badge,
  Button,
  Drawer,
  Dropdown,
  Input,
  Layout,
  Modal,
  notification,
  Space,
  theme,
  Tooltip,
  Typography,
} from "antd";
import {
  CloseOutlined,
  DownOutlined,
  FireOutlined,
  GiftOutlined,
  MenuOutlined,
  SearchOutlined,
  StarOutlined,
  TrophyOutlined,
  UserOutlined,
} from "@ant-design/icons";
import {useNavigate} from "react-router";
import {Authenticated} from "@refinedev/core";
import {motion} from "framer-motion";

const {Header} = Layout;
const {Title, Text} = Typography;
const {useToken} = theme;

// Rewards data
const REWARDS = [
  {
    id: 1,
    name: "5% Discount Code",
    icon: <FireOutlined style={{color: '#ff4d4f'}}/>,
    rarity: "common"
  },
  {
    id: 2,
    name: "10% Discount Code",
    icon: <FireOutlined style={{color: '#ff4d4f'}}/>,
    rarity: "common"
  },
  {
    id: 3,
    name: "15% Discount Code",
    icon: <StarOutlined style={{color: '#faad14'}}/>,
    rarity: "uncommon"
  },
  {
    id: 4,
    name: "Free Shipping",
    icon: <StarOutlined style={{color: '#faad14'}}/>,
    rarity: "uncommon"
  },
  {
    id: 5,
    name: "Mystery Box",
    icon: <TrophyOutlined style={{color: '#722ed1'}}/>,
    rarity: "rare"
  },
  {
    id: 6,
    name: "Exclusive Collectible",
    icon: <TrophyOutlined style={{color: '#722ed1'}}/>,
    rarity: "rare"
  },
];

export default function NavBar() {
  const {token} = useToken();
  const [searchTerm, setSearchTerm] = React.useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [isRewardModalOpen, setIsRewardModalOpen] = useState(false);
  const [isBoxOpening, setIsBoxOpening] = useState(false);
  const [currentReward, setCurrentReward] = useState<any>(null);
  const [openedBoxCount, setOpenedBoxCount] = useState(0);
  const [dailyBoxOpened, setDailyBoxOpened] = useState(false);
  const nav = useNavigate();

  // Check if daily box has been opened
  useEffect(() => {
    const lastOpenedDate = localStorage.getItem('lastBoxOpenedDate');
    const today = new Date().toDateString();

    if (lastOpenedDate === today) {
      setDailyBoxOpened(true);
    } else {
      setDailyBoxOpened(false);
    }

    // Get total opened box count
    const count = localStorage.getItem('openedBoxCount');
    if (count) {
      setOpenedBoxCount(parseInt(count));
    }
  }, []);

  const handleSearch = (value: string) => {
    setSearchTerm(value);
  };

  const handleLogin = () => {
    nav("/login");
    setMobileMenuOpen(false);
  };

  const handleSignup = () => {
    nav("/register");
    setMobileMenuOpen(false);
  };

  const handleLogoClick = () => {
    nav("/");
    setMobileMenuOpen(false);
  };

  // Handle opening a blind box
  const handleOpenBox = () => {
    if (dailyBoxOpened) {
      notification.info({
        message: "Box Already Opened",
        description: "You've already opened your daily blind box. Come back tomorrow for another reward!",
        placement: "top",
      });
      return;
    }

    setIsBoxOpening(true);

    // Simulate box opening animation
    setTimeout(() => {
      // Randomly select a reward with rarity weights
      const random = Math.random();
      let reward;

      if (random < 0.6) {
        // 60% chance for common rewards
        reward = REWARDS.filter(r => r.rarity === "common")[Math.floor(Math.random() * 2)];
      } else if (random < 0.9) {
        // 30% chance for uncommon rewards
        reward = REWARDS.filter(r => r.rarity === "uncommon")[Math.floor(Math.random() * 2)];
      } else {
        // 10% chance for rare rewards
        reward = REWARDS.filter(r => r.rarity === "rare")[Math.floor(Math.random() * 2)];
      }

      setCurrentReward(reward);
      setIsBoxOpening(false);
      setIsRewardModalOpen(true);

      // Update opened box state
      const today = new Date().toDateString();
      localStorage.setItem('lastBoxOpenedDate', today);
      setDailyBoxOpened(true);

      // Update total count
      const newCount = openedBoxCount + 1;
      setOpenedBoxCount(newCount);
      localStorage.setItem('openedBoxCount', newCount.toString());
    }, 2000);
  };

  const handleCloseRewardModal = () => {
    setIsRewardModalOpen(false);
  };

  const getRewardColor = (rarity: "common" | "uncommon" | "rare"): string => {
    switch (rarity) {
      case "common":
        return token.colorError;
      case "uncommon":
        return token.colorWarning;
      case "rare":
        return token.colorPrimary;
      default:
        return token.colorPrimary;
    }
  };

  const menuItems = {
    findTalent: [
      {key: "home", label: "Home"},
      {key: "about", label: "About"},
      {key: "contact", label: "Contact"},
    ],
    findWork: [
      {key: "services", label: "Services"},
      {key: "pricing", label: "Pricing"},
      {key: "faq", label: "FAQ"},
    ],
  };

  return (
    <Header
      className={`
      sticky top-0 z-50 px-6 h-16 flex items-center
      border-b border-solid w-full
    `}
      style={{
        backgroundColor: token.colorBgElevated,
        borderColor: token.colorBorderSecondary,
      }}
    >
      <div className="flex items-center justify-between w-full">
        {/* Logo and Desktop Navigation */}
        <div className="flex items-center">
          <div
            className="flex items-center cursor-pointer mr-12"
            onClick={handleLogoClick}
          >
            <img src="/public/icon.svg" alt="Logo" className="h-8 w-auto"/>
            <Title
              level={5}
              className="!m-0 ml-2"
              style={{color: token.colorTextHeading}}
            >
              Hireable
            </Title>
          </div>

          {/* Desktop Navigation */}
          <div className="hidden md:flex items-center space-x-4">
            <Dropdown
              menu={{items: menuItems.findTalent}}
              trigger={["hover"]}
            >
              <Button type="text" className="flex items-center">
                <Space>
                  Find Talent
                  <DownOutlined/>
                </Space>
              </Button>
            </Dropdown>

            <Dropdown menu={{items: menuItems.findWork}} trigger={["hover"]}>
              <Button type="text" className="flex items-center">
                <Space>
                  Find Work
                  <DownOutlined/>
                </Space>
              </Button>
            </Dropdown>
          </div>
        </div>

        {/* Desktop Search, Gamified Action and Auth */}
        <div className="hidden md:flex items-center space-x-4">
          <Input
            placeholder="Search..."
            prefix={<SearchOutlined className="text-gray-400"/>}
            value={searchTerm}
            onChange={(e) => handleSearch(e.target.value)}
            className="w-48 lg:w-64"
            style={{backgroundColor: token.colorBgContainer}}
          />

          {/* Gamified Open Box Button */}
          <Tooltip
            title={dailyBoxOpened ? "Come back tomorrow for another box!" : "Open your daily blind box for rewards!"}
            placement="bottom"
          >
            <Badge count={dailyBoxOpened ? 0 : 1} offset={[-5, 5]}>
              <Button
                type="default"
                icon={<GiftOutlined
                  style={{color: dailyBoxOpened ? token.colorTextSecondary : token.colorPrimary}}/>}
                onClick={handleOpenBox}
                className={`flex items-center ${!dailyBoxOpened && 'animate-pulse'}`}
                style={{
                  background: dailyBoxOpened ? token.colorBgContainer : 'linear-gradient(145deg, rgba(24, 144, 255, 0.1), rgba(220, 38, 38, 0.1))',
                  borderColor: dailyBoxOpened ? token.colorBorder : token.colorPrimary,
                }}
              >
                <Space>
                  Open It
                  {openedBoxCount > 0 &&
                    <span className="text-xs ml-1">({openedBoxCount})</span>}
                </Space>
              </Button>
            </Badge>
          </Tooltip>

          <Authenticated
            key={"authenticated-inner"}
            fallback={
              <Space size="middle">
                <Button
                  icon={<UserOutlined/>}
                  onClick={handleLogin}
                  className="flex items-center"
                >
                  Login
                </Button>
                <Button type="primary" onClick={handleSignup}>
                  Sign up
                </Button>
              </Space>
            }
          ></Authenticated>
        </div>

        {/* Mobile menu button */}
        <Button
          type="text"
          icon={mobileMenuOpen ? <CloseOutlined/> : <MenuOutlined/>}
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          className="md:hidden"
        />
      </div>

      {/* Mobile Drawer */}
      <Drawer
        placement="right"
        onClose={() => setMobileMenuOpen(false)}
        open={mobileMenuOpen}
        width={280}
        styles={{
          body: {
            padding: 0,
            backgroundColor: token.colorBgContainer,
          },
        }}
      >
        <div className="p-4 flex flex-col space-y-4">
          <Input
            placeholder="Search..."
            prefix={<SearchOutlined/>}
            value={searchTerm}
            onChange={(e) => handleSearch(e.target.value)}
            style={{backgroundColor: token.colorBgContainer}}
          />

          {/* Mobile Open Box Button */}
          <Button
            block
            icon={<GiftOutlined
              style={{color: dailyBoxOpened ? undefined : token.colorPrimary}}/>}
            onClick={handleOpenBox}
            className={`flex items-center justify-center ${!dailyBoxOpened && 'animate-pulse'}`}
            style={{
              background: dailyBoxOpened ? undefined : 'linear-gradient(145deg, rgba(24, 144, 255, 0.1), rgba(220, 38, 38, 0.1))',
              borderColor: dailyBoxOpened ? undefined : token.colorPrimary,
            }}
          >
            Open Daily Box {openedBoxCount > 0 && `(${openedBoxCount})`}
          </Button>

          <Dropdown menu={{items: menuItems.findTalent}} trigger={["click"]}>
            <Button type="text" className="w-full text-left">
              <Space>
                Find Talent
                <DownOutlined/>
              </Space>
            </Button>
          </Dropdown>

          <Dropdown menu={{items: menuItems.findWork}} trigger={["click"]}>
            <Button type="text" className="w-full text-left">
              <Space>
                Find Work
                <DownOutlined/>
              </Space>
            </Button>
          </Dropdown>

          <div
            className="pt-4 border-t"
            style={{borderColor: token.colorBorderSecondary}}
          >
            <Authenticated
              key={"authenticated-inner"}
              fallback={
                <div className="flex flex-col space-y-2">
                  <Button
                    icon={<UserOutlined/>}
                    onClick={handleLogin}
                    className="w-full"
                  >
                    Login
                  </Button>
                  <Button
                    type="primary"
                    onClick={handleSignup}
                    className="w-full"
                  >
                    Sign up
                  </Button>
                </div>
              }
            >
              {/* <ProfileDropdownButton /> */}
            </Authenticated>
          </div>
        </div>
      </Drawer>

      {/* Reward Modal */}
      <Modal
        open={isRewardModalOpen}
        onCancel={handleCloseRewardModal}
        footer={null}
        centered
        width={400}
        className="reward-modal"
        closeIcon={<CloseOutlined style={{color: token.colorTextSecondary}}/>}
      >
        {isBoxOpening ? (
          <div className="text-center py-12">
            <motion.div
              animate={{
                rotate: [0, 10, -10, 10, 0],
                scale: [1, 1.1, 1, 1.1, 1]
              }}
              transition={{repeat: Infinity, duration: 1}}
              className="text-6xl mx-auto mb-6"
            >
              <GiftOutlined style={{color: token.colorPrimary}}/>
            </motion.div>
            <Title level={3}>Opening your blind box...</Title>
            <Text className="text-lg">Get ready for a surprise!</Text>
          </div>
        ) : currentReward && (
          <div className="text-center py-12">
            <motion.div
              initial={{scale: 0, rotate: -180}}
              animate={{scale: 1, rotate: 0}}
              transition={{duration: 0.5, type: "spring"}}
              className="text-6xl mx-auto mb-6"
            >
              {currentReward.icon}
            </motion.div>
            <motion.div
              initial={{opacity: 0, y: 20}}
              animate={{opacity: 1, y: 0}}
              transition={{delay: 0.3}}
            >
              <Title level={3}
                     style={{color: getRewardColor(currentReward.rarity)}}>
                {currentReward.name}
              </Title>
              <Text className="text-lg block mb-6">
                You found a <span style={{
                color: getRewardColor(currentReward.rarity),
                fontWeight: 'bold'
              }}>{currentReward.rarity}</span> reward!
              </Text>
              <div className="flex justify-center mt-4">
                <Button type="primary" size="large"
                        onClick={handleCloseRewardModal}>
                  Claim Reward
                </Button>
              </div>
              <Text className="text-sm text-gray-400 mt-4 block">
                Blind boxes opened: {openedBoxCount}
              </Text>
            </motion.div>
          </div>
        )}
      </Modal>
    </Header>
  );
}
