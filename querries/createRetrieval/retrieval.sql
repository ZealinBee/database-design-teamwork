CREATE OR REPLACE FUNCTION get_all_items(
    _table_name TEXT,
    _sort_column TEXT DEFAULT 'id',
    _sort_order TEXT DEFAULT 'ASC',
    _filter_column TEXT DEFAULT NULL,
    _filter_value TEXT DEFAULT NULL,
    _limit INTEGER DEFAULT NULL,
    _offset INTEGER DEFAULT NULL,
    _page INTEGER DEFAULT NULL,
    _page_size INTEGER DEFAULT NULL
)
RETURNS SETOF RECORD AS $$
BEGIN
    RETURN QUERY EXECUTE FORMAT(
        'SELECT * 
        FROM %I
        WHERE (%I = %L OR %L IS NULL)
        ORDER BY %I %s
        LIMIT %s
        OFFSET %s',
        _table_name,
        _filter_column, _filter_value, _filter_value,
        _sort_column, _sort_order,
        COALESCE(_limit, _page_size),
        COALESCE(_offset, (_page - 1) * COALESCE(_limit, _page_size), 0)
    );
END;
$$ LANGUAGE plpgsql;
