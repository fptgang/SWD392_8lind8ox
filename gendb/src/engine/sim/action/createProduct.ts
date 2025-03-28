import {NM_Brand, NM_Product} from "../../../pregen/normalize/normalize";
import {shuffle} from "../../utils";
import {BrandPool} from "../../pool/brand";
import {Brand} from "../../model/Brand";
import {BlindBoxPool} from "../../pool/blindbox";
import {BlindBox} from "../../model/BlindBox";
import {ImagePool} from "../../pool/image";
import {Image} from "../../model/Image";
import {ToyPool} from "../../pool/toy";
import {Toy, ToyRarity} from "../../model/Toy";
import {faker} from "@faker-js/faker";
import {Sku} from "../../model/Sku";
import {SkuPool} from "../../pool/sku";
import {skuStock} from "../../config";

import normalizedData from "../../../../gendata/normalized-data.json";

const brandSeedPool = new Map<number, NM_Brand>();
const productSeedPool = [] as NM_Product[];

export function resetProductSeed() {
  brandSeedPool.clear()
  productSeedPool.length = 0

  const brands = normalizedData as {
    brands: NM_Brand[],
    products: NM_Product[]
  };

  for (let brand of brands.brands) {
    if (!brand.id) continue
    brandSeedPool.set(brand.id, brand);
  }

  for (let product of brands.products) {
    productSeedPool.push(product);
  }

  shuffle(productSeedPool);
}

export function createProduct(date: Date) {
  const product = productSeedPool.pop() as NM_Product;
  if (!product || !product.brandId) return;

  if (!BrandPool.has(product.brandId)) {
    const brand = brandSeedPool.get(product.brandId) as NM_Brand;
    BrandPool.add(new Brand(
      {
        brand_id: product.brandId,
        created_at: date,
        description: faker.lorem.paragraph(),
        is_visible: true,
        name: brand.name || 'Uncategorized',
        updated_at: date
      }
    ))
  }

  let desc = "";

  if (product.description?.images)
    desc += product.description.images.map(e => `<img src="${e}">`).join("<br/>")

  if (product.description?.notes)
    desc += "<br><br>" + product.description.notes

  const blindboxId = BlindBoxPool.getNextId();
  const blindbox = new BlindBox(
    {
      blind_box_id: blindboxId,
      brand_id: product.brandId,
      created_at: date,
      description: desc,
      is_visible: true,
      name: product.title,
      updated_at: date
    }
  )

  BlindBoxPool.add(blindbox)

  if (product.images) {
    for (let image of product.images) {
      ImagePool.add(new Image({
        blind_box_id: blindboxId,
        created_at: date,
        image_id: ImagePool.getNextId(),
        image_url: image,
        is_visible: true,
        toy_id: undefined,
        uploader_id: 1
      }))
    }
  }

  if (product.toys) {
    blindbox.toys = []

    for (let toy of product.toys) {
      const toyId = ToyPool.getNextId();
      const toyEntity = new Toy({
        blindBoxId: blindboxId,
        createdAt: date,
        description: faker.helpers.maybe(() => faker.lorem.paragraph(), {probability: 0.7}),
        isVisible: true,
        name: toy.name,
        rarity: toy.secret ? ToyRarity.SECRET : ToyRarity.REGULAR,
        toyId: toyId,
        updatedAt: date,
        weight: toy.weight
      })

      ToyPool.add(toyEntity)
      blindbox.toys.push(toyEntity)

      if(toy.image) {
        ImagePool.add(new Image({
          blind_box_id: undefined,
          created_at: date,
          image_id: ImagePool.getNextId(),
          image_url: toy.image,
          is_visible: true,
          toy_id: toyId,
          uploader_id: 1
        }))
      }
    }
  }

  if (product.sku) {
    for (let sku of product.sku) {
      const skuId = SkuPool.getNextId();
      let imageId: number | undefined = undefined

      if (sku.image) {
        imageId = ImagePool.getNextId();
        ImagePool.add(new Image({
          blind_box_id: undefined,
          created_at: date,
          image_id: imageId,
          image_url: sku.image,
          is_visible: true,
          toy_id: undefined,
          uploader_id: 1
        }))
      }

      SkuPool.add(new Sku({
        blindBoxId: blindboxId,
        blindBox: blindbox,
        createdAt: date,
        imageId: imageId,
        isVisible: true,
        name: sku.name,
        price: sku.price,
        skuId: skuId,
        specCount: sku.specCount,
        stock: faker.number.int(skuStock()),
        updatedAt: date
      }))
    }
  }


}