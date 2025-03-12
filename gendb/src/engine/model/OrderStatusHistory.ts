export enum OrderState {
    CREATED = "CREATED", // Order created, in payment

    PREPARING = "PREPARING", // Paid success, staff is preparing
    PAYMENT_FAILED = "PAYMENT_FAILED", // Failed to pay
    PAYMENT_EXPIRED = "PAYMENT_EXPIRED", // Not paid in time
    CANCELED = "CANCELED", // Customer canceled before paid

    READY_FOR_PICKUP = "READY_FOR_PICKUP", // Staff has done package, waiting for courier to pickup
    SHIPPING = "SHIPPING", // Courier is shipping
    DELIVERED = "DELIVERED", // Courier delivered
    RECEIVED = "RECEIVED", // Customer confirmed received
    COMPLETED = "COMPLETED", // The order completed without issues
}

export class OrderStatusHistory {
    id: number;
    createdAt: Date;
    state: OrderState;
    orderId: number;

    constructor(init?: Partial<OrderStatusHistory>) {
        this.id = init?.id ?? 0;
        this.createdAt = init?.createdAt ?? new Date();
        this.state = init?.state ?? OrderState.CREATED;
        this.orderId = init?.orderId ?? 0;
    }

    static dump(records: OrderStatusHistory[]): string {
        if (records.length === 0) return '';

        const header = 'INSERT INTO `order_status_history` (`id`, `created_at`, `state`, `order_id`) VALUES\n';
        
        const values = records.map(record => {
            const createdAtStr = record.createdAt.toISOString().slice(0, 19).replace('T', ' ');
            return `(${record.id}, '${createdAtStr}.000000', '${record.state}', ${record.orderId})`;
        }).join(',\n');

        return header + values + ';';
    }
}