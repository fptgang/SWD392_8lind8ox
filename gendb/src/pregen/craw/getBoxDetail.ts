import { Browser } from "puppeteer";
import { setTimeout } from "node:timers/promises";
import * as fs from 'fs';

const filePath = (id: string) => `crawdata/box_detail_${id}.json`;

export async function getBoxDetail(id: string, browser?: Browser): Promise<object> {
    // Return cached data if available
    if (!browser || fs.existsSync(filePath(id))) {
        return JSON.parse(fs.readFileSync(filePath(id), 'utf8'));
    }

    const out = {
        extract: {},
        detail: {}
    };

    const page = await browser.newPage();

    // Create promises that will resolve when each API response is received
    const extractPromise = new Promise<void>(resolve => {
        let extractResolved = false;

        page.on('response', async response => {
            const url = response.url();
            if (url.startsWith("https://prod-global-api.popmart.com/shop/v1/box/box_set/extract") &&
              response.status() === 200 && !extractResolved) {
                try {
                    const json = await response.json();
                    Object.assign(out.extract, json);
                    extractResolved = true;
                    resolve();
                } catch (err) {
                    console.error("Error parsing extract response:", err);
                }
            }
        });
    });

    const detailPromise = new Promise<void>(resolve => {
        let detailResolved = false;

        page.on('response', async response => {
            const url = response.url();
            if (url.startsWith("https://prod-global-api.popmart.com/shop/v1/box/box_spu/detail") &&
              response.status() === 200 && !detailResolved) {
                try {
                    const json = await response.json();
                    Object.assign(out.detail, json);
                    detailResolved = true;
                    resolve();
                } catch (err) {
                    console.error("Error parsing detail response:", err);
                }
            }
        });
    });

    // Set a timeout promise to avoid hanging indefinitely
    const timeoutPromise = setTimeout(20000).then(() => {
        throw new Error(`Timeout waiting for API responses for box id ${id}`);
    });

    try {
        const url = `https://www.popmart.com/ca/pop-now/set/${id}`;
        await page.goto(url, { waitUntil: 'networkidle2' });

        // Wait for both API responses or timeout
        await Promise.race([
            Promise.all([extractPromise, detailPromise]),
            timeoutPromise
        ]);

        // Additional wait to ensure all data is processed
        await setTimeout(500);

        // Validate data before saving
        if (!out.extract.hasOwnProperty("data") || !out.detail.hasOwnProperty("data")) {
            throw new Error(`Failed to fetch complete data for box id ${id}`);
        }

        // Write the file only after all responses are processed
        fs.writeFileSync(filePath(id), JSON.stringify(out), { encoding: 'utf8' });

        return out;
    } finally {
        // Always close the page to avoid memory leaks
        await page.close();
    }
}