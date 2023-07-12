-- Function to get all products with filtering, sorting and pagination

CREATE OR REPLACE FUNCTION get_all_products(
    sort_column TEXT,
    sort_order TEXT,
    filter_column TEXT,
    filter_value TEXT,
    page_size INT,
    page_number INT
)
RETURNS SETOF product AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM product
    WHERE (filter_column IS NULL OR product.*::text ILIKE '%' || filter_value || '%')
    ORDER BY
        CASE WHEN sort_order = 'desc' THEN
            CASE WHEN sort_column = 'product_id' THEN product.product_id END DESC,
            CASE WHEN sort_column = 'product_name' THEN product.product_name END DESC,
            CASE WHEN sort_column = 'image' THEN product.image END DESC,
            CASE WHEN sort_column = 'price' THEN product.price END DESC,
            CASE WHEN sort_column = 'description' THEN product.description END DESC,
            CASE WHEN sort_column = 'category_id' THEN product.category_id END DESC
        ELSE
            CASE WHEN sort_column = 'product_id' THEN product.product_id END ASC,
            CASE WHEN sort_column = 'product_name' THEN product.product_name END ASC,
            CASE WHEN sort_column = 'image' THEN product.image END ASC,
            CASE WHEN sort_column = 'price' THEN product.price END ASC,
            CASE WHEN sort_column = 'description' THEN product.description END ASC,
            CASE WHEN sort_column = 'category_id' THEN product.category_id END ASC
        END
    LIMIT page_size
    OFFSET (page_number - 1) * page_size;
END;
$$ LANGUAGE plpgsql;


-- Function to get one item of a table by id

CREATE OR REPLACE FUNCTION get_item_by_tablename_id(
    table_name TEXT,
    id INT
)
RETURNS SETOF RECORD AS $$
    DECLARE
        search_query TEXT;
        search_count INT;
    BEGIN
        search_query := format('SELECT * FROM %I WHERE %I = %s LIMIT 1', table_name, table_name || '_id', id);
        EXECUTE search_query INTO STRICT;

        GET DIAGNOSTICS search_count = ROW_COUNT;

        IF search_count = 0 THEN
            RAISE EXCEPTION 'No item found with ID % in table %.', item_id, table_name;
        END IF;

        RETURN QUERY EXECUTE search_query;
    END;
$$ LANGUAGE plpgsql;


-- Function to update product

CREATE OR REPLACE FUNCTION update_product(
    product_id INT,
    product_name TEXT,
    image TEXT,
    price NUMERIC,
    description TEXT,
    category_id INT,
    created_at date,
    modified_at date,
)
    RETURNS VOID AS $$
    BEGIN
        UPDATE product
        SET
            product_name = product_name,
            image = image,
            price = price,
            description = description,
            category_id = category_id,
            created_at = created_at,
            modified_at = modified_at,
        WHERE product_id = product_id;
    END;
$$ LANGUAGE plpgsql;


-- Function to delete product

CREATE OR REPLACE FUNCTION delete_product(
    product_id INT
)
RETURNS VOID AS $$
    BEGIN
        DELETE FROM product
        WHERE product_id = product_id;
    END;
$$ LANGUAGE plpgsql;


-- Function to register users
-- Install the pgcrypto extension before running command.
-- You can run the command `CREATE EXTENSION IF NOT EXISTS pgcrypto;` to install the extension.

CREATE OR REPLACE FUNCTION register_user(
    new_first_name TEXT,
    new_last_name TEXT,
    new_password_hash TEXT,
    new_email TEXT,
    new_phone TEXT,
    new_image TEXT,
    new_address TEXT,
    new_is_admin BOOLEAN
)
RETURNS VOID AS $$
DECLARE
    new_password_hash TEXT;
BEGIN
    IF new_email IS NULL OR new_email = '' THEN
        RAISE EXCEPTION 'Email cannot be empty.';
    END IF;

    -- Generates the password hash using the 'pgcrypto' extension
    new_password_hash := crypt(new_password, gen_salt('bf'));

    INSERT INTO "user" (first_name, last_name, password_hash, email, phone, image, address, is_admin)
    VALUES (new_first_name, new_last_name, new_password_hash, new_email, new_phone, new_image, new_address, new_is_admin);
END;
$$ LANGUAGE plpgsql;


-- Function to update an existing user

CREATE OR REPLACE FUNCTION update_user(
    new_user_id INT,
    new_first_name TEXT,
    new_last_name TEXT,
    new_password TEXT,
    new_email TEXT,
    new_phone TEXT,
    new_image TEXT,
    new_address TEXT
)
RETURNS VOID AS $$
DECLARE
    new_password_hash TEXT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "user" WHERE user_id = new_user_id) THEN
        RAISE EXCEPTION 'User with ID % does not exist.', new_user_id;
    END IF;

    -- Generate the password hash if a new password is provided
    IF new_password IS NOT NULL AND new_password <> '' THEN
        new_password_hash := crypt(new_password, gen_salt('bf'));
    ELSE
        new_password_hash := (SELECT password_hash FROM "user" WHERE user_id = new_user_id);
    END IF;

    -- Update the user details excluding user_id and is_admin columns
    UPDATE "user"
    SET
        first_name = new_first_name,
        last_name = new_last_name,
        password_hash = new_password_hash,
        email = new_email,
        phone = new_phone,
        image = new_image,
        address = new_address
    WHERE user_id = new_user_id;
END;
$$ LANGUAGE plpgsql;


-- Function to delete an existing user

CREATE OR REPLACE FUNCTION delete_user(
    delete_user_id INT
)
RETURNS VOID AS $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM "user" WHERE user_id = delete_user_id) THEN
            RAISE EXCEPTION 'User with ID % does not exist.', delete_user_id;
        END IF;

        DELETE FROM "user"
        WHERE user_id = delete_user_id;
    END;
$$ LANGUAGE plpgsql;


-- Function to authenticate users

CREATE OR REPLACE FUNCTION authenticate_user(
    auth_email TEXT,
    auth_password TEXT
)
RETURNS BOOLEAN AS $$
BEGIN
    SELECT password_hash
    INTO old_password_hash
    FROM "user"
    WHERE email = auth_email;

    IF old_password_hash IS NOT NULL AND old_password_hash = crypt(auth_password, old_password_hash) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;