import { Browser } from "puppeteer";
import { setTimeout } from "node:timers/promises";
import * as fs from 'fs';

const filePath = 'crawdata/all_product_ids.json';

export async function getAllProductIds(browser?: Browser): Promise<{
    secret: string[], // PopNOW only
    normal: string[] // normal + might be PopNOW
}> {
    if (!browser || fs.existsSync(filePath)) {
        return JSON.parse(fs.readFileSync(filePath, 'utf8'));
    }

    const out = {
        secret: [] as string[],
        normal: [] as string[]
    };

    const page = await browser.newPage();

    // Create a promise-based response handler
    const responsePromises: Promise<void>[] = [];

    page.on('response', async response => {
        const url = response.url() as string;
        if (url.startsWith("https://prod-global-api.popmart.com/shop/v3/shop/productOnCollection") && response.status() == 200) {
            // Create a promise for this response and add it to our tracking array
            const responsePromise = (async () => {
                try {
                    const text = await response.text();
                    const json = JSON.parse(text);
                    const productData = json.data.productData;

                    for (let i = 0; i < productData.length; i++) {
                        const product = productData[i];
                        if (product.type === 'secret')
                            out.secret.push(product.spuExtID);
                        else
                            out.normal.push(product.id);
                    }

                    console.log(`Found ${productData.length} products; Total secrets = ${out.secret.length}, normals = ${out.normal.length}`);
                } catch (error) {
                    console.error("Error processing response:", error);
                }
            })();

            responsePromises.push(responsePromise);
        }
    });

    try {
        // Navigate through all pages
        for (let i = 1; i <= 11; i++) {
            const url = `https://www.popmart.com/ca/collection/10?page=${i}&sortWay=1&collectionId=10`;
            await page.goto(url, { waitUntil: 'networkidle2' });
            await setTimeout(3000);

            // Wait for all pending response promises to resolve before continuing
            await Promise.all(responsePromises.splice(0, responsePromises.length));

            // Save the current state (intermediate checkpoint)
            fs.writeFileSync(filePath, JSON.stringify(out), { encoding: 'utf8' });
        }

        // Final wait for any remaining response promises
        await Promise.all(responsePromises);
    } finally {
        await page.close();
    }

    // Final write
    fs.writeFileSync(filePath, JSON.stringify(out), { encoding: 'utf8' });
    return out;
}