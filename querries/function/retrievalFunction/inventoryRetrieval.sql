-- First set the search_path to the schema name i.e. SET search_path TO ecommerce;

-- Test the below function by:
-- SELECT * FROM get_all_inventory('inventory', 'product_id', 'ASC', 'product_id', '1', 0, 10);  -- This will return the inventory with product_id = 1

CREATE OR REPLACE FUNCTION ecommerce.get_all_inventory(
    _table_name TEXT,
    _sort_column TEXT DEFAULT 'product_id',
    _sort_order TEXT DEFAULT 'ASC',
    _filter_column TEXT DEFAULT NULL,
    _filter_value TEXT DEFAULT NULL,
    _offset INTEGER DEFAULT 0,
    _limit INTEGER DEFAULT 10
)
RETURNS SETOF ecommerce.inventory AS $$
DECLARE
    filter_condition TEXT;
BEGIN
    IF _filter_column IS NOT NULL THEN
        filter_condition := format('%I = %L', _filter_column, _filter_value);
    ELSE
        filter_condition := 'TRUE';
    END IF;

    RETURN QUERY EXECUTE format(
        'SELECT *
         FROM %I
         WHERE %s
         ORDER BY %I %s
         OFFSET %s
         LIMIT %s',
        _table_name,
        filter_condition,
        _sort_column,
        _sort_order,
        _offset,
        _limit
    );
END;
$$ LANGUAGE plpgsql;