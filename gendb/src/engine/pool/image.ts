import {Image} from "../model/Image";
import {SqlFileAppender} from "../appender";

export class imagePool {
  private images: Image[] = [];
  private nextId: number = 1;

  add(slot: Image) {
    this.images.push(slot);
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + Image.dump(this.images);
  }

  count(): number {
    return this.images.length;
  }
}

export let ImagePool = new imagePool();
export const DumpImages = () => SqlFileAppender.append(ImagePool.dump());

export const ResetImagePool = () => {
  ImagePool = new imagePool();
}
