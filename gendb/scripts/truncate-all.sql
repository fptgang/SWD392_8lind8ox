use blindbox;

SET @@foreign_key_checks = 0;

truncate table `account`;

truncate table `blind_box`;

truncate table `blind_box_campaign`;

truncate table `brand`;

truncate table `image`;

truncate table `notification`;

truncate table `order`;

truncate table `order_details`;

truncate table `order_status_history`;

truncate table `promotional_campaign`;

truncate table `refresh_token`;

truncate table `sets`;

truncate table `shipping_info`;

truncate table `sku`;

truncate table `slots`;

truncate table `toy`;

truncate table `transaction`;

truncate table `videos`;

truncate table `voucher`;

SET @@foreign_key_checks = 1;
