-- Function to get one item of a table by id

CREATE OR REPLACE FUNCTION get_item_by_tablename_id(
    table_name TEXT,
    id INT
)
RETURNS SETOF RECORD AS $$
    DECLARE
        v_query TEXT;
    BEGIN
        v_query := format('SELECT * FROM %I WHERE %I = %s LIMIT 1', table_name, table_name || '_id', id);

        RETURN QUERY EXECUTE v_query;
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
