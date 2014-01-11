PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE "events" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "datum" date, "zeit" time, "dj_start_zeit" time, "dj_ende_zeit" time, "strasse" varchar(255), "stadt" varchar(255), "anzahl" integer, "anzahl20" integer, "anzahl60" integer, "equipment" boolean, "beratung" boolean, "kommentar" text, "wish_id" integer, "user_id" integer, "ort" varchar(255));
INSERT INTO "events" VALUES(1,"2014-01-24","2000-01-01 10:00:00.000000","2000-01-01 10:00:00.000000","2000-01-01 12:00:00.000000","Hauptstrasse 123","12587 Berlin",199,2,4,1,1,"Nix",7,7,"Club78");
INSERT INTO "events" VALUES(2,"2014-01-25","2000-01-01 18:00:00.000000","2000-01-01 18:00:00.000000","2000-01-01 23:00:00.000000","Hauptstrasse 123","12587 Berlin",199,2,4,1,1,"Nix",7,7,"Bar 1897");
INSERT INTO "events" VALUES(3,"2014-01-26","2000-01-01 20:00:00.000000","2000-01-01 20:00:00.000000",NULL,"Hauptstrasse 123","12587 Berlin",199,2,4,1,1,"Nix",7,7,"Bürgerhaus");
INSERT INTO "events" VALUES(4,"2014-01-30","2000-01-01 21:00:00.000000","2000-01-01 21:00:00.000000",NULL,"Hauptstrasse 123","12587 Berlin",199,2,4,1,1,"Nix",7,7,"NixDa");
COMMIT;