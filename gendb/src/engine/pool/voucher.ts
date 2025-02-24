import {SqlFileAppender} from "../appender";
import {Voucher} from "../model/Voucher";

export class voucherPool {
    private vouchers: Voucher[] = [];
    private nextId: number = 1;

    add(voucher: Voucher) {
        this.vouchers.push(voucher);
    }

    pickUnusedVoucher(date: Date, accountId: number) : Voucher | null {
        const eligible = this.vouchers.filter(voucher => {
            const matchesDate = voucher.createdAt <= date;
            const isUsed = voucher.isUsed;
            const expired = voucher.expiredAt < date;
            const matchesAccountId = voucher.accountId === accountId;
            return matchesDate && !isUsed && !expired && matchesAccountId;
        });

        if (eligible.length === 0) return null;

        const randomIndex = Math.floor(Math.random() * eligible.length);
        return eligible[randomIndex];
    }

    getNextId(): number {
        return this.nextId++;
    }

    dump(): string {
        return '\n' + Voucher.dump(this.vouchers);
    }

    count(): number {
        return this.vouchers.length;
    }
}

export let VoucherPool = new voucherPool();
export const DumpVouchers = () => SqlFileAppender.append(VoucherPool.dump());
export const ResetVoucherPool = () => {
    VoucherPool = new voucherPool();
}
