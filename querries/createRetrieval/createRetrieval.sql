-- First set the search_path to the schema name i.e. SET search_path TO ecommerce;

-- Test the below function by:
-- SELECT * FROM get_all_products('product', 'product_id', 'ASC', 'product_id', '1', 0, 10);
CREATE OR REPLACE FUNCTION get_all_products(
    _table_name TEXT,
    _sort_column TEXT DEFAULT 'product_id',
    _sort_order TEXT DEFAULT 'ASC',
    _filter_column TEXT DEFAULT NULL,
    _filter_value TEXT DEFAULT NULL,
    _offset INTEGER DEFAULT 0,
    _limit INTEGER DEFAULT 10
)
RETURNS SETOF ecommerce.product AS $$
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



-- Test the below function by:
-- SELECT * FROM get_all_users('user', 'user_id', 'ASC', 'user_id', '1', 0, 10);
CREATE OR REPLACE FUNCTION get_all_users(
    _table_name TEXT,
    _sort_column TEXT DEFAULT 'user_id',
    _sort_order TEXT DEFAULT 'ASC',
    _filter_column TEXT DEFAULT NULL,
    _filter_value TEXT DEFAULT NULL,
    _offset INTEGER DEFAULT 0,
    _limit INTEGER DEFAULT 10
)
RETURNS SETOF ecommerce.user AS $$
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


-- Test the below function by:
-- SELECT * FROM get_all_categories('category', 'category_id', 'ASC', 'category_id', '1', 0, 10);

CREATE OR REPLACE FUNCTION get_all_categories(
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

-- Test the below function by:
-- SELECT * FROM get_all_inventory('inventory', 'product_id', 'ASC', 'product_id', '1', 0, 10);

CREATE OR REPLACE FUNCTION get_all_inventory(
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

-- Test the below function by:
-- SELECT * FROM get_all_reviews('review', 'review_id', 'ASC', 'review_id', '1', 0, 10);

CREATE OR REPLACE FUNCTION get_all_reviews(
    _table_name TEXT,
    _sort_column TEXT DEFAULT 'review_id',
    _sort_order TEXT DEFAULT 'ASC',
    _filter_column TEXT DEFAULT NULL,
    _filter_value TEXT DEFAULT NULL,
    _offset INTEGER DEFAULT 0,
    _limit INTEGER DEFAULT 10
)
RETURNS SETOF ecommerce.review AS $$
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

-- Test the below function by:
-- SELECT * FROM get_all_orders('order', 'order_id', 'ASC', 'order_id', '1', 0, 10);

CREATE OR REPLACE FUNCTION get_all_orders(
    _table_name TEXT,
    _sort_column TEXT DEFAULT 'order_id',
    _sort_order TEXT DEFAULT 'ASC',
    _filter_column TEXT DEFAULT NULL,
    _filter_value TEXT DEFAULT NULL,
    _offset INTEGER DEFAULT 0,
    _limit INTEGER DEFAULT 10
)
RETURNS SETOF ecommerce.order AS $$
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

-- Test the below function by:
-- SELECT * FROM get_all_order_details('order_details', 'order_id', 'ASC', 'order_id', '1', 0, 10);

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