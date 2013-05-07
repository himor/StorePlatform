CREATE TABLE IF NOT EXISTS `user` (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
type INT,
fname VARCHAR(50),
lname VARCHAR(50),
username VARCHAR(50),
name VARCHAR(50),
email VARCHAR(50),
password VARCHAR(50),
isDeleted BOOL DEFAULT 0,
registered TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

#INSERT INTO `user` (`type`,`fname`,`lname`,`name`,`username`,`password`,`email`) VALUES (1, 'John', 'Smith', '', 'BUYER','d91decd10f780b58cd0948d3a1ae2982','mgordo@albany.edu');
#INSERT INTO `user` (`type`,`fname`,`lname`,`name`,`username`,`password`,`email`) VALUES (2, 'James', 'Brown', 'Mega Store', 'SELLER','104db6c4998ba1663908d5e31d1b282a','mgordo@albany.edu');

CREATE TABLE IF NOT EXISTS `item` (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR (100),
`type` VARCHAR(50),
description VARCHAR(500),
sellerId BIGINT NOT NULL,
price NUMERIC(7,2), # 7 significant digits, 2 decimal digits
picture VARCHAR(60),
isDeleted BOOL DEFAULT 0,
`count` INT,
created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(sellerId) REFERENCES user(id)
);

CREATE TABLE IF NOT EXISTS `message` (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
`from` BIGINT,
`to` BIGINT,
subject VARCHAR(255),
`text` TEXT,
isDeleted BOOL DEFAULT 0,
`read` BOOL DEFAULT 0,
created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
showToRec BOOL DEFAULT 1,
showToSen BOOL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS `order` (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
sellerId BIGINT NOT NULL,
customerId BIGINT NOT NULL,
addressD VARCHAR(500),
addressB VARCHAR(500),
total NUMERIC(7,2), 
created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(sellerId) REFERENCES user(id),
FOREIGN KEY(customerId) REFERENCES user(id)
);

CREATE TABLE IF NOT EXISTS `status` (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
orderId BIGINT,
`type` INT,
description VARCHAR(255),
created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(orderId) REFERENCES `order`(id)
);

CREATE TABLE IF NOT EXISTS `orderItem` (
orderId BIGINT,
itemId BIGINT,
`count` INT,
FOREIGN KEY(orderId) REFERENCES `order`(id),
FOREIGN KEY(itemId) REFERENCES item(id)
);

CREATE TABLE IF NOT EXISTS `review` (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
customerId BIGINT NOT NULL,
sellerId BIGINT NOT NULL,
itemId BIGINT NOT NULL,
`text` TEXT,
star INT,
isDeleted BOOL DEFAULT 0,
created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(customerId) REFERENCES user(id),
FOREIGN KEY(sellerId) REFERENCES user(id),
FOREIGN KEY(itemId) REFERENCES item(id)
);

CREATE TABLE IF NOT EXISTS `notification` (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
userId BIGINT,
status INT,
pointer INT, # to some item, or user or whatever
`read` BOOL DEFAULT 0,
created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# data

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

INSERT INTO `user` (`id`, `type`, `fname`, `lname`, `username`, `name`, `email`, `password`, `isDeleted`, `registered`) VALUES
(1, 1, 'John', 'Smith', 'BUYER', '', 'mgordo@albany.edu', 'd91decd10f780b58cd0948d3a1ae2982', 0, '2013-04-12 01:46:59'),
(2, 2, 'James', 'Brown', 'SELLER', 'Mega Store', 'mgordo@albany.edu', '104db6c4998ba1663908d5e31d1b282a', 0, '2013-04-12 01:46:59'),
(3, 2, 'Jonny', 'Shoemaker', 'SELLER2', 'Shoes and stuff', 'himor.cre@gmail.com', '104db6c4998ba1663908d5e31d1b282a', 0, '2013-04-12 02:05:52'),
(4, 2, 'Tony', 'Bookseller', 'SELLER3', 'Books and more', 'mgordo@live.com', '104db6c4998ba1663908d5e31d1b282a', 0, '2013-04-12 02:12:03');

INSERT INTO `item` (`id`, `name`, `type`, `description`, `sellerId`, `price`, `picture`, `isDeleted`, `count`, `created`) VALUES
(1, 'Proctor Silex K2070Y', 'Kettle', '1000-watt electric kettle rapidly boils up to 1 Liter of water.\r\nDetachable cord and nonspill spout for graceful serving.\r\nImmersed heating element; automatic shut off; boil-dry protection.\r\nDual water-level indicators; easy-open lid with security lock for safety.\r\nMeasures approximately 9-1/6 by 5 by 7-1/3 inches; 180-day limited warranty.\r\n', 2, '14.11', 'upload/41QQJ8FM5TL.jpg1365731390538.jpg', 0, 3, '2013-04-12 01:49:50'),
(2, 'Hamilton Beach 1.7L Stainless Steel', 'Kettle', 'Faster than a microwave, safer than a stovetop kettle\r\nCord-free serving\r\nAuto shutoff with boil-dry protection\r\nConcealed heating element\r\nDrip-free spout', 2, '32.61', 'upload/71L3Xh49KjL._SL1500_.jpg1365731503619.jpg', 0, 5, '2013-04-12 01:51:43'),
(3, 'Medelco 12-Cup Glass Stovetop Whistling Kettle', 'Kettle', '12-cup whistling kettle made of thermal-shock-resistant borosilicate glass\r\nRemovable lid; heat-resistant phenolic handle; drip-free spout\r\nCan be used on gas or electric stovetops; dishwasher-safe\r\nIncludes metal heat diffuser for safe use on electric range coils\r\nMeasures approximately 9 by 6 by 7-1/2 inches', 2, '11.00', 'upload/41QoLid-bUL.jpg1365731556842.jpg', 0, 4, '2013-04-12 01:52:36'),
(4, 'Aroma AWK-115S Cordless Water Kettle', 'Kettle', 'Electric hot-water kettle boils up to 1-1/2 liters at cup-a-minute speed\r\n360-degree swivel base for cordless pouring; shuts off automatically after boiling\r\nWater-level indicator; comfortable stay-cool handle; nondrip spout\r\nPolished stainless-steel housing; removable, washable spout filter\r\nMeasures approximately 8 by 8 by 9 inches; 1-year limited warranty', 2, '30.99', 'upload/613ybpq2bzL._SL1323_.jpg1365731631664.jpg', 0, 9, '2013-04-12 01:53:51'),
(6, 'Copco Halo 1.2-Quart Brushed Stainless Steel Teakettle', 'Kettle', 'Brushed stainless steel finish\r\nFlip up whistle opens for spout\r\nComfortable grip\r\nHolds 1.2 Quart capacity\r\n', 2, '14.99', 'upload/41PV2Y7X22L.jpg1365732130509.jpg', 0, 10, '2013-04-12 02:02:10'),
(7, 'Pedrini Tea Kettle with Whistle', 'Kettle', 'Traditional tea kettle design with a mirror polished exterior\r\nLarge 2-1/4 liter capacity with large opening for easy filling\r\nDurable whistle signals when water has reached a boil\r\nComfortable handle for easy gripping', 2, '13.34', 'upload/51PlcmaY2oL._SL1000_.jpg1365732189500.jpg', 0, 4, '2013-04-12 02:03:09'),
(8, 'DV by Dolce Vita Women''s Pippi Mary Jane Pump', 'Shoes', 'suede\r\nSynthetic sole\r\nHeel measures approximately 4.25"\r\nPlatform measures approximately 0.75"\r\nMade in China', 3, '89.00', 'upload/71skRR-P47L._SL1500_.jpg1365732397402.jpg', 0, 4, '2013-04-12 02:06:37'),
(9, 'Madden Girl Women''s Hippieee Wedge Sandal', 'Shoes', 'Manmade\r\nManmade sole\r\nHeel measures approximately 2.75"\r\nGladiator style', 3, '39.62', 'upload/71p1c96kKsL._SL1354_.jpg1365732499580.jpg', 0, 4, '2013-04-12 02:08:19'),
(10, 'Skechers Men''s Energy Afterburn Lace Up', 'Shoes', 'leather\r\nRubber sole\r\nLace up front\r\nPadded collar and tongue\r\nSoft fabric shoe lining\r\nCushioned insole\r\nShock absorbing midsole', 3, '33.99', 'upload/81zBV4vN1UL._SL1500_.jpg1365732534192.jpg', 0, 9, '2013-04-12 02:08:54'),
(11, 'Josmo 29839 Thong Sandal (Toddler/Little Kid/Big Kid)', 'Shoes', 'Manmade\r\nManmade sole\r\nHeel measures approximately 0.5"\r\nMade in China', 3, '27.99', 'upload/61OL7UwT-OL._SL1500_.jpg1365732564211.jpg', 0, 9, '2013-04-12 02:09:24'),
(12, 'Lauren Ralph Lauren Women''s Jane Sandal', 'Shoes', 'leather\r\nLeather sole', 3, '39.99', 'upload/71CXXN+EmLL._SL1500_.jpg1365732599761.jpg', 0, 6, '2013-04-12 02:09:59'),
(13, 'Madden Girl Women''s Gertiee Open-Toe Pump', 'Shoes', 'Manmade\r\nManmade sole\r\nHeel measures approximately 3.5"\r\nPlatform measures approximately 0.75"\r\nWomen''s Madden Girl, Gertiee Pump\r\nA beautiful peep toe pump style\r\nPatent-look manmade uppers\r\nOpen toe design with foot flattering Cross straps\r\nSmooth linings with Cushioned Fabric covered insole', 3, '34.99', 'upload/71MVir2xpBL._SL1500_.jpg1365732660524.jpg', 0, 7, '2013-04-12 02:11:00'),
(14, '(12x12) Goats in Trees - 2013 Wall Calendar', 'Calendar', 'brand new officially licensed calendar\r\nkeep track of time in style all year long\r\nmeasures 12.00 by 12.00 inches\r\nships quickly and safely in a protective envelope\r\n', 4, '19.99', 'upload/51uwerTZowL.jpg1365732812544.jpg', 0, 40, '2013-04-12 02:13:32'),
(15, '2013 Wall Calendar: Anne Taintor', 'Calendar', '2013 Wall Calendar: Anne Taintor', 4, '9.99', 'upload/61tSzACvhXL.jpg1365732856238.jpg', 0, 20, '2013-04-12 02:14:16'),
(16, 'Out on the Porch 2013 Calendar', 'Calendar', 'Out on the Porch 2013 Calendar', 4, '9.99', 'upload/61MYtNlLMYL.jpg1365732917362.jpg', 0, 10, '2013-04-12 02:15:17'),
(17, 'Bad Cat 2013 Wall Calendar', 'Calendar', 'Bad Cat 2013 Wall Calendar', 4, '11.95', 'upload/61vNhMvuNaL.jpg1365732939664.jpg', 0, 10, '2013-04-12 02:15:39'),
(18, '(12x12) Peanuts - 16-Month 2013 Wall Calendar', 'Calendar', '(12x12) Peanuts - 16-Month 2013 Wall Calendar', 4, '9.99', 'upload/51mdMc14PuL.jpg1365732962174.jpg', 0, 10, '2013-04-12 02:16:02');

INSERT INTO `message` (`id`, `from`, `to`, `subject`, `text`, `isDeleted`, `read`, `created`, `showToRec`, `showToSen`) VALUES
(1, 1, 3, 'Question', 'How fast should I expect the item?', 0, 0, '2013-04-12 02:19:09', 1, 1),
(2, 1, 4, 'Question about calendar', 'How toxic is the paper?', 0, 0, '2013-04-12 02:19:43', 1, 1),
(3, 1, 2, 'Question', 'When do you expect new items to be in stock?', 0, 0, '2013-04-12 02:20:24', 1, 1),
(4, 1, 2, 'Nm', 'Never mind :}', 0, 1, '2013-04-12 02:20:37', 1, 1),
(5, 2, 1, 'Refund', 'Response regarding your review:\r\n"The whistle doesn''t work at all!\r\nI need a refund, but they are not in the software requirements."\r\n\r\n\r\nSorry but i''m not giving you any refund.', 0, 0, '2013-04-12 02:27:16', 1, 1);

INSERT INTO `order` (`id`, `sellerId`, `customerId`, `addressD`, `addressB`, `total`, `created`) VALUES
(1, 2, 1, 'John Smith\nUniversity at Albany, Freedom apts #3223\nAlbany 12222', 'John Smith\nUniversity at Albany, Freedom apts #3223\nAlbany 12222', '32.61', '2013-04-12 02:17:42'),
(2, 3, 1, 'John Smith\nUniversity at Albany, Freedom apts #3223\nAlbany 12222', 'John Smith\nUniversity at Albany, Freedom apts #3223\nAlbany 12222', '73.98', '2013-04-12 02:17:42'),
(3, 4, 1, 'John Smith\nUniversity at Albany, Freedom apts #3223\nAlbany 12222', 'John Smith\nUniversity at Albany, Freedom apts #3223\nAlbany 12222', '29.98', '2013-04-12 02:17:42'),
(4, 3, 1, 'John Smith\nUniversity at Albany, Freedom apts #3223\nAlbany 12222', 'John Smith\nUniversity at Albany, Freedom apts #3223\nAlbany 12222', '79.24', '2013-04-12 02:18:18'),
(5, 4, 1, 'John Smith\nUniversity at Albany, Freedom apts #3223\nAlbany 12222', 'John Smith\nUniversity at Albany, Freedom apts #3223\nAlbany 12222', '9.99', '2013-04-12 02:18:18'),
(6, 2, 1, 'John Smith\nUniversity at Albany, Colonial apt #2332\nAlbany 12222', 'John Smith\nUniversity at Albany, Colonial apt #2332\nAlbany 12222', '13.34', '2013-04-12 02:22:28');

INSERT INTO `status` (`id`, `orderId`, `type`, `description`, `created`) VALUES
(1, 1, 1, 'Order received', '2013-04-12 02:17:42'),
(2, 2, 1, 'Order received', '2013-04-12 02:17:42'),
(3, 3, 1, 'Order received', '2013-04-12 02:17:42'),
(4, 4, 1, 'Order received', '2013-04-12 02:18:18'),
(5, 5, 1, 'Order received', '2013-04-12 02:18:18'),
(6, 6, 1, 'Order received', '2013-04-12 02:22:28'),
(7, 6, 2, 'Will be shipped soon', '2013-04-12 02:24:27'),
(8, 1, 3, 'Shipped', '2013-04-12 02:24:39');

INSERT INTO `orderitem` (`orderId`, `itemId`, `count`) VALUES
(1, 2, 1),
(2, 10, 1),
(2, 12, 1),
(3, 16, 1),
(3, 14, 1),
(4, 9, 2),
(5, 15, 1),
(6, 7, 1);

INSERT INTO `review` (`id`, `customerId`, `sellerId`, `itemId`, `text`, `star`, `isDeleted`, `created`) VALUES
(1, 1, 3, 9, 'I don''t like this item at all! Quality is absolutely terrible!', 2, 0, '2013-04-12 02:21:20'),
(2, 1, 4, 15, 'This is absolutely amazing calendar!\r\nI really like it!', 5, 0, '2013-04-12 02:21:50'),
(3, 1, 2, 2, 'Great kettle!\r\nI like it.', 4, 0, '2013-04-12 02:22:44'),
(4, 1, 2, 7, 'The whistle doesn''t work at all!\r\nI need a refund, but they are not in the software requirements.', 2, 0, '2013-04-12 02:23:40');

INSERT INTO `notification` (`id`, `userId`, `status`, `pointer`, `read`, `created`) VALUES
(1, 2, 22, 1, 1, '2013-04-12 02:17:42'),
(2, 3, 22, 2, 0, '2013-04-12 02:17:42'),
(3, 4, 22, 3, 0, '2013-04-12 02:17:42'),
(4, 3, 22, 4, 0, '2013-04-12 02:18:18'),
(5, 4, 22, 5, 0, '2013-04-12 02:18:18'),
(6, 3, 10, 1, 0, '2013-04-12 02:19:09'),
(7, 4, 10, 2, 0, '2013-04-12 02:19:43'),
(8, 2, 10, 3, 0, '2013-04-12 02:20:24'),
(9, 2, 10, 4, 0, '2013-04-12 02:20:37'),
(10, 3, 21, 9, 0, '2013-04-12 02:21:20'),
(11, 4, 21, 15, 0, '2013-04-12 02:21:50'),
(12, 2, 22, 6, 1, '2013-04-12 02:22:28'),
(13, 2, 21, 2, 0, '2013-04-12 02:22:44'),
(14, 2, 21, 7, 1, '2013-04-12 02:23:40'),
(15, 1, 30, 6, 0, '2013-04-12 02:24:27'),
(16, 1, 31, 1, 0, '2013-04-12 02:24:39'),
(17, 1, 10, 5, 0, '2013-04-12 02:27:16');
