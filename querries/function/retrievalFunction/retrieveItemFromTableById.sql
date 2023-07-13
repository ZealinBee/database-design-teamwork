-- Function to get one item of a table by id

CREATE OR REPLACE FUNCTION ecommerce.get_item_by_tablename_id(
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