import {SqlFileAppender} from "../appender";
import {Notification} from "../model/Notification";

export class notificationPool {
  private noti: Notification[] = [];
  private nextId: number = 1;

  add(toy: Notification) {
    this.noti.push(toy);
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + Notification.dump(this.noti);
  }

  count(): number {
    return this.noti.length;
  }
}

export let NotificationPool = new notificationPool();
export const DumpNotifications = () => SqlFileAppender.append(NotificationPool.dump());
export const ResetNotificationPool = () => {
  NotificationPool = new notificationPool();
}
