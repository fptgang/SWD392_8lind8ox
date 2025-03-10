import {installDate, simulationActionWeights} from "../config.js"
import {createAccount} from "./action/createAccount";
import {createProduct, resetProductSeed} from "./action/createProduct";
import {launchCampaign} from "./action/launchCampaign";
import {depositCredits} from "./action/depositCredits";
import {checkout} from "./action/checkout.js";
import {startShipping} from "./action/startShipping";
import {completeShipping} from "./action/completeShipping";
import {uploadVideo} from "./action/uploadVideo";
import {verifyVideo} from "./action/verifyVideo";
import {createSet} from "./action/createSet";
import {completeOrderPrepare} from "./action/completeOrderPrepare";
import { confirmDelivery } from "./action/confirmDelivery.js";

const interval = [1000 * 60 * 30, 1000 * 60 * 60 * 3];

export const Simulate = (callbackProgress: (progress: number) => void): Map<string, number> => {
  let date = installDate();
  const actionCounts = new Map<string, number>();
  actionCounts.set('skip', 0);
  actionCounts.set('createAccount', 0);
  actionCounts.set('createProduct', 0);
  actionCounts.set('createSet', 0);
  actionCounts.set('launchCampaign', 0);
  actionCounts.set('depositCredits', 0);
  actionCounts.set('checkout', 0);
  actionCounts.set('startShipping', 0);
  actionCounts.set('completeShipping', 0);
  actionCounts.set('uploadVideo', 0);
  actionCounts.set('verifyVideo', 0);

  resetProductSeed();

  for (let i = 0; i < 20; i++) {
    createProduct(installDate())
  }

  while (date < new Date()) {
    const progress = (date.getTime() - installDate().getTime()) / (new Date().getTime() - installDate().getTime());
    callbackProgress(progress);

    const actions = [
      {
        action: () => {},
        name: 'skip',
        weight: simulationActionWeights().skip
      },
      {
        action: createAccount,
        name: 'createAccount',
        weight: simulationActionWeights().createAccount
      },
      {
        action: createProduct,
        name: 'createProduct',
        weight: simulationActionWeights().createProduct
      },
      {
        action: createSet,
        name: 'createSet',
        weight: simulationActionWeights().createProduct
      },
      {
        action: launchCampaign,
        name: 'launchCampaign',
        weight: simulationActionWeights().launchCampaign
      },
      {
        action: depositCredits,
        name: 'depositCredits',
        weight: simulationActionWeights().depositCredits
      },
      {
        action: checkout,
        name: 'checkout',
        weight: simulationActionWeights().checkout
      },
      {
        action: completeOrderPrepare,
        name: 'completeOrderPrepare',
        weight: simulationActionWeights().completeOrderPrepare
      },
      {
        action: startShipping,
        name: 'startShipping',
        weight: simulationActionWeights().startShipping
      },
      {
        action: completeShipping,
        name: 'completeShipping',
        weight: simulationActionWeights().completeShipping
      },
      {
        action: confirmDelivery,
        name: 'confirmDelivery',
        weight: simulationActionWeights().confirmDelivery
      },
      {
        action: uploadVideo,
        name: 'uploadVideo',
        weight: simulationActionWeights().uploadVideo
      },
      {
        action: verifyVideo,
        name: 'verifyVideo',
        weight: simulationActionWeights().verifyVideo
      },
    ];

    const totalWeight = actions.reduce((sum, a) => sum + a.weight, 0);
    let random = Math.random() * totalWeight;

    let selectedAction = actions[0];
    for (const action of actions) {
      random -= action.weight;
      if (random <= 0) {
        selectedAction = action;
        break;
      }
    }

    actionCounts.set(selectedAction.name, (actionCounts.get(selectedAction.name) || 0) + 1);
    selectedAction.action(date);

    date = new Date(date.getTime() + Math.floor(
      Math.random() * (interval[1] - interval[0] + 1) + interval[0]
    ));
  }

  return actionCounts;
}
