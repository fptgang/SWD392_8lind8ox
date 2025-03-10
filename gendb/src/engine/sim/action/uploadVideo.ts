
import {faker} from "@faker-js/faker";

import { OrderState } from "../../model/OrderStatusHistory";
import { Video } from "../../model/Video";
import { OrderPool } from "../../pool/order";
import { OrderStatusHistoryPool } from "../../pool/order_status_history";
import { VideoPool } from "../../pool/video";

const videoURLs = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4"
];

export function uploadVideo(date: Date) {
    const orderIds = OrderStatusHistoryPool.pickAllOrderWithLatestState(date, OrderState.RECEIVED);

    for (const orderId of orderIds) {
        const order = OrderPool.getById(orderId);

        if (!order) {
            continue;
        }
        
        for (const detail of order.details || []) {
            if (!detail.slot || detail.slot.videoId) {
                continue;
            }

            const video = new Video({
                videoId: VideoPool.getNextId(),
                description: `Video for order #${orderId}`,
                isVerified: false,
                isVisible: true,
                createdAt: date,
                updatedAt: date,
                url: faker.helpers.arrayElement(videoURLs),
                accountId: order.account_id,
                slot: detail.slot
            });

            VideoPool.add(video);
            detail.slot.videoId = video.videoId;
        }
    }
}