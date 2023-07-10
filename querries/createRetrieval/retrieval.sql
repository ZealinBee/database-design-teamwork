CREATE OR REPLACE FUNCTION get_all_items(
    _table_name TEXT,
    _sort_column TEXT DEFAULT 'id',
    _sort_order TEXT DEFAULT 'ASC',
    _filter_column TEXT DEFAULT NULL,
    _filter_value TEXT DEFAULT NULL,
    _offset INTEGER DEFAULT 0,
    _limit INTEGER DEFAULT 10
)
RETURNS SETOF RECORD AS $$
BEGIN
    RETURN QUERY EXECUTE FORMAT(
        'SELECT *
         FROM %I
         WHERE (%I = %L OR %L IS NULL)
         ORDER BY %I %s
         OFFSET %s
         LIMIT %s',
        _table_name,
        _filter_column, _filter_value, _filter_value,
        _sort_column,
        _sort_order,
        _offset,
        _limit
    );
END;
$$ LANGUAGE plpgsql;
