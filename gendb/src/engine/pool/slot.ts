import {Slot} from "../model/Slot";
import {SqlFileAppender} from "../appender";
import {shuffle} from "../utils";

export class slotPool {
  private slots: Slot[] = [];
  private nextId: number = 1;

  add(slot: Slot) {
    this.slots.push(slot);
  }

  pickMultiEmptySlots(date: Date, limit: number): Slot[] {
    const eligible = this.slots.filter(slot => {
      const matchesDate = slot.createdAt <= date;
      const isVisible = slot.isVisible;
      const isOpened = slot.isOpened;
      return matchesDate && isVisible && !isOpened;
    });
    shuffle(eligible);

    if (eligible.length <= limit) return eligible;
    return eligible.slice(0, limit);
  }

  pickAllOpenedInBlindbox(blindBoxId: number): Slot[] {
    return this.slots.filter(slot => slot.isOpened && slot.set?.blind_box_id === blindBoxId);
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + Slot.dump(this.slots);
  }

  count(): number {
    return this.slots.length;
  }
}


export let SlotPool = new slotPool();
export const DumpSlots = () => SqlFileAppender.append(SlotPool.dump());
export const ResetSlotPool = () => {
  SlotPool = new slotPool();
}
