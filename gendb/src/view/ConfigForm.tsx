import React from 'react';
import {Col, Form, Row} from 'react-bootstrap';
import {Controller, useForm} from 'react-hook-form';
import * as config from '../engine/config';
import bcrypt from 'bcryptjs';

type ConfigFormType = {
  installDate: Date;
  hashPass: string;
  depositAmount: typeof config.depositAmount;
  depositSuccessRate: number;
  simulationActionWeights: typeof config.simulationActionWeights;
  skuStock: typeof config.skuStock;
  campaignScheduleBeforeDays: typeof config.campaignScheduleBeforeDays;
  campaignDurationDays: typeof config.campaignDurationDays;
  campaignDiscountRate: typeof config.campaignDiscountRate;
  campaignDescriptionLines: typeof config.campaignDescriptionLines;
  campaignMaxBlindBoxes: typeof config.campaignMaxBlindBoxes;
  normalProductBuyPerOrder: typeof config.normalProductBuyPerOrder;
  normalProductBuyQuantity: typeof config.normalProductBuyQuantity;
  gachaSlotBuyPerOrder: typeof config.gachaSlotBuyPerOrder;
  forceCreateShippingInfoChance: number;
  voucherDiscountRate: typeof config.voucherDiscountRate;
  voucherLimitAmount: typeof config.voucherLimitAmount;
  voucherExpiredDays: typeof config.voucherExpiredDays;
};

