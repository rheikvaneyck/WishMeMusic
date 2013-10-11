PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "firstname" varchar(255), "name" varchar(255), "aka_dj_name" varchar(255), "password_hash" varchar(255), "email" varchar(255), "tel" varchar(255), "role" varchar(255));
INSERT INTO "users" VALUES(1,'Jack','Johnson','DJ Jack',NULL,'jack@aol.com','01234567890','dj');
INSERT INTO "users" VALUES(2,'John','Jackson','DJ John',NULL,'john@googlemail.com','01234567891','dj');
INSERT INTO "users" VALUES(3,'James','Bucker','DJ James',NULL,'james@gmail.com','01234567892','dj');
INSERT INTO "users" VALUES(4,'Jean','Eames','DJ Jean',NULL,'jean@gmx.de','01234567893','dj');
COMMIT;
