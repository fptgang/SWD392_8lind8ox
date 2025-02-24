import React, {useEffect, useState} from 'react';
import {Col, Container, Row, Spinner} from 'react-bootstrap';
import {ConfigForm} from './ConfigForm';
import {SqlFileAppender} from "../engine/appender.js";
import {Simulate} from "../engine/sim/index.js";
import toast from 'react-hot-toast';
import {BrandPool, DumpBrands, ResetBrandPool} from "../engine/pool/brand";
import {BlindBoxPool, DumpBlindBoxes, ResetBlindBoxPool} from "../engine/pool/blindbox";
import {DumpImages, ImagePool, ResetImagePool} from "../engine/pool/image";
import {DumpSkus, ResetSkuPool, SkuPool} from "../engine/pool/sku";
import {DumpSlots, ResetSlotPool, SlotPool} from "../engine/pool/slot";
import {DumpToys, ResetToyPool, ToyPool} from "../engine/pool/toy";
import {DumpNotifications, NotificationPool, ResetNotificationPool} from "../engine/pool/notification";
import {DumpCampaigns, PromotionalCampaignPool, ResetPromotionalCampaignPool} from "../engine/pool/campaign";
import {BlindBoxCampaignPool, DumpBlindBoxCampaigns, ResetBlindBoxCampaignPool} from "../engine/pool/blindbox_campaign";
import {DumpOrders, OrderPool, ResetOrderPool} from "../engine/pool/order";
import {DumpOrderDetails, OrderDetailPool, ResetOrderDetailPool} from "../engine/pool/order_detail";
import {DumpOrderStatusHistories, OrderStatusHistoryPool, ResetOrderStatusHistoryPool} from "../engine/pool/order_status_history";
import {DumpSets, ResetSetPool, SetPool} from "../engine/pool/set";
import {DumpShippingInfos, ResetShippingInfoPool, ShippingInfoPool} from "../engine/pool/shipping_info";
import {DumpVideos, ResetVideoPool, VideoPool} from "../engine/pool/video";
import {DumpVouchers, ResetVoucherPool, VoucherPool} from "../engine/pool/voucher";
import { AccountPool, DumpAccounts, ResetAccountPool } from '../engine/pool/account.js';
import { DumpTransactions, ResetTransactionPool, TransactionPool } from '../engine/pool/transaction.js';

