CREATE TYPE "toggle_status" AS ENUM (
  'active',
  'deactive'
);

CREATE TYPE "order_status" AS ENUM (
  'pending',
  'processing',
  'delivered'
);

CREATE TYPE "room_type" AS ENUM (
  'normal',
  'super',
  'premium'
);

CREATE TABLE "permission" (
  "id" uuid PRIMARY KEY,
  "route" varchar,
  "role" uuid NOT NULL,
  "is_yes" bool DEFAULT true,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "roles" (
  "id" uuid PRIMARY KEY,
  "name" varchar,
  "status" toggle_status DEFAULT 'active',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "default_user" (
  "id" uuid PRIMARY KEY,
  "first_name" varchar,
  "last_name" varchar,
  "email" varchar,
  "password" varchar,
  "role" roles,
  "status" toggle_status NOT NULL DEFAULT 'active',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "users" (
  "id" uuid PRIMARY KEY,
  "first_name" varchar NOT NULL,
  "last_name" varchar NOT NULL,
  "status" toggle_status NOT NULL DEFAULT 'active',
  "role" roles,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "yachts" (
  "id" uuid PRIMARY KEY,
  "name" varchar NOT NULL,
  "admin" uuid NOT NULL,
  "status" toggle_status NOT NULL DEFAULT 'active',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "devices" (
  "id" uuid PRIMARY KEY,
  "name" varchar NOT NULL,
  "yacht" uuid NOT NULL,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "yacht_config" (
  "id" uuid PRIMARY KEY,
  "yacht_id" uuid NOT NULL,
  "users" uuid NOT NULL,
  "trip_id" uuid NOT NULL,
  "trip_name" varchar,
  "start_point" varchar,
  "end_point" varchar,
  "start_date" date,
  "end_date" date,
  "menus" uuid,
  "orders" uuid,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "decks" (
  "id" uuid PRIMARY KEY,
  "yacht" uuid NOT NULL,
  "name" varchar,
  "deck_hand" uuid NOT NULL,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "rooms" (
  "id" uuid PRIMARY KEY,
  "yacht_config" uuid NOT NULL,
  "number" varchar,
  "type" room_type,
  "device" uuid NOT NULL,
  "guests" uuid,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "guest_relations" (
  "id" uuid PRIMARY KEY,
  "guest1" uuid NOT NULL,
  "guest2" uuid NOT NULL,
  "name" varchar,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "guest_details" (
  "id" uuid PRIMARY KEY,
  "guest" uuid NOT NULL,
  "email" varchar,
  "mobile_number" varchar,
  "id_proof" varchar UNIQUE,
  "age" number,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "categories" (
  "id" uuid PRIMARY KEY,
  "name" varchar,
  "status" toggle_status DEFAULT 'active',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "menus" (
  "id" uuid PRIMARY KEY,
  "name" varchar,
  "menu_items" uuid NOT NULL,
  "status" toggle_status DEFAULT 'active',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "menu_items" (
  "id" uuid PRIMARY KEY,
  "name" varchar,
  "quantity" varchar,
  "price" varchar,
  "category" uuid NOT NULL,
  "status" toggle_status DEFAULT 'active',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "adds_on_items" (
  "id" uuid PRIMARY KEY,
  "menu_item" uuid,
  "name" varchar,
  "details" varchar,
  "price" varchar,
  "status" toggle_status DEFAULT 'active',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "orders" (
  "id" uuid PRIMARY KEY,
  "user" uuid NOT NULL,
  "items" uuid NOT NULL,
  "total" varchar,
  "status" order_status DEFAULT 'pending',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "ingredients" (
  "id" uuid PRIMARY KEY,
  "yacht_config" uuid NOT NULL,
  "name" varchar,
  "details" varchar,
  "quantity" varchar,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestampa,
  "deleted_at" timestamp
);

ALTER TABLE "permission" ADD FOREIGN KEY ("role") REFERENCES "roles" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "default_user" ADD FOREIGN KEY ("role") REFERENCES "roles" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "users" ADD FOREIGN KEY ("role") REFERENCES "roles" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "users" ADD FOREIGN KEY ("id") REFERENCES "yachts" ("admin") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "devices" ADD FOREIGN KEY ("yacht") REFERENCES "yachts" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "yacht_config" ADD FOREIGN KEY ("yacht_id") REFERENCES "yachts" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "users" ADD FOREIGN KEY ("id") REFERENCES "yacht_config" ("users") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "menus" ADD FOREIGN KEY ("id") REFERENCES "yacht_config" ("menus") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "orders" ADD FOREIGN KEY ("id") REFERENCES "yacht_config" ("orders") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "decks" ADD FOREIGN KEY ("yacht") REFERENCES "yachts" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "decks" ADD FOREIGN KEY ("deck_hand") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "rooms" ADD FOREIGN KEY ("yacht_config") REFERENCES "yacht_config" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "rooms" ADD FOREIGN KEY ("device") REFERENCES "devices" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "users" ADD FOREIGN KEY ("id") REFERENCES "rooms" ("guests") DEFERRABLE INITIALLY IMMEDIATE;

CREATE TABLE "users_guest_relations" (
  "users_id" uuid,
  "guest_relations_guest1" uuid,
  PRIMARY KEY ("users_id", "guest_relations_guest1")
);

ALTER TABLE "users_guest_relations" ADD FOREIGN KEY ("users_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "users_guest_relations" ADD FOREIGN KEY ("guest_relations_guest1") REFERENCES "guest_relations" ("guest1") DEFERRABLE INITIALLY IMMEDIATE;


CREATE TABLE "users_guest_relations(1)" (
  "users_id" uuid,
  "guest_relations_guest2" uuid,
  PRIMARY KEY ("users_id", "guest_relations_guest2")
);

ALTER TABLE "users_guest_relations(1)" ADD FOREIGN KEY ("users_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "users_guest_relations(1)" ADD FOREIGN KEY ("guest_relations_guest2") REFERENCES "guest_relations" ("guest2") DEFERRABLE INITIALLY IMMEDIATE;


ALTER TABLE "guest_details" ADD FOREIGN KEY ("guest") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "menu_items" ADD FOREIGN KEY ("id") REFERENCES "menus" ("menu_items") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "categories" ADD FOREIGN KEY ("id") REFERENCES "menu_items" ("category") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "adds_on_items" ADD FOREIGN KEY ("menu_item") REFERENCES "menu_items" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "users" ADD FOREIGN KEY ("id") REFERENCES "orders" ("user") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "orders" ADD FOREIGN KEY ("items") REFERENCES "menu_items" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "yacht_config" ADD FOREIGN KEY ("id") REFERENCES "ingredients" ("yacht_config") DEFERRABLE INITIALLY IMMEDIATE;
