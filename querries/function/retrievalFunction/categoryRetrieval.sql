-- First set the search_path to the schema name i.e. SET search_path TO ecommerce;\

-- Test the below function by:
-- SELECT * FROM get_all_categories('category', 'category_id', 'ASC', 'category_id', '1', 0, 10); -- This will return the category with category_id = 1
-- SELECT * FROM get_all_categories('category', 'category_name', 'ASC', 'category_name', 'Shoes', 0, 10)  -- This will return the categories with category_name = 'Shoes' and sort by category_name
-- SELECT * FROM get_all_categories('category', 'category_name', 'ASC', NULL, NULL, 0, 5) -- This will return all categories and sort by category_name and limit the result to 5

CREATE OR REPLACE FUNCTION ecommerce.get_all_categories(
    _table_name TEXT,
    _sort_column TEXT DEFAULT 'category_id',
    _sort_order TEXT DEFAULT 'ASC',
    _filter_column TEXT DEFAULT NULL,
    _filter_value TEXT DEFAULT NULL,
    _offset INTEGER DEFAULT 0,
    _limit INTEGER DEFAULT 10
)
RETURNS SETOF ecommerce.category AS $$
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