export const ConfigForm: React.FC = () => {
  const {control, setValue} = useForm<ConfigFormType>({
    defaultValues: {
      installDate: config.installDate(),
      hashPass: config.hashPass(),
      depositAmount: config.depositAmount(),
      depositSuccessRate: config.depositSuccessRate(),
      simulationActionWeights: config.simulationActionWeights(),
      skuStock: config.skuStock(),
      campaignScheduleBeforeDays: config.campaignScheduleBeforeDays(),
      campaignDurationDays: config.campaignDurationDays(),
      campaignDiscountRate: config.campaignDiscountRate(),
      campaignDescriptionLines: config.campaignDescriptionLines(),
      campaignMaxBlindBoxes: config.campaignMaxBlindBoxes(),
      normalProductBuyPerOrder: config.normalProductBuyPerOrder(),
      normalProductBuyQuantity: config.normalProductBuyQuantity(),
      gachaSlotBuyPerOrder: config.gachaSlotBuyPerOrder(),
      forceCreateShippingInfoChance: config.forceCreateShippingInfoChance(),
      voucherDiscountRate: config.voucherDiscountRate(),
      voucherLimitAmount: config.voucherLimitAmount(),
      voucherExpiredDays: config.voucherExpiredDays(),
    },
  });

  return (
    <Form className="p-3">
      <h3>[SWD392] Configuration Settings</h3>

      {/* Install Date */}
      <Form.Group className="mb-3">
        <Form.Label>Install Date</Form.Label>
        <Controller
          name="installDate"
          control={control}
          rules={{required: true}}
          render={({field}) => (
            <Form.Control
              type="datetime-local"
              {...field}
              onChange={(e) => {
                const newDate = new Date(e.target.value);
                field.onChange(newDate);
                console.log(newDate);
                config.setInstallDate(newDate);
              }}
              value={(() => {
                try {
                  return field.value.toISOString().slice(0, 16);
                } catch (e) {
                  return field.value; // Keep old value if error occurs
                }
              })()}
            />
          )}
        />
      </Form.Group>

      <hr className="my-4"/>

      {/* Pass */}
      <Form.Group className="mb-3">
        <Form.Label>Account Password</Form.Label>
        <Form.Control
          type="text"
          onChange={(e) => {
            const hash = bcrypt.hashSync(e.target.value);
            config.setHashPass(hash);
            setValue('hashPass', hash);
          }}
        />
      </Form.Group>

      {/* Hash Pass */}
      <Form.Group className="mb-3">
        <Form.Label>Hash Pass</Form.Label>
        <Controller
          name="hashPass"
          control={control}
          rules={{required: true, pattern: /^\$2a\$10\$.+/}}
          render={({field}) => (
            <Form.Control
              type="text"
              {...field}
              readOnly
            />
          )}
        />
      </Form.Group>

      <hr className="my-4"/>

      {/* Deposit Amount */}
      <Form.Group className="mb-3">
        <Form.Label>Deposit Amount Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="depositAmount.min"
              control={control}
              rules={{required: true, min: 0, max: 100000}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setDepositAmount({
                      ...config.depositAmount(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="depositAmount.max"
              control={control}
              rules={{required: true, min: 10}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setDepositAmount({
                      ...config.depositAmount(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      <hr className="my-4"/>

      {/* Deposit Success Rate */}
      <Form.Group className="mb-3">
        <Form.Label>Deposit Success Rate</Form.Label>
        <Controller
          name="depositSuccessRate"
          control={control}
          rules={{required: true, min: 0, max: 1}}
          render={({field}) => (
            <Form.Control
              type="number"
              step="0.1"
              {...field}
              onChange={(e) => {
                const value = Number(e.target.value);
                field.onChange(value);
                config.setDepositSuccessRate(value);
              }}
            />
          )}
        />
      </Form.Group>

      <hr className="my-4"/>

      {/* SKU Stock */}
      <Form.Group className="mb-3">
        <Form.Label>SKU Stock Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="skuStock.min"
              control={control}
              rules={{required: true, min: 0}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setSkuStock({
                      ...config.skuStock(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="skuStock.max"
              control={control}
              rules={{required: true, min: 0}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setSkuStock({
                      ...config.skuStock(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      <hr className="my-4"/>

      {/* Campaign Settings */}
      <h4>Campaign Settings</h4>

      {/* Campaign Schedule Before Days */}
      <Form.Group className="mb-3">
        <Form.Label>Schedule Before Days Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="campaignScheduleBeforeDays.min"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setCampaignScheduleBeforeDays({
                      ...config.campaignScheduleBeforeDays(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="campaignScheduleBeforeDays.max"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setCampaignScheduleBeforeDays({
                      ...config.campaignScheduleBeforeDays(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      {/* Campaign Duration Days */}
      <Form.Group className="mb-3">
        <Form.Label>Duration Days Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="campaignDurationDays.min"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setCampaignDurationDays({
                      ...config.campaignDurationDays(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="campaignDurationDays.max"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setCampaignDurationDays({
                      ...config.campaignDurationDays(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      {/* Campaign Discount Rate */}
      <Form.Group className="mb-3">
        <Form.Label>Discount Rate Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="campaignDiscountRate.min"
              control={control}
              rules={{required: true, min: 0, max: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  step="0.05"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setCampaignDiscountRate({
                      ...config.campaignDiscountRate(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="campaignDiscountRate.max"
              control={control}
              rules={{required: true, min: 0, max: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  step="0.05"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setCampaignDiscountRate({
                      ...config.campaignDiscountRate(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      {/* Campaign Description Lines */}
      <Form.Group className="mb-3">
        <Form.Label>Description Lines Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="campaignDescriptionLines.min"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setCampaignDescriptionLines({
                      ...config.campaignDescriptionLines(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="campaignDescriptionLines.max"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setCampaignDescriptionLines({
                      ...config.campaignDescriptionLines(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      {/* Campaign Max Blind Boxes */}
      <Form.Group className="mb-3">
        <Form.Label>Max Blind Boxes Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="campaignMaxBlindBoxes.min"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setCampaignMaxBlindBoxes({
                      ...config.campaignMaxBlindBoxes(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="campaignMaxBlindBoxes.max"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setCampaignMaxBlindBoxes({
                      ...config.campaignMaxBlindBoxes(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      <hr className="my-4"/>

      {/* Order Settings */}
      <h4>Order Settings</h4>

      {/* Normal Product Buy Per Order */}
      <Form.Group className="mb-3">
        <Form.Label>Normal Products Per Order Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="normalProductBuyPerOrder.min"
              control={control}
              rules={{required: true, min: 0}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setNormalProductBuyPerOrder({
                      ...config.normalProductBuyPerOrder(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="normalProductBuyPerOrder.max"
              control={control}
              rules={{required: true, min: 0}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setNormalProductBuyPerOrder({
                      ...config.normalProductBuyPerOrder(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      {/* Normal Product Buy Quantity */}
      <Form.Group className="mb-3">
        <Form.Label>Product Quantity Per Item Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="normalProductBuyQuantity.min"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setNormalProductBuyQuantity({
                      ...config.normalProductBuyQuantity(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="normalProductBuyQuantity.max"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setNormalProductBuyQuantity({
                      ...config.normalProductBuyQuantity(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      {/* Gacha Slot Buy Per Order */}
      <Form.Group className="mb-3">
        <Form.Label>Gacha Slots Per Order Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="gachaSlotBuyPerOrder.min"
              control={control}
              rules={{required: true, min: 0}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setGachaSlotBuyPerOrder({
                      ...config.gachaSlotBuyPerOrder(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="gachaSlotBuyPerOrder.max"
              control={control}
              rules={{required: true, min: 0}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setGachaSlotBuyPerOrder({
                      ...config.gachaSlotBuyPerOrder(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      <Form.Group className="mb-3">
        <Form.Label>Force Create Shipping Info Chance</Form.Label>
        <Controller
          name="forceCreateShippingInfoChance"
          control={control}
          rules={{required: true, min: 0, max: 1}}
          render={({field}) => (
            <Form.Control
              type="number"
              step="0.1"
              {...field}
              onChange={(e) => {
                const value = Number(e.target.value);
                field.onChange(value);
                config.setForceCreateShippingInfoChance(value);
              }}
            />
          )}
        />
      </Form.Group>

      <hr className="my-4"/>

      {/* Voucher Settings */}
      <h4>Voucher Settings</h4>

      {/* Voucher Discount Rate */}
      <Form.Group className="mb-3">
        <Form.Label>Voucher Discount Rate Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="voucherDiscountRate.min"
              control={control}
              rules={{required: true, min: 0, max: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  step="0.05"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setVoucherDiscountRate({
                      ...config.voucherDiscountRate(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="voucherDiscountRate.max"
              control={control}
              rules={{required: true, min: 0, max: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  step="0.05"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setVoucherDiscountRate({
                      ...config.voucherDiscountRate(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      {/* Voucher Limit Amount */}
      <Form.Group className="mb-3">
        <Form.Label>Voucher Limit Amount Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="voucherLimitAmount.min"
              control={control}
              rules={{required: true, min: 0}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setVoucherLimitAmount({
                      ...config.voucherLimitAmount(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="voucherLimitAmount.max"
              control={control}
              rules={{required: true, min: 0}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setVoucherLimitAmount({
                      ...config.voucherLimitAmount(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      {/* Voucher Expired Days */}
      <Form.Group className="mb-3">
        <Form.Label>Voucher Expired Days Range</Form.Label>
        <Row>
          <Col>
            <Controller
              name="voucherExpiredDays.min"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Min"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setVoucherExpiredDays({
                      ...config.voucherExpiredDays(),
                      min: value
                    });
                  }}
                />
              )}
            />
          </Col>
          <Col>
            <Controller
              name="voucherExpiredDays.max"
              control={control}
              rules={{required: true, min: 1}}
              render={({field}) => (
                <Form.Control
                  type="number"
                  placeholder="Max"
                  {...field}
                  onChange={(e) => {
                    const value = Number(e.target.value);
                    field.onChange(value);
                    config.setVoucherExpiredDays({
                      ...config.voucherExpiredDays(),
                      max: value
                    });
                  }}
                />
              )}
            />
          </Col>
        </Row>
      </Form.Group>

      <hr className="my-4"/>

      {/* Simulation Action Weights */}
      <Form.Group className="mb-3">
        <Form.Label>Simulation Action Weights</Form.Label>
        {Object.entries(config.simulationActionWeights()).map(([action, weight]) => (
          <Row key={action} className="mb-2">
            <Col xs={4}>
              <Form.Label>{action}</Form.Label>
            </Col>
            <Col>
              <Controller
                name={`simulationActionWeights.${action}`}
                control={control}
                rules={{required: true, min: 0}}
                render={({field}) => (
                  <Form.Control
                    type="number"
                    {...field}
                    onChange={(e) => {
                      field.onChange(Number(e.target.value));
                      (config.simulationActionWeights() as any)[action] = Number(e.target.value);
                    }}
                  />
                )}
              />
            </Col>
          </Row>
        ))}
      </Form.Group>
    </Form>
  );
};
