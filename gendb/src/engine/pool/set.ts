import {SqlFileAppender} from "../appender";
import {Set} from "../model/Set";

export class setPool {
    private sets: Set[] = [];
    private nextId: number = 1;

    add(set: Set) {
        this.sets.push(set);
    }

    getNextId(): number {
        return this.nextId++;
    }

    dump(): string {
        return '\n' + Set.dump(this.sets);
    }

    count(): number {
      return this.sets.length;
    }
}

export let SetPool = new setPool();
export const DumpSets = () => SqlFileAppender.append(SetPool.dump());
export const ResetSetPool = () => {
    SetPool = new setPool();
}
