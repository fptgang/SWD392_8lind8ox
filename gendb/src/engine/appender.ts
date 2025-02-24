import * as fs from 'fs';

const TRUNCATE_SQL = `
start transaction;

use blindbox;

set @@foreign_key_checks = 0;

truncate table \`account\`;

truncate table \`blind_box\`;

truncate table \`blind_box_campaign\`;

truncate table \`brand\`;

truncate table \`image\`;

truncate table \`notification\`;

truncate table \`order\`;

truncate table \`order_details\`;

truncate table \`order_status_history\`;

truncate table \`promotional_campaign\`;

truncate table \`refresh_token\`;

truncate table \`sets\`;

truncate table \`shipping_info\`;

truncate table \`sku\`;

truncate table \`slots\`;

truncate table \`toy\`;

truncate table \`transaction\`;

truncate table \`videos\`;

truncate table \`voucher\`;`;


class sqlFileAppender {
  private buffer: string[] = TRUNCATE_SQL.split('\n');
  private readonly filePath: string = 'dump.sql';
  private readonly bufferSize: number = 1000;
  private inMemoryMode: boolean = false;

  public setInMemoryMode(enabled: boolean): void {
    this.inMemoryMode = enabled;
  }

  public append(line: string): void {
    this.buffer.push(line);

    if (!this.inMemoryMode && this.buffer.length >= this.bufferSize) {
      this.flush();
    }
  }

  public prepare(): void {
    if (this.inMemoryMode) {
      this.buffer = TRUNCATE_SQL.split('\n');
      return;
    }

    if (fs.existsSync(this.filePath)) {
      fs.unlinkSync(this.filePath);
    }
  }

  public flush(): void {
    if (this.inMemoryMode || this.buffer.length === 0) {
      return;
    }

    fs.appendFileSync(this.filePath, this.buffer.join('\n') + '\n', {encoding: 'utf8'});
    this.buffer = [];
  }

  public getBuffer(): string[] {
    return [...this.buffer, '\nset @@foreign_key_checks = 1;  \ncommit;'] ;
  }
}

export const SqlFileAppender = new sqlFileAppender();