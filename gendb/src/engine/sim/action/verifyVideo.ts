import {faker} from "@faker-js/faker";
import {Voucher, VoucherState} from "../../model/Voucher";
import {VideoPool} from "../../pool/video";
import {VoucherPool} from "../../pool/voucher";
import {
    voucherDiscountRate,
    voucherExpiredDays,
    voucherLimitAmount
} from "../../config";
import {ToyPool} from "../../pool/toy";
import {SlotPool} from "../../pool/slot";

function roundUpToNearestFiveCents(num: number): number {
    // Validate input is between 0.0 and 1.0
    if (num < 0.0 || num > 1.0) {
        throw new Error('Number must be between 0.0 and 1.0');
    }

    // Calculate the number of 0.05 increments
    const increments = Math.ceil(num / 0.05);

    // Calculate the rounded up value
    const roundedValue = increments * 0.05;

    // Ensure we don't exceed 1.0
    return Math.min(roundedValue, 1.0);
}

export function verifyVideo(date: Date) {
    const videos = VideoPool.pickAllUnverified(date);

    for (const video of videos) {
        video.isVerified = true;
        video.updatedAt = date;

        VoucherPool.add(new Voucher({
            voucherId: VideoPool.getNextId(),
            code: faker.string.alphanumeric(10),
            createdAt: date,
            updatedAt: date,
            discountRate: roundUpToNearestFiveCents(faker.number.float(voucherDiscountRate())),
            expiredAt: new Date(date.getTime() + 1000 * 60 * 60 * 24 * faker.number.int(voucherExpiredDays())),
            state: VoucherState.AVAILABLE,
            limitAmount: faker.number.int(voucherLimitAmount()),
            accountId: video.accountId || 0,
            orderId: null
        }));

        if (!video.slot?.set?.blind_box_id) {
            continue;
        }

        const toys = ToyPool.pickAllInBlindbox(video.slot.set.blind_box_id);
        const openedToys = SlotPool.pickAllOpenedInBlindbox(video.slot.set.blind_box_id).map(slot => slot.toyId);
        const toy = toys.find(toy => !openedToys.includes(toy.toyId));

        if (!toy) {
            continue;
        }

        video.slot.toyId = toy.toyId;
    }
}