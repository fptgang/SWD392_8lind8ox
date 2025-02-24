import {SqlFileAppender} from "../appender";
import {Video} from "../model/Video";

export class videoPool {
    private videos: Video[] = [];
    private nextId: number = 1;

    add(video: Video) {
        this.videos.push(video);
    }

    pickAllUnverified(date: Date): Video[] {
        return this.videos.filter(video => !video.isVerified && video.createdAt <= date);
    }

    getNextId(): number {
        return this.nextId++;
    }

    dump(): string {
        return '\n' + Video.dump(this.videos);
    }

    count(): number {
        return this.videos.length;
    }
}

export let VideoPool = new videoPool();
export const DumpVideos = () => SqlFileAppender.append(VideoPool.dump());
export const ResetVideoPool = () => {
    VideoPool = new videoPool();
}