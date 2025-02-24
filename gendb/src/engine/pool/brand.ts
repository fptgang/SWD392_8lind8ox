import {Brand} from "../model/Brand";
import {SqlFileAppender} from "../appender";

export class brandPool {
  private brands: Brand[] = [];

  add(brand: Brand) {
    this.brands.push(brand);
  }

  has(id: number): boolean {
    return this.brands.some(brand => brand.brand_id === id);
  }

  dump(): string {
    return '\n' + Brand.dump(this.brands);
  }

  count(): number {
    return this.brands.length;
  }
}

export let BrandPool = new brandPool();
export const DumpBrands = () => SqlFileAppender.append(BrandPool.dump());

export const ResetBrandPool = () => {
  BrandPool = new brandPool();
}
