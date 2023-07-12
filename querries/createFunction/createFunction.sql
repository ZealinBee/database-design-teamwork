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

-- Function to place order

CREATE OR REPLACE FUNCTION ecommerce.place_order(
    p_user_id INTEGER,
    p_product_id INTEGER,
    p_product_quantity INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    v_order_id INTEGER;
    v_product_price NUMERIC;
    v_subtotal NUMERIC := 0;
    v_available_quantity INTEGER;
BEGIN
    SELECT total_quantity, price INTO v_available_quantity, v_product_price
    FROM ecommerce.inventory
    JOIN ecommerce.product ON inventory.product_id = product.product_id
    WHERE inventory.product_id = p_product_id;
    
    IF v_available_quantity < p_product_quantity THEN
        RAISE EXCEPTION 'Insufficient quantity in inventory.';
    END IF;
    
    v_subtotal := v_product_price * p_product_quantity;

    INSERT INTO ecommerce.order (user_id, subtotal, created_at, modified_at)
    VALUES (p_user_id, v_subtotal, CURRENT_DATE, CURRENT_DATE)
    RETURNING order_id INTO v_order_id;
    
    INSERT INTO ecommerce.order_details (order_id, product_id, product_quantity, created_at, modified_at)
    VALUES (v_order_id, p_product_id, p_product_quantity, CURRENT_DATE, CURRENT_DATE);
    
    UPDATE ecommerce.inventory
    SET total_quantity = total_quantity - p_product_quantity,
        modified_at = CURRENT_DATE
    WHERE product_id = p_product_id;
    
    RETURN v_order_id;
END;
$$ LANGUAGE plpgsql;

-- Function to cancel order

CREATE OR REPLACE FUNCTION ecommerce.cancel_order(p_order_id INTEGER)
RETURNS VOID AS $$
DECLARE
    v_product_id INTEGER;
    v_product_quantity INTEGER;
    v_subtotal NUMERIC;
BEGIN
    SELECT product_id, product_quantity INTO v_product_id, v_product_quantity
    FROM ecommerce.order_details
    WHERE order_id = p_order_id;
    
    SELECT subtotal INTO v_subtotal
    FROM ecommerce.order
    WHERE order_id = p_order_id;
    
    DELETE FROM ecommerce.order_details
    WHERE order_id = p_order_id;
    
    UPDATE ecommerce.inventory
    SET total_quantity = total_quantity + v_product_quantity,
        modified_at = CURRENT_DATE
    WHERE product_id = v_product_id;
    
    UPDATE ecommerce.order
    SET subtotal = subtotal - v_subtotal,
        modified_at = CURRENT_DATE
    WHERE order_id = p_order_id;
    
    DELETE FROM ecommerce.order
    WHERE order_id = p_order_id;
    
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- Function to get 10 most bought products and their quantities
-- Test it by running SELECT * FROM get_10_most_bought_products();
CREATE OR REPLACE FUNCTION get_10_most_bought_products()
RETURNS TABLE (product_name CHARACTER VARYING(50), quantity_bought BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT p.product_name, SUM(od.product_quantity) AS quantity_bought
    FROM ecommerce.product AS p
    JOIN ecommerce.order_details AS od ON p.product_id = od.product_id
    GROUP BY p.product_name
    ORDER BY quantity_bought DESC
    LIMIT 10;
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
