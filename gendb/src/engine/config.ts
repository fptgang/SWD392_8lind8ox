// Private store for configuration values

const store = {
  installDate: new Date('2024-12-01T00:00:00'),
  hashPass: '$2a$10$a.andI/9BHw4zF3dm5wX1erg1BuJ2jwDksUGAYSxPGGIp6JM/AIZ.', // 1
  depositAmount: {
    min: 10,
    max: 1000
  },
  depositSuccessRate: 0.9,
  simulationActionWeights: {
    skip: 1000,
    createAccount: 120,
    createProduct: 30,
    createSet: 20,
    launchCampaign: 20,
    depositCredits: 20,
    checkout: 60,
    contactDeliveryPartner: 80,
    startShipping: 80,
    completeShipping: 40,
    confirmDelivery: 60,
    uploadVideo: 10,
    verifyVideo: 10
  } as const,
  skuStock: {
    min: 0,
    max: 1000
  },
  campaignScheduleBeforeDays: {
    min: 1,
    max: 7
  },
  campaignDurationDays: {
    min: 7,
    max: 14
  },
  campaignDiscountRate: {
    min: 0.05,
    max: 0.7
  },
  campaignDescriptionLines: {
    min: 1,
    max: 5
  },
  campaignMaxBlindBoxes: {
    min: 1,
    max: 5
  },
  normalProductBuyPerOrder: {
    min: 0,
    max: 3
  },
  normalProductBuyQuantity: {
    min: 1,
    max: 5
  },
  gachaSlotBuyPerOrder: {
    min: 0,
    max: 3
  },
  forceCreateShippingInfoChance: 0.3,
  cancelOrderRatio: 0.1,
  voucherDiscountRate: {
    min: 0.05,
    max: 0.2
  },
  voucherLimitAmount: {
    min: 100,
    max: 1000
  },
  voucherExpiredDays: {
    min: 7,
    max: 30
  }
};

// Exports that maintain references
export let installDate = () => store.installDate;
export let hashPass = () => store.hashPass;
export let depositAmount = () => store.depositAmount;
export let depositSuccessRate = () => store.depositSuccessRate;
export let simulationActionWeights = () => store.simulationActionWeights;
export let skuStock = () => store.skuStock;
export let campaignScheduleBeforeDays = () => store.campaignScheduleBeforeDays;
export let campaignDurationDays = () => store.campaignDurationDays;
export let campaignDiscountRate = () => store.campaignDiscountRate;
export let campaignDescriptionLines = () => store.campaignDescriptionLines;
export let campaignMaxBlindBoxes = () => store.campaignMaxBlindBoxes;
export let normalProductBuyPerOrder = () => store.normalProductBuyPerOrder;
export let normalProductBuyQuantity = () => store.normalProductBuyQuantity;
export let gachaSlotBuyPerOrder = () => store.gachaSlotBuyPerOrder;
export let forceCreateShippingInfoChance = () => store.forceCreateShippingInfoChance;
export let cancelOrderRatio = () => store.cancelOrderRatio;
export let voucherDiscountRate = () => store.voucherDiscountRate;
export let voucherLimitAmount = () => store.voucherLimitAmount;
export let voucherExpiredDays = () => store.voucherExpiredDays;

// Setters
export const setInstallDate = (value: typeof store.installDate) => {
  store.installDate = value;
};
export const setHashPass = (value: typeof store.hashPass) => {
  store.hashPass = value;
};
export const setDepositAmount = (value: typeof store.depositAmount) => {
  Object.assign(store.depositAmount, value);
};
export const setDepositSuccessRate = (value: typeof store.depositSuccessRate) => {
  store.depositSuccessRate = value;
};
export const setSimulationActionWeights = (value: typeof store.simulationActionWeights) => {
  Object.assign(store.simulationActionWeights, value);
};
export const setSkuStock = (value: typeof store.skuStock) => {
  Object.assign(store.skuStock, value);
};
export const setCampaignScheduleBeforeDays = (value: typeof store.campaignScheduleBeforeDays) => {
  Object.assign(store.campaignScheduleBeforeDays, value);
};
export const setCampaignDurationDays = (value: typeof store.campaignDurationDays) => {
  Object.assign(store.campaignDurationDays, value);
};
export const setCampaignDiscountRate = (value: typeof store.campaignDiscountRate) => {
  Object.assign(store.campaignDiscountRate, value);
}
export const setCampaignDescriptionLines = (value: typeof store.campaignDescriptionLines) => {
  Object.assign(store.campaignDescriptionLines, value);
}
export const setCampaignMaxBlindBoxes = (value: typeof store.campaignMaxBlindBoxes) => {
  Object.assign(store.campaignMaxBlindBoxes, value);
}
export const setNormalProductBuyPerOrder = (value: typeof store.normalProductBuyPerOrder) => {
  Object.assign(store.normalProductBuyPerOrder, value);
}
export const setNormalProductBuyQuantity = (value: typeof store.normalProductBuyQuantity) => {
  Object.assign(store.normalProductBuyQuantity, value);
}
export const setGachaSlotBuyPerOrder = (value: typeof store.gachaSlotBuyPerOrder) => {
  Object.assign(store.gachaSlotBuyPerOrder, value);
}
export const setForceCreateShippingInfoChance = (value: typeof store.forceCreateShippingInfoChance) => {
  Object.assign(store.forceCreateShippingInfoChance, value);
}
export const setCancelOrderRatio = (value: typeof store.cancelOrderRatio) => {
  Object.assign(store.cancelOrderRatio, value);
}
export const setVoucherDiscountRate = (value: typeof store.voucherDiscountRate) => {
  Object.assign(store.voucherDiscountRate, value);
}
export const setVoucherLimitAmount = (value: typeof store.voucherLimitAmount) => {
  Object.assign(store.voucherLimitAmount, value);
}
export const setVoucherExpiredDays = (value: typeof store.voucherExpiredDays) => {
  Object.assign(store.voucherExpiredDays, value);
}
