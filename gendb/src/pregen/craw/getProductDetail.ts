import { Browser } from "puppeteer";
import { setTimeout } from "node:timers/promises";
import * as fs from 'fs';

const filePath = (id: string) => `crawdata/product_detail_${id}.json`;

export async function getProductDetail(id: string, browser?: Browser): Promise<object> {
  // Return cached data if available or browser isn't provided
  if (!browser || fs.existsSync(filePath(id))) {
    return JSON.parse(fs.readFileSync(filePath(id), 'utf8'));
  }

  const out: any = { data: {} };
  const page = await browser.newPage();

  // Use Promises to track completion of each request
  const productDetailsPromise = new Promise<void>(resolve => {
    let detailsReceived = false;

    page.on('response', async response => {
      const url = response.url();
      if (!detailsReceived &&
        url.startsWith("https://prod-global-api.popmart.com/shop/v1/shop/productDetails") &&
        response.status() === 200) {
        try {
          const json = JSON.parse(await response.text());
          Object.assign(out, json);
          detailsReceived = true;
          resolve();
        } catch (error) {
          // Continue waiting if parsing fails
          console.error("Error parsing product details:", error);
        }
      }
    });
  });

  const spuTplPromise = new Promise<void>(resolve => {
    let tplReceived = false;

    page.on('response', async response => {
      const url = response.url();
      if (!tplReceived &&
        url.startsWith("https://prod-global-api.popmart.com/shop/v1/shop/getSpuTpl") &&
        response.status() === 200) {
        try {
          const json = JSON.parse(await response.text());
          const getUrls = (json: any): string[] => {
            return json?.data?.templates?.flatMap((template: any) =>
              template.elements?.flatMap((element: any) =>
                element.values?.map((value: any) => value.url) || []
              ) || []
            ) || [];
          };
          out.data.spuTplUrls = getUrls(json);
          tplReceived = true;
          resolve();
        } catch (error) {
          console.error("Error parsing SPU template:", error);
        }
      }
    });
  });

  const boxExtIdPromise = new Promise<void>(resolve => {
    let boxIdReceived = false;

    page.on('response', async response => {
      const url = response.url();
      if (!boxIdReceived &&
        url.startsWith("https://prod-global-api.popmart.com/shop/v1/shop/spuBoxCheck") &&
        response.status() === 200) {
        try {
          const json = JSON.parse(await response.text());
          if (json.data) {
            out.data.boxExtId = json.data.boxExtId;
          }
          boxIdReceived = true;
          resolve();
        } catch (error) {
          console.error("Error parsing box ext ID:", error);
        }
      }
    });
  });

  // Navigate to the page
  const url = `https://www.popmart.com/ca/products/${id}`;
  await page.goto(url, { waitUntil: 'networkidle2' });

  // Add timeout to avoid hanging indefinitely
  const timeoutPromise = setTimeout(30000).then(() => {
    throw new Error(`Timeout fetching product details for ID ${id}`);
  });

  try {
    // Wait for all data to be collected or timeout
    await Promise.race([
      Promise.all([productDetailsPromise, spuTplPromise, boxExtIdPromise]),
      timeoutPromise
    ]);

    // Save the data to file
    fs.writeFileSync(filePath(id), JSON.stringify(out), { encoding: 'utf8' });

    // Validate the result
    if (!out.hasOwnProperty("data")) {
      throw new Error(`Failed to fetch product data for ID ${id}`);
    }
  } finally {
    // Clean up
    await page.close();
  }

  return out;
}