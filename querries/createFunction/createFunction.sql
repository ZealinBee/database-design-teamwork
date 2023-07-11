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
