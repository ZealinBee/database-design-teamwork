-- Creates Database

CREATE DATABASE "E_Commerce"
    WITH
    OWNER = admin
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Creates Schema

CREATE SCHEMA IF NOT EXISTS "E_Commerce"
    AUTHORIZATION admin;

-- Creates Category table

CREATE TABLE IF NOT EXISTS "E_Commerce".category
(
    category_id serial,
    name character varying(50) NOT NULL,
    PRIMARY KEY (category_id)
);

ALTER TABLE IF EXISTS "E_Commerce".category
    OWNER to admin;

-- importing data
COPY E_Commerce.categories (name)
FROM '/Users/ebizimoh/Documents/Integrify_Files/PostGres_Files/fs15_teamwork/data/categories.csv'
DELIMITER ','
CSV HEADER QUOTE '\"'
NULL 'NULL'
ESCAPE '''';"";

-- Creates product table, DROP TABLE IF EXISTS "E_Commerce".products;

CREATE TABLE IF NOT EXISTS "E_Commerce".products
(
    product_id integer NOT NULL DEFAULT nextval('"E_Commerce".products_product_id_seq'::regclass),
    product_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    category_id integer NOT NULL,
    price numeric NOT NULL,
    description text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT products_pkey PRIMARY KEY (product_id),
    CONSTRAINT catogory_id_fk FOREIGN KEY (category_id)
        REFERENCES "E_Commerce".category (category_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "E_Commerce".products
    OWNER to admin;

-- importing data
COPY E_Commerce.products (product_name, category_id, price, description)
FROM '/Users/ebizimoh/Documents/Integrify_Files/PostGres_Files/fs15_teamwork/data/products.csv'
DELIMITER ','
CSV HEADER QUOTE '\"'
NULL 'NULL'
ESCAPE '''';"";

-- Creates User Table

CREATE TABLE IF NOT EXISTS "E_Commerce".users
(
    id serial,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    phone character varying(30) NOT NULL,
    address character varying(50) NOT NULL,
    is_admin boolean NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "E_Commerce".users
    OWNER to admin;

-- importing data
COPY E_Commerce.users (first_name, last_name, email, phone, address, is_admin)
FROM '/Users/ebizimoh/Documents/Integrify_Files/PostGres_Files/fs15_teamwork/data/users.csv'
DELIMITER ','
CSV HEADER QUOTE '\"'
NULL 'NULL'
ESCAPE '''';"";