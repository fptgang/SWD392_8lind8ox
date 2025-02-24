import { getAllProductIds } from "./getAllProductIds";
import { getBoxDetail } from "./getBoxDetail";
import { getProductDetail } from "./getProductDetail";
import * as fs from 'fs';
import puppeteer from "puppeteer";

export async function craw() {
if (!fs.existsSync("crawdata")) {
  fs.mkdirSync("crawdata", { recursive: true });
  console.log('Directory created successfully!');
} else {
  console.log('Directory already exists.');
}

console.log('Starting browser')
const browser = await puppeteer.launch({ headless: true });

console.log("Getting product ids")
const productIds = await getAllProductIds(browser);

console.log("Getting product details")
let totalProductSupportPopNow = 0;

for (let i = 0; i < productIds.normal.length; i++) {
  const id = productIds.normal[i];
  console.log(`Getting normal product details id=${id} ${i+1}/${productIds.normal.length} (${Math.round((i+1)/productIds.normal.length*100)}%)`)
  const detail = (await getProductDetail(id, browser)) as any;
  if (detail.data?.boxExtId && detail.data?.boxExtId > 0) {
    console.log(`> Getting box details id=${detail.data.boxExtId}`)
    await getBoxDetail(detail.data.boxExtId, browser);
    totalProductSupportPopNow++;
  }
}

for (let i = 0; i < productIds.secret.length; i++) {
  const id = productIds.secret[i];
  console.log(`Getting secret product details id=${id} ${i+1}/${productIds.secret.length} (${Math.round((i+1)/productIds.secret.length*100)}%)`)
  await getBoxDetail(id, browser);
  totalProductSupportPopNow++;
}

// Summarize:
console.log("==== Product stats ====")
console.log(`- Total products: ${productIds.normal.length + productIds.secret.length}`)
console.log(`- Normal products: ${productIds.normal.length}`)
console.log(`- Secret/PopNow-[only] products: ${productIds.secret.length}`)
console.log(`- PopNow-supported products: ${totalProductSupportPopNow}`)

console.log('Closing browser')
await browser.close();

}