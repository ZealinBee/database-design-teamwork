-- First set the search_path to the schema name i.e. SET search_path TO ecommerce;\

-- Test the below function by:
-- SELECT * FROM get_all_order_details('order_details', 'order_id', 'ASC', 'order_id', '1', 0, 10); -- This will return the order_details with order_id = 1

CREATE OR REPLACE FUNCTION get_all_order_details(
    _table_name TEXT,
    _sort_column TEXT DEFAULT 'order_id',
    _sort_order TEXT DEFAULT 'ASC',
    _filter_column TEXT DEFAULT NULL,
    _filter_value TEXT DEFAULT NULL,
    _offset INTEGER DEFAULT 0,
    _limit INTEGER DEFAULT 10
)
RETURNS SETOF ecommerce.order_details AS $$
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