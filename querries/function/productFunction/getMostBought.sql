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