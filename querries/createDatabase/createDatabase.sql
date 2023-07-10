-- create table categories
CREATE TABLE IF NOT EXISTS public.categories
(
    id serial PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- import data
COPY public.categories (name)
FROM '/Users/khanhngguyen/Desktop/KHANH/Integrify/fs15_teamwork/data/categories.csv'
DELIMITER ','
CSV HEADER QUOTE '\"'
NULL 'NULL';

-- create table products
CREATE TABLE IF NOT EXISTS public.products
(
    id serial PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    category_id integer NOT NULL
        REFERENCES public.categories(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    price numeric(5, 2) NOT NULL,
    description text NOT NULL
);

-- import data
COPY public.products (name, category_id, price, description)
FROM '/Users/khanhngguyen/Desktop/KHANH/Integrify/fs15_teamwork/data/products.csv'
DELIMITER ','
CSV HEADER QUOTE '\"'
NULL 'NULL'
ESCAPE '''';"";

-- create users table
CREATE TABLE IF NOT EXISTS public.users
(
    id serial PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    address VARCHAR(50) NOT NULL,
    is_admin boolean NOT NULL
);

-- import data
COPY public.users (first_name, last_name, email, phone, address, is_admin)
FROM '/Users/khanhngguyen/Desktop/KHANH/Integrify/fs15_teamwork/data/users.csv'
DELIMITER ','
CSV HEADER QUOTE '\"'
NULL 'NULL'
ESCAPE '''';"";
