import React, { useState, useEffect } from "react";
import { useOne, useMany } from "@refinedev/core";
import { useParams, useNavigate } from "react-router";
import { SetDto, SlotDtoStateEnum, ToyDto } from "../../../../generated";
import {
  Card,
  Typography,
  Spin,
  Tag,
  Divider,
  Row,
  Col,
  Image,
  Space,
  Button,
  Descriptions,
  Alert,
  Tooltip,
  Statistic,
  Modal,
  message,
  Progress,
  Badge,
} from "antd";
import {
  ShoppingCartOutlined,
  HeartOutlined,
  ShareAltOutlined,
  InfoCircleOutlined,
  ClockCircleOutlined,
  BoxPlotOutlined,
  GiftOutlined,
  UnlockOutlined,
  LockOutlined,
  TrophyOutlined,
  StarFilled,
  ArrowLeftOutlined,
  DollarOutlined,
  LeftOutlined,
  RightOutlined,
  PlayCircleOutlined,
} from "@ant-design/icons";
import { motion, AnimatePresence } from "framer-motion";
import { useCart } from "../../../hooks/useCart";
import confetti from "canvas-confetti";

const { Title, Text } = Typography;

const SetDetailPage: React.FC = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const { data, isLoading, isError } = useOne<SetDto>({
    resource: "sets",
    id: id || "",
  });

  const [selectedSlot, setSelectedSlot] = useState<any>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [hoveredSlotId, setHoveredSlotId] = useState<number | null>(null);
  const [selectedToy, setSelectedToy] = useState<any>(null);
  const [isVideoProofModalOpen, setIsVideoProofModalOpen] = useState(false);
  const { addToCart } = useCart();

  // Sort slots by position (smallest to largest)
  const sortedSlots =
    data?.data?.slots?.sort((a, b) => (a.position || 0) - (b.position || 0)) ||
    [];

  // Get toy IDs to fetch related toys - The key issue is here!
  // We need to fetch the toys from the blindBox if they exist
  const blindBoxId = data?.data?.blindBox?.blindBoxId;

  // First attempt to get toys from slots if they have toys
  let toyIds = sortedSlots
    .filter((slot) => slot.toy?.toyId)
    .map((slot) => slot.toy?.toyId)
    .filter(Boolean) as number[];

  // If we don't have toys in slots, we'll fetch them directly using the blindBoxId
  const { data: blindBoxData, isLoading: blindBoxLoading } = useOne({
    resource: "blind-boxes",
    id: blindBoxId?.toString() || "",
    queryOptions: {
      enabled: blindBoxId !== undefined && toyIds.length === 0,
    },
  });

  // Once we have the blind box data, extract toy IDs if available
  useEffect(() => {
    if (
      blindBoxData?.data?.toys &&
      blindBoxData.data.toys.length > 0 &&
      toyIds.length === 0
    ) {
      toyIds = blindBoxData.data.toys
        .map((toy) => toy.toyId)
        .filter(Boolean) as number[];
    }
  }, [blindBoxData]);

  // For displaying toys, we'll use either the toys directly from the blind box if available,
  // or the related toys fetched via useMany
  const discoveredToys = sortedSlots
    .filter((slot) => slot.state === SlotDtoStateEnum.Opened && slot.toy)
    .map((slot) => slot.toy);
  const displayToys = discoveredToys;

  const handleSlotClick = (slot: any) => {
    setSelectedSlot(slot);
    setIsModalOpen(true);
  };

  const handleToyClick = (toy: any, slot: any) => {
    // Find the slot that contains this toy
    const toySlot = sortedSlots.find((s) => s.toy?.toyId === toy.toyId);

    if (toySlot && toySlot.video) {
      setSelectedToy({ ...toy, video: toySlot.video });
      setIsVideoProofModalOpen(true);
    } else {
      message.info("No video proof available for this toy");
    }
  };

  const triggerConfetti = () => {
    const duration = 3 * 1000;
    const animationEnd = Date.now() + duration;
    const defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 0 };

    function randomInRange(min: number, max: number) {
      return Math.random() * (max - min) + min;
    }

    const interval = setInterval(() => {
      const timeLeft = animationEnd - Date.now();

      if (timeLeft <= 0) {
        return clearInterval(interval);
      }

      const particleCount = 50 * (timeLeft / duration);

      // Generate confetti from different sides
      confetti({
        ...defaults,
        particleCount,
        origin: { x: randomInRange(0.1, 0.3), y: Math.random() - 0.2 },
      });
      confetti({
        ...defaults,
        particleCount,
        origin: { x: randomInRange(0.7, 0.9), y: Math.random() - 0.2 },
      });
    }, 250);
  };

  const handleAddToCart = () => {
    if (selectedSlot && data?.data?.sku) {
      // Launch confetti effect for gamification
      triggerConfetti();

      addToCart({
        skuId: data.data.sku.skuId || 0,
        name:
          data.data.blindBox?.name + " - Slot #" + selectedSlot.position || "",
        price: data.data.sku.price || 0,
        stock: data.data.sku.stock || 0,
        imageUrl: data.data.sku.image?.imageUrl || "",
        subTotal: data.data.sku.price || 0,
        finalTotal: data.data.sku.price || 0,
        slotId: selectedSlot.slotId,
        setId: data.data.setId,
      });

      message.success({
        content: "Added to cart successfully!",
        icon: <StarFilled className="text-yellow-400" />,
      });
      setIsModalOpen(false);
    }
  };

  const handleGoBack = () => {
    navigate(-1);
  };

  // Calculate available slots percentage
  const availableSlots = sortedSlots.filter(
    (slot) => slot.state === SlotDtoStateEnum.Available
  ).length;
  const totalSlots = sortedSlots.length;
  const availablePercentage =
    totalSlots > 0 ? (availableSlots / totalSlots) * 100 : 0;

  // If we're fetching blind box data specifically (after finding no toys in slots), show loading
  if (blindBoxLoading && toyIds.length === 0) {
    return (
      <div className="flex justify-center items-center min-h-[80vh]">
        <Spin size="large" />
        <div className="ml-3">Loading toys data...</div>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="flex justify-center items-center min-h-[80vh]">
        <Spin size="large" />
      </div>
    );
  }

  if (isError) {
    return (
      <div className="container mx-auto py-8 px-4">
        <Alert
          type="error"
          message="Error"
          description="Failed to load set details"
          className="mb-4"
        />
      </div>
    );
  }

  const set = data?.data;

  if (!set) {
    return (
      <div className="container mx-auto py-8 px-4">
        <Alert
          type="warning"
          message="Not Found"
          description="Set not found"
          className="mb-4"
        />
      </div>
    );
  }

  return (
    <div className="container mx-auto py-4 px-4">
      {/* Back Button */}
      <motion.div
        className="mb-4"
        initial={{ opacity: 0, x: -20 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.3 }}
      >
        <Button
          icon={<ArrowLeftOutlined />}
          onClick={handleGoBack}
          size="large"
        >
          Back to Sets
        </Button>
      </motion.div>

      {/* Top Section - Product Name and Price */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4 }}
        className="mb-6"
      >
        <Card className="shadow-md">
          <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
              <Title level={2} className="mb-2">
                {set.sku?.name}
              </Title>
              <Space size="small" wrap>
                <Tag color={set.isVisible ? "success" : "error"}>
                  {set.isVisible ? "Available" : "Unavailable"}
                </Tag>
                {set.blindBox?.brand && (
                  <Tag color="blue">{set.blindBox.brand.name}</Tag>
                )}
              </Space>
            </div>
            <div className="flex items-center">
              <Statistic
                value={set.sku?.price || 0}
                prefix={<DollarOutlined />}
                precision={2}
                valueStyle={{ color: "#1890ff", fontSize: "2rem" }}
              />
              <motion.div
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                className="ml-4"
              >
                <Button
                  type="primary"
                  icon={<ShoppingCartOutlined />}
                  size="large"
                >
                  Add Set to Cart
                </Button>
              </motion.div>
            </div>
          </div>
        </Card>
      </motion.div>

      {/* Mystery Boxes Carousel - Full Width */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        style={{ minHeight: "45vh" }}
      >
        <Card
          title={
            <div className="flex items-center">
              <GiftOutlined className="mr-2 text-purple-500" />
              <span className="text-xl">Mystery Boxes</span>
              <Text type="secondary" className="ml-2">
                (Click to reveal!)
              </Text>
              <div className="ml-auto">
                <Progress
                  percent={availablePercentage}
                  status={
                    availablePercentage > 50
                      ? "active"
                      : availablePercentage > 0
                      ? "normal"
                      : "exception"
                  }
                  format={() => `${availableSlots}/${totalSlots} Available`}
                  className="w-48"
                />
              </div>
            </div>
          }
          className="shadow-md"
        >
          {/* Carousel container with horizontal scroll */}
          <div className="relative">
            {/* Left/Right scroll indicators */}
            <div className="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-black bg-opacity-30 rounded-r-md p-1 hidden md:block">
              <LeftOutlined className="text-white text-xl" />
            </div>
            <div className="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-black bg-opacity-30 rounded-l-md p-1 hidden md:block">
              <RightOutlined className="text-white text-xl" />
            </div>

            {/* Scrollable container */}
            <div
              className="flex overflow-x-auto py-4 px-2 scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100"
              style={{ minWidth: "100%", scrollbarWidth: "thin" }}
            >
              {sortedSlots.map((slot, index) => (
                <div
                  key={slot.slotId}
                  className="flex-shrink-0 px-2"
                  style={{
                    minWidth: "200px",
                    width: "calc(100% / 6)",
                    maxWidth: "180px",
                  }}
                >
                  <motion.div
                    whileHover={{
                      y: [0, -15, 0],
                      transition: {
                        y: { repeat: Infinity, duration: 0.6 },
                      },
                    }}
                    onHoverStart={() => setHoveredSlotId(slot.slotId || 0)}
                    onHoverEnd={() => setHoveredSlotId(null)}
                    onClick={() =>
                      slot.state === SlotDtoStateEnum.Available &&
                      handleSlotClick(slot)
                    }
                    className="h-full"
                  >
                    <Badge count={index + 1} offset={[-5, 5]}>
                      <Card
                        hoverable={slot.state === SlotDtoStateEnum.Available}
                        size="default"
                        className={`
                    relative overflow-hidden shadow-md h-full
                    ${
                      slot.state === SlotDtoStateEnum.Available
                        ? "cursor-pointer"
                        : "opacity-70"
                    }
                    ${
                      hoveredSlotId === slot.slotId ? "ring-2 ring-primary" : ""
                    }
                  `}
                        style={{ height: 140, width: 100 }}
                      >
                        <div className="absolute inset-0 flex items-center justify-center">
                          {slot.state === SlotDtoStateEnum.Available ? (
                            <motion.div
                              animate={{ rotate: [0, 5, 0, -5, 0] }}
                              transition={{
                                repeat:
                                  hoveredSlotId === slot.slotId ? Infinity : 0,
                                duration: 0.5,
                              }}
                            >
                              <Image
                                src={
                                  set.sku?.image?.imageUrl ||
                                  "https://via.placeholder.com/100x100?text=?"
                                }
                                alt={`Slot ${index + 1}`}
                                preview={false}
                                style={{
                                  maxHeight: 90,
                                  maxWidth: "100%",
                                  objectFit: "contain",
                                }}
                              />
                            </motion.div>
                          ) : slot.toy ? (
                            <Tooltip title="Click to see proof" placement="top">
                              <div
                                className="relative w-full h-full flex items-center justify-center cursor-pointer"
                                onClick={(e) => {
                                  e.stopPropagation();
                                  handleToyClick(slot.toy, slot);
                                }}
                              >
                                {slot.toy.images &&
                                slot.toy.images.length > 0 ? (
                                  <Image
                                    src={
                                      slot.toy.images[0]?.imageUrl ||
                                      "https://via.placeholder.com/100x100?text=Toy"
                                    }
                                    alt={slot.toy.name || `Toy ${index + 1}`}
                                    preview={false}
                                    style={{
                                      maxHeight: 90,
                                      maxWidth: "100%",
                                      objectFit: "contain",
                                    }}
                                  />
                                ) : (
                                  <div className="flex items-center justify-center h-full">
                                    <Tag color="purple">
                                      {slot.toy.name || `Toy ${index + 1}`}
                                    </Tag>
                                  </div>
                                )}
                                {slot.video && (
                                  <div className="absolute inset-0 flex items-center justify-center bg-black bg-opacity-30 opacity-0 hover:opacity-100 transition-opacity duration-200">
                                    <PlayCircleOutlined className="text-white text-2xl" />
                                  </div>
                                )}
                              </div>
                            </Tooltip>
                          ) : (
                            <Image
                              src={
                                set.sku?.image?.imageUrl ||
                                "https://via.placeholder.com/100x100?text=?"
                              }
                              alt={`Slot ${index + 1}`}
                              preview={false}
                              style={{
                                maxHeight: 90,
                                maxWidth: "100%",
                                objectFit: "contain",
                                opacity: 0.5,
                              }}
                            />
                          )}
                        </div>

                        <div className="absolute bottom-0 left-0 right-0 flex justify-center py-1 text-xs bg-black bg-opacity-60 text-white">
                          {slot.state === SlotDtoStateEnum.Available ? (
                            <>
                              <UnlockOutlined className="mr-1" /> Available
                            </>
                          ) : (
                            <>
                              <LockOutlined className="mr-1" /> Opened
                            </>
                          )}
                        </div>
                      </Card>
                    </Badge>
                  </motion.div>
                </div>
              ))}
            </div>
          </div>
        </Card>
      </motion.div>

      {/* Discovered Toys Section */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, delay: 0.2 }}
        className="mb-6"
        style={{ minHeight: "45vh" }}
      >
        <Card
          title={
            <div className="flex items-center">
              <TrophyOutlined className="mr-2 text-yellow-500" />
              <span className="text-xl">Discovered Toys</span>
            </div>
          }
          className="shadow-md"
        >
          {false ? (
            <div className="py-16 text-center">
              <Spin size="large" />
              <div className="mt-4 text-gray-500">Loading toys...</div>
            </div>
          ) : displayToys.length > 0 ? (
            <Row gutter={[24, 24]} className="p-4">
              {displayToys.map((toy) => {
                // Find the slot that contains this toy to check for video proof
                const toySlot = sortedSlots.find(
                  (s) => s.toy?.toyId === toy.toyId
                );
                const hasVideoProof = Boolean(toySlot?.video?.url);

                return (
                  <Col key={toy.toyId} xs={12} sm={8} md={6} lg={4}>
                    <Tooltip
                      title={
                        hasVideoProof
                          ? "Click to see proof"
                          : "No video proof available"
                      }
                    >
                      <motion.div
                        whileHover={{ scale: 1.05, y: -5 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() =>
                          hasVideoProof && handleToyClick(toy, toySlot)
                        }
                      >
                        <Card
                          hoverable={hasVideoProof}
                          className={`shadow-sm h-full ${
                            hasVideoProof ? "cursor-pointer" : ""
                          }`}
                          cover={
                            <div className="p-4 text-center h-40 flex items-center justify-center bg-gray-50 relative">
                              {toy.images && toy.images.length > 0 ? (
                                <Image
                                  src={
                                    toy.images[0]?.imageUrl ||
                                    "https://via.placeholder.com/150x150?text=Toy"
                                  }
                                  alt={toy.name || "Toy"}
                                  preview={false}
                                  style={{
                                    maxHeight: 120,
                                    maxWidth: "100%",
                                    objectFit: "contain",
                                  }}
                                />
                              ) : (
                                <GiftOutlined
                                  style={{ fontSize: 48 }}
                                  className="text-gray-300"
                                />
                              )}
                              {hasVideoProof && (
                                <div className="absolute top-2 right-2">
                                  <PlayCircleOutlined className="text-primary text-xl" />
                                </div>
                              )}
                            </div>
                          }
                        >
                          <Card.Meta
                            title={
                              <div className="truncate text-center">
                                {toy.name || "Mystery Toy"}
                              </div>
                            }
                            description={
                              <div className="text-center">
                                <Tag
                                  color={
                                    toy.rarity === "SECRET" ? "gold" : "blue"
                                  }
                                  className="mt-2"
                                >
                                  {toy.rarity || "REGULAR"}
                                </Tag>
                              </div>
                            }
                          />
                        </Card>
                      </motion.div>
                    </Tooltip>
                  </Col>
                );
              })}
            </Row>
          ) : (
            <div className="py-16 text-center">
              <GiftOutlined
                style={{ fontSize: 48 }}
                className="text-gray-300 mb-4"
              />
              <Title level={4} className="text-gray-500">
                No toys discovered yet
              </Title>
              <Text type="secondary">
                Start opening mystery boxes to discover toys!
              </Text>
            </div>
          )}
        </Card>
      </motion.div>

      {/* Product Details */}
      <Row gutter={[24, 24]}>
        {/* Left Column - Image and Actions */}
        <Col xs={24} md={10}>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.3 }}
          >
            <Card className="mb-6 shadow-md overflow-hidden">
              <Image
                src={
                  set.sku?.image?.imageUrl ||
                  "https://via.placeholder.com/600x400?text=No+Image"
                }
                alt={set.sku?.name}
                className="w-full rounded-lg"
                preview={false}
              />
            </Card>
          </motion.div>
        </Col>

        {/* Right Column - Details */}
        <Col xs={24} md={14}>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.3 }}
          >
            <Card className="mb-6 shadow-md">
              <Space direction="vertical" size="large" className="w-full">
                {/* Details */}
                <Descriptions title="Product Details" column={1} bordered>
                  <Descriptions.Item
                    label={
                      <>
                        <BoxPlotOutlined /> SKU ID
                      </>
                    }
                  >
                    {set.sku?.skuId}
                  </Descriptions.Item>
                  <Descriptions.Item
                    label={
                      <>
                        <InfoCircleOutlined /> Description
                      </>
                    }
                  >
                    {set.sku?.name || "No description available"}
                  </Descriptions.Item>
                  <Descriptions.Item
                    label={
                      <>
                        <GiftOutlined /> Total Slots
                      </>
                    }
                  >
                    {set.slots?.length || 0} slots available
                  </Descriptions.Item>
                  <Descriptions.Item
                    label={
                      <>
                        <ClockCircleOutlined /> Created
                      </>
                    }
                  >
                    {new Date(set.createdAt || "").toLocaleDateString()}
                  </Descriptions.Item>
                </Descriptions>
              </Space>
            </Card>
          </motion.div>

          {/* Brand Information */}
          {set.blindBox?.brand && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.4 }}
            >
              <Card
                title={
                  <span>
                    <TrophyOutlined className="mr-2 text-yellow-500" />
                    Brand Information
                  </span>
                }
                className="shadow-md"
              >
                <Descriptions column={1}>
                  <Descriptions.Item label="Brand Name">
                    {set.blindBox.brand.name}
                  </Descriptions.Item>
                  <Descriptions.Item label="Description">
                    {set.blindBox.brand.description ||
                      "No description available"}
                  </Descriptions.Item>
                </Descriptions>
              </Card>
            </motion.div>
          )}
        </Col>
      </Row>

      {/* Slot Selection Modal */}
      <Modal
        title={
          <div className="flex items-center">
            <GiftOutlined className="mr-2 text-purple-500 text-xl" />
            <span>Add Mystery Box to Cart</span>
          </div>
        }
        open={isModalOpen}
        onCancel={() => setIsModalOpen(false)}
        footer={[
          <Button key="cancel" onClick={() => setIsModalOpen(false)}>
            Cancel
          </Button>,
          <motion.div
            key="add"
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            <Button
              type="primary"
              onClick={handleAddToCart}
              icon={<ShoppingCartOutlined />}
            >
              Add to Cart
            </Button>
          </motion.div>,
        ]}
        width={500}
        centered
      >
        <div className="py-4">
          {selectedSlot && (
            <Row gutter={[16, 16]} align="middle">
              <Col span={12} className="text-center">
                <motion.div
                  initial={{ scale: 0 }}
                  animate={{ scale: 1, rotate: [0, 10, 0, -10, 0] }}
                  transition={{ duration: 0.5 }}
                >
                  <Image
                    src={
                      set.sku?.image?.imageUrl ||
                      "https://via.placeholder.com/200x200?text=?"
                    }
                    alt={set.sku?.name || "Mystery Box"}
                    preview={false}
                    className="mb-4"
                    style={{
                      maxHeight: 180,
                      maxWidth: "100%",
                      objectFit: "contain",
                    }}
                  />
                </motion.div>
              </Col>
              <Col span={12}>
                <Descriptions
                  title="Selected Box"
                  column={1}
                  size="small"
                  bordered
                >
                  <Descriptions.Item label="Position">
                    Box #{selectedSlot.position || "?"}
                  </Descriptions.Item>
                  <Descriptions.Item label="Product">
                    {set.sku?.name || "Mystery Box"}
                  </Descriptions.Item>
                  <Descriptions.Item label="Price">
                    ${set.sku?.price?.toFixed(2) || "0.00"}
                  </Descriptions.Item>
                  <Descriptions.Item label="Status">
                    <Tag color="green">Available</Tag>
                  </Descriptions.Item>
                </Descriptions>
              </Col>
              <Col span={24}>
                <Alert
                  message="Surprise Inside!"
                  description="Each box contains a mystery toy. What will you discover?"
                  type="info"
                  showIcon
                />
              </Col>
            </Row>
          )}
        </div>
      </Modal>

      {/* Video Proof Modal */}
      <Modal
        title={
          <div className="flex items-center">
            <PlayCircleOutlined className="mr-2 text-blue-500 text-xl" />
            <span>Video Proof - {selectedToy?.name}</span>
          </div>
        }
        open={isVideoProofModalOpen}
        onCancel={() => setIsVideoProofModalOpen(false)}
        footer={[
          <Button
            key="close"
            type="primary"
            onClick={() => setIsVideoProofModalOpen(false)}
          >
            Close
          </Button>,
        ]}
        width={800}
        centered
      >
        {selectedToy && (
          <div className="py-4">
            <Row gutter={[16, 16]}>
              <Col xs={24} md={8}>
                <div className="text-center">
                  {selectedToy.images && selectedToy.images.length > 0 ? (
                    <Image
                      src={
                        selectedToy.images[0]?.imageUrl ||
                        "https://via.placeholder.com/150x150?text=Toy"
                      }
                      alt={selectedToy.name || "Toy"}
                      preview={false}
                      style={{
                        maxHeight: 200,
                        maxWidth: "100%",
                        objectFit: "contain",
                      }}
                    />
                  ) : (
                    <div
                      className="bg-gray-100 flex items-center justify-center"
                      style={{ height: 200 }}
                    >
                      <GiftOutlined
                        style={{ fontSize: 48 }}
                        className="text-gray-300"
                      />
                    </div>
                  )}
                  <div className="mt-3">
                    <Title level={5}>{selectedToy.name}</Title>
                    <Tag
                      color={selectedToy.rarity === "SECRET" ? "gold" : "blue"}
                    >
                      {selectedToy.rarity || "REGULAR"}
                    </Tag>
                  </div>
                </div>
              </Col>
              <Col xs={24} md={16}>
                <div className="bg-gray-100 p-2 rounded-md">
                  <div className="relative" style={{ paddingTop: "56.25%" }}>
                    {" "}
                    {/* 16:9 aspect ratio */}
                    {selectedToy.video?.url ? (
                      <video
                        title={`Proof video for ${selectedToy.name}`}
                        className="absolute inset-0 w-full h-full rounded-md"
                        controls
                        autoPlay
                      >
                        <source src={selectedToy.video.url} type="video/mp4" />
                      </video>
                    ) : (
                      <div className="absolute inset-0 flex items-center justify-center bg-gray-200 rounded-md">
                        <Text type="secondary">No video available</Text>
                      </div>
                    )}
                  </div>
                  <div className="mt-3">
                    <Descriptions column={1} size="small">
                      <Descriptions.Item label="Video dimensions">
                        {selectedToy.video?.width || "Unknown"} x{" "}
                        {selectedToy.video?.height || "Unknown"}
                      </Descriptions.Item>
                      <Descriptions.Item label="Recorded date">
                        {selectedToy.video?.createdAt
                          ? new Date(
                              selectedToy.video.createdAt
                            ).toLocaleString()
                          : "Unknown"}
                      </Descriptions.Item>
                    </Descriptions>
                  </div>
                </div>
              </Col>
              <Col span={24}>
                <Alert
                  message="Authenticity Verification"
                  description="This video serves as proof of the toy discovery process, ensuring transparency and fairness."
                  type="info"
                  showIcon
                />
              </Col>
            </Row>
          </div>
        )}
      </Modal>
    </div>
  );
};

export default SetDetailPage;
