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