const Home: React.FC = () => {
  const [code, setCode] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [generateTime, setGenerateTime] = useState<number | null>(null);
  const [progress, setProgress] = useState<number>(0);
  const [count, setCount] = useState<Map<string, number>>(new Map());
  const [actionCounts, setActionCounts] = useState<Map<string, number>>(new Map());

  useEffect(() => {

    SqlFileAppender.setInMemoryMode(true);

  }, []);

  return (
    <Container className="py-5">
      <Row>
        <Col md={6}>
          <ConfigForm/>
        </Col>
        <Col md={6}>
          <div>
            <h4>How to use?</h4>
            <p>
              <ul>
                <li>1. Click the "Generate" button.</li>
                <li>2. Download SQL file</li>
                <li>3. In IntelliJ, select the database</li>
                <li>4. Click SQL Scripts -&gt; Run SQL Script</li>
              </ul>
            </p>
          </div>
          <div className="mb-3 d-flex gap-3">
            <button
              className="btn btn-primary me-2"
              disabled={isLoading}
              onClick={() => {
                setIsLoading(true);
                setProgress(0);

                async function generate() {
                  await new Promise(resolve => setTimeout(resolve, 1000));
                  const startTime = performance.now();

                  ResetAccountPool(new Date());
                  ResetBlindBoxCampaignPool();
                  ResetBlindBoxPool();
                  ResetBrandPool();
                  ResetPromotionalCampaignPool();
                  ResetImagePool();
                  ResetNotificationPool();
                  ResetOrderDetailPool();
                  ResetOrderStatusHistoryPool();
                  ResetOrderPool();
                  ResetSetPool();
                  ResetShippingInfoPool();
                  ResetSkuPool();
                  ResetSlotPool();
                  ResetToyPool();
                  ResetTransactionPool();
                  ResetVideoPool();
                  ResetVoucherPool();

                  SqlFileAppender.prepare();
                  setActionCounts(Simulate(function (progress: number) {
                    setProgress(progress);
                  }));

                  DumpAccounts();
                  DumpBlindBoxCampaigns();
                  DumpBlindBoxes();
                  DumpBrands();
                  DumpCampaigns();
                  DumpImages();
                  DumpNotifications();
                  DumpOrderDetails();
                  DumpOrderStatusHistories();
                  DumpOrders();
                  DumpSets();
                  DumpShippingInfos();
                  DumpSkus();
                  DumpSlots();
                  DumpToys();
                  DumpTransactions();
                  DumpVideos();
                  DumpVouchers();

                  setCount(new Map([
                    ['account', AccountPool.count()],
                    ['blindBoxCampaign', BlindBoxCampaignPool.count()],
                    ['blindBox', BlindBoxPool.count()],
                    ['brand', BrandPool.count()],
                    ['promotionalCampaign', PromotionalCampaignPool.count()],
                    ['image', ImagePool.count()],
                    ['notification', NotificationPool.count()],
                    ['orderDetail', OrderDetailPool.count()],
                    ['orderStatusHistory', OrderStatusHistoryPool.count()],
                    ['order', OrderPool.count()],
                    ['set', SetPool.count()],
                    ['shippingInfo', ShippingInfoPool.count()],
                    ['sku', SkuPool.count()],
                    ['slot', SlotPool.count()],
                    ['toy', ToyPool.count()],
                    ['transaction', TransactionPool.count()],
                    ['video', VideoPool.count()],
                    ['voucher', VoucherPool.count()],
                  ]));

                  const endTime = performance.now();
                  setGenerateTime(endTime - startTime);
                  setCode(SqlFileAppender.getBuffer().join('\n'));
                  setIsLoading(false);
                }

                generate();
              }}
            >
              Generate
            </button>
            <button
              className="btn btn-secondary"
              disabled={!code}
              onClick={() => {
                const blob = new Blob([code], {type: 'text/plain'});
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = 'generated.sql';
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);
                toast.success('Downloaded SQL!');
              }}
            >
              Download SQL
            </button>
            <button
              className="btn btn-secondary"
              onClick={() => {
                navigator.clipboard.writeText(code);
                toast.success('Copied to clipboard!');
              }}
            >
              Copy SQL
            </button>
          </div>

          <div className="progress mb-2">
            <div
              className="progress-bar"
              role="progressbar"
              style={{width: `${progress * 100}%`}}
              aria-valuenow={progress * 100}
              aria-valuemin={0}
              aria-valuemax={100}
            >
              {(progress * 100).toFixed(0)}%
            </div>
          </div>
          {generateTime && (
            <span className="ms-2">
              Generation time: {generateTime.toFixed(2)}ms
            </span>
          )}
          {isLoading ? (
            <div className="text-center">
              <Spinner animation="border" role="status">
                <span className="visually-hidden">Loading...</span>
              </Spinner>
            </div>
          ) : (
            <>
            <div className="mb-3 d-flex gap-3">
            {
              actionCounts.size > 0 && 
              <table className="table table-striped table-sm mt-3">
              <thead>
                <tr>
                  <th>Action</th>
                  <th>Count</th>
                </tr>
              </thead>
              <tbody>
                {Array.from(actionCounts.entries()).map(([table, count]) => (
                  <tr key={table}>
                    <td>{table}</td>
                    <td>{count}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            }
            {
              count.size > 0 && 
              <table className="table table-striped table-sm mt-3">
              <thead>
                <tr>
                  <th>Table</th>
                  <th>Count</th>
                </tr>
              </thead>
              <tbody>
                {Array.from(count.entries()).map(([table, count]) => (
                  <tr key={table}>
                    <td>{table}</td>
                    <td>{count}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            }
            </div>

            <pre style={{maxHeight: '600px', overflow: 'auto'}}>
              <code className="language-sql">
                {code}
              </code>
            </pre>
            </>
          )}
        </Col>
      </Row>
    </Container>
  );
};

export default Home;