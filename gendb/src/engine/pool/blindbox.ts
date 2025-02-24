import {BlindBox} from "../model/BlindBox";
import {SqlFileAppender} from "../appender";
import {shuffle} from "../utils";

export class blindBoxPool {
  private blindBoxes: BlindBox[] = [];
  private nextId: number = 1;

  add(blindBox: BlindBox) {
    this.blindBoxes.push(blindBox);
  }

  pickBlindBox(date: Date): BlindBox | null {
    const eligible = this.blindBoxes.filter(blindBox => {
      const matchesDate = blindBox.created_at <= date;
      const isVisible = blindBox.is_visible;
      return matchesDate && isVisible;
    });

    if (eligible.length === 0) return null;

    const randomIndex = Math.floor(Math.random() * eligible.length);
    return eligible[randomIndex];
  }

  pickMultiBlindBox(date: Date, limit: number): BlindBox[] {
    const eligible = this.blindBoxes.filter(blindBox => {
      const matchesDate = blindBox.created_at <= date;
      const isVisible = blindBox.is_visible;
      return matchesDate && isVisible;
    });
    shuffle(eligible);

    if (eligible.length <= limit) return eligible;
    return eligible.slice(0, limit);
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + BlindBox.dump(this.blindBoxes);
  }

  count(): number {
    return this.blindBoxes.length;
  }
}

export let BlindBoxPool = new blindBoxPool();
export const DumpBlindBoxes = () => SqlFileAppender.append(BlindBoxPool.dump());

export const ResetBlindBoxPool = () => {
  BlindBoxPool = new blindBoxPool();
}
