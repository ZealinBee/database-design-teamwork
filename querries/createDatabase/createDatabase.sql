-- Creates Schema

CREATE SCHEMA ecommerce
    AUTHORIZATION admin;

-- DROP TABLE IF EXISTS ecommerce.category;

CREATE TABLE IF NOT EXISTS ecommerce.category
(
    category_id integer NOT NULL DEFAULT nextval('ecommerce.category_category_id_seq'::regclass),
    category_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    created_at date,
    modified_at date,
    CONSTRAINT category_pkey PRIMARY KEY (category_id),
    CONSTRAINT unique_category_name UNIQUE (category_name)
        INCLUDE(category_name)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS ecommerce.category
    OWNER to admin;

-- importing data
COPY E_Commerce.categories (category_name, created_at, modified_at)
FROM '/Users/ebizimoh/Documents/Integrify_Files/PostGres_Files/fs15_teamwork/data/categories.csv'
DELIMITER ','
CSV HEADER QUOTE '\"'
NULL 'NULL'
ESCAPE '''';"";

-- Creates product table, DROP TABLE IF EXISTS "E_Commerce".products;

CREATE TABLE IF NOT EXISTS ecommerce.product
(
    product_id serial,
    product_name character varying(50) NOT NULL,
    image character varying NOT NULL,
    price numeric NOT NULL,
    description text NOT NULL,
    category_id integer NOT NULL,
    created_at date,
    modified_at date,
    PRIMARY KEY (product_id),
    CONSTRAINT category_id_fk FOREIGN KEY (category_id)
        REFERENCES ecommerce.category (category_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
);

ALTER TABLE IF EXISTS ecommerce.product
    OWNER to admin;

-- importing data
COPY E_Commerce.products (product_name, image, price, description, category_id, created_at, modified_at)
FROM '/Users/ebizimoh/Documents/Integrify_Files/PostGres_Files/fs15_teamwork/data/products.csv'
DELIMITER ','
CSV HEADER QUOTE '\"'
NULL 'NULL'
ESCAPE '''';"";


-- DROP TABLE IF EXISTS ecommerce."user";

CREATE TABLE IF NOT EXISTS ecommerce.user
(
    user_id integer NOT NULL DEFAULT nextval('ecommerce.user_user_id_seq'::regclass),
    first_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    last_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    password_hash character varying(200) COLLATE pg_catalog."default" NOT NULL,
    email character varying(50) COLLATE pg_catalog."default" NOT NULL,
    phone character varying(20) COLLATE pg_catalog."default" NOT NULL,
    image character varying(200) COLLATE pg_catalog."default" NOT NULL,
    address character varying(150) COLLATE pg_catalog."default" NOT NULL,
    is_admin boolean NOT NULL,
    created_at date,
    modified_at date,
    CONSTRAINT user_pkey PRIMARY KEY (user_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS ecommerce.user
    OWNER to admin;

-- importing data
COPY E_Commerce.users (first_name, last_name, password_hash, email, phone, image, address, is_admin, created_at, modified_at)
FROM '/Users/ebizimoh/Documents/Integrify_Files/PostGres_Files/fs15_teamwork/data/users.csv'
DELIMITER ','
CSV HEADER QUOTE '\"'
NULL 'NULL'
ESCAPE '''';"";

-- DROP TABLE IF EXISTS ecommerce."order";

CREATE TABLE IF NOT EXISTS ecommerce.order
(
    order_id integer NOT NULL DEFAULT nextval('ecommerce.order_order_id_seq'::regclass),
    user_id integer NOT NULL,
    created_at date,
    modified_at date,
    CONSTRAINT order_pkey PRIMARY KEY (order_id),
    CONSTRAINT user_id_fk FOREIGN KEY (user_id)
        REFERENCES ecommerce.user (user_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS ecommerce.order
    OWNER to admin;


-- DROP TABLE IF EXISTS ecommerce.category;

CREATE TABLE IF NOT EXISTS ecommerce.inventory
(
    product_id integer NOT NULL,
    total_quantity integer NOT NULL,
    created_at date,
    modified_at date,
    CONSTRAINT unique_product_id UNIQUE (product_id)
        INCLUDE(product_id),
    CONSTRAINT product_id_fk FOREIGN KEY (product_id)
        REFERENCES ecommerce.product (product_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
);

ALTER TABLE IF EXISTS ecommerce.inventory
    OWNER to admin;

-- importing data
COPY E_Commerce.inventory (product_id,total_quantity,created_at,modified_at)
FROM '/Users/ebizimoh/Documents/Integrify_Files/PostGres_Files/fs15_teamwork/data/inventory.csv'
DELIMITER ','
CSV HEADER QUOTE '\"'
NULL 'NULL'
ESCAPE '''';"";

-- DROP TABLE IF EXISTS ecommerce.order_details;

CREATE TABLE IF NOT EXISTS ecommerce.order_details
(
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    product_quantity integer NOT NULL,
    created_at date,
    modified_at date,
    CONSTRAINT order_id_fk FOREIGN KEY (order_id)
        REFERENCES ecommerce.order (order_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID,
    CONSTRAINT product_id_fk FOREIGN KEY (product_id)
        REFERENCES ecommerce.product (product_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
);

ALTER TABLE IF EXISTS ecommerce.order_details
    OWNER to admin;


-- DROP TABLE IF EXISTS ecommerce.review;

CREATE TABLE IF NOT EXISTS ecommerce.review
(
    review_id integer NOT NULL DEFAULT nextval('ecommerce.review_review_id_seq'::regclass),
    user_id integer NOT NULL,
    review_text text COLLATE pg_catalog."default" NOT NULL,
    product_id integer NOT NULL,
    created_at date,
    modified_at date,
    CONSTRAINT review_pkey PRIMARY KEY (review_id),
    CONSTRAINT product_id_fk FOREIGN KEY (product_id)
        REFERENCES ecommerce.product (product_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT user_id FOREIGN KEY (user_id)
        REFERENCES ecommerce.user (user_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS ecommerce.review
    OWNER to admin;


-- importing data
COPY E_Commerce.review (user_id,review_text,product_id,created_at,modified_at)
FROM '/Users/ebizimoh/Documents/Integrify_Files/PostGres_Files/fs15_teamwork/data/reviews.csv'
DELIMITER ','
CSV HEADER QUOTE '\"'
NULL 'NULL'
ESCAPE '''';"";