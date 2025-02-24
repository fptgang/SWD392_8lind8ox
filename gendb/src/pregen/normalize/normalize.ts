



/*------------------

       create brand data
       normal product without PopNow --> blindbox, 2 sku, image
       normal product with PopNow --> blindbox, 2 sku, set, slot, toy, image
       secret product ---> blindbox, 2 sku, set, slot, toy, image

*/

import {getAllProductIds} from "../craw/getAllProductIds";
import {getProductDetail} from "../craw/getProductDetail";
import * as fs from 'fs';
import {getBoxDetail} from "../craw/getBoxDetail";

const filePath = 'gendata/normalized-data.json';
const fixSpecCountFilePath = 'gendata/fix-spec-count.json';

export class NM_Toy {
  name: string | undefined
  secret: boolean | undefined
  image: string | undefined
  weight: number | undefined
}

export class NM_Sku {
  name: string | undefined
  price: number | undefined
  specCount: number | undefined
  image: string | undefined
}

export class NM_Product {
  brandId: number | undefined
  title: string | undefined
  description: {
    images: string[],
    notes: string
  } | undefined
  images: string[] | undefined
  sku: NM_Sku[] | undefined
  toys: NM_Toy[] | undefined
}

export class NM_Brand {
  id: number | undefined
  name: string | undefined
  description: string | undefined
}


const specCountFixMap = {} as any

(function (){
  if (fs.existsSync(fixSpecCountFilePath)) {
    Object.assign(specCountFixMap, JSON.parse(fs.readFileSync(fixSpecCountFilePath, 'utf8')));
  }
})()

const brandLookup = new Map<number, NM_Brand>();
const products = [] as NM_Product[];

async function normalizeNormalProduct(productId: string) {
  let data;
  try {
    data = ((await getProductDetail(productId, undefined)) as any).data;
  } catch (e) {
    return
  }

  let specCounts = new Set<number>();
  let brand = brandLookup.get(data.brand.id)
  if (!brand) {
    brand = {
      id: brandLookup.size + 1,
      name: data.brand.name,
      description: ""
    }
    brandLookup.set(data.brand.id, brand);
  }

  const product: NM_Product = {
    brandId: brand.id,
    description: {
      images: data.spuTplUrls,
      notes: data.desc
    },
    images: data.banners.flatMap((banner: any) => banner.values.map((val: any) => val.url)),
    sku: data.skus.map((e: any) => {
      let specCount = e.specCount;
      if (specCountFixMap.hasOwnProperty(data.id) && specCountFixMap[data.id].hasOwnProperty(e.id)) {
        specCount = specCountFixMap[data.id][e.id];
        console.log("fix spec count ", e.specCount, " into ", specCount, " in ", data.title, data.id);
      }
      if (specCounts.has(specCount)) {
        console.log("warn: duplicated spec count ", specCount, " in ", data.title, data.id);
      }
      specCounts.add(specCount)
      return {
        name: e.title.replaceAll('\t', ""),
        image: e.mainImage,
        price: e.price,
        specCount: specCount
      } as NM_Sku
    }),
    title: data.title,
    toys: []
  };

  if (data?.boxExtId && data?.boxExtId > 0) {
    const box = (await getBoxDetail(data.boxExtId, undefined)) as any;
    await normalizeToys(product, box)
  }

  products.push(product);
}

export async function normalizeSecretProduct(boxId: string) {
  let brand = brandLookup.get(0)
  if (!brand) {
    brand = {
      id: brandLookup.size + 1,
      name: "Unknown",
      description: ""
    }
    brandLookup.set(0, brand);
  }

  const box = (await getBoxDetail(boxId, undefined)) as any;
  const extract = box.extract.data;
  const detail = box.detail.data;
  const product: NM_Product = {
    brandId: brand.id,
    description: {
      images: detail.desc_images,
      notes: detail.desc
    },
    images: [],
    sku: [
      {
        name: "Single box",
        image: extract.box_pic,
        price: detail.price,
        specCount: 1
      } as NM_Sku,
      {
        name: "Whole set",
        image: extract.box_pic,
        price: detail.price * extract.count,
        specCount: extract.count
      } as NM_Sku
    ],
    title: detail.name,
    toys: []
  };

  products.push(product);

  await normalizeToys(product, box)
}

export async function normalizeToys(product: NM_Product, box: any) {
  const detail = box.detail.data;
  product.toys = detail.toy_list.map((toy: any) => {
    return {
      image: toy.pic,
      name: toy.name,
      secret: toy.type === 2,
      weight: toy.weight
    } as NM_Toy
  })
}

export async function normalize() {
  if (!fs.existsSync("gendata")) {
    fs.mkdirSync("gendata", { recursive: true });
    console.log('Directory created successfully!');
  } else {
    console.log('Directory already exists.');
  }

  const productIds = await getAllProductIds(undefined);

  for (let productId of productIds.normal) {
    await normalizeNormalProduct(productId)
  }

  for (let productId of productIds.secret) {
    await normalizeSecretProduct(productId)
  }

  fs.writeFileSync(filePath, JSON.stringify({
    brands: Array.from(brandLookup.values()),
    products: products
  }), { encoding: 'utf8' });

  console.log(`Created ${brandLookup.size} brands, ${products.length} products`)
}
