import {Toy} from "../model/Toy";
import {SqlFileAppender} from "../appender";

export class toyPool {
  private toys: Toy[] = [];
  private nextId: number = 1;

  add(toy: Toy) {
    this.toys.push(toy);
  }

  pickAllInBlindbox(blindBoxId: number): Toy[] {
    return this.toys.filter(toy => toy.blindBoxId === blindBoxId);
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + Toy.dump(this.toys);
  }

  count(): number {
    return this.toys.length;
  }
}

export let ToyPool = new toyPool();
export const DumpToys = () => SqlFileAppender.append(ToyPool.dump());
export const ResetToyPool = () => {
  ToyPool = new toyPool();
}
