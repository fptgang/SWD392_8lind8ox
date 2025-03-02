import {escapeSingleQuotes} from "../utils.js";

export class Notification {
    notification_id: number;
    created_at: Date | null;
    is_read: boolean;
    message: string;
    updated_at: Date | null;
    account_id: number;

    constructor(data: Partial<Notification>) {
        this.notification_id = data.notification_id || 0;
        this.created_at = data.created_at || null;
        this.is_read = data.is_read || false;
        this.message = data.message || '';
        this.updated_at = data.updated_at || null;
        this.account_id = data.account_id || 0;
    }

    static dump(notifications: Notification[]): string {
        if (notifications.length === 0) return '';

        const values = notifications.map(notification => {
            const created = notification.created_at ? 
                `'${notification.created_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'` : 'NULL';
            const updated = notification.updated_at ? 
                `'${notification.updated_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'` : 'NULL';
            
            return `(${notification.notification_id},` +
                   `${created},` +
                   `${notification.is_read ? 1 : 0},` +
                   `'${escapeSingleQuotes(notification.message)}',` +
                   `${updated},` +
                   `${notification.account_id})`;
        }).join(',\n');

        return `INSERT INTO \`notification\` ` +
               `(\`notification_id\`, \`created_at\`, \`is_read\`, \`message\`, \`updated_at\`, \`account_id\`) ` +
               `VALUES\n${values};`;
    }
}