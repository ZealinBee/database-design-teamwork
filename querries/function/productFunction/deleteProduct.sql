-- Function to delete product

CREATE OR REPLACE FUNCTION ecommerce.delete_product(
    p_product_id INT, -- Product ID of the product trying to delete the product
    p_user_id INT -- User ID of the user trying to delete the product
)
RETURNS VOID AS $$
DECLARE
    v_is_admin BOOLEAN;
BEGIN
    -- Check if the user is an admin
    SELECT is_admin INTO v_is_admin
    FROM ecommerce.user
    WHERE ecommerce.user.user_id = p_user_id;

    -- If the user is not an admin, raise an exception
    IF NOT v_is_admin THEN
        RAISE EXCEPTION 'User does not have permission to delete the product.';
    END IF;

    -- Check if the product exists
    IF NOT EXISTS (
        SELECT 1
        FROM ecommerce.product
        WHERE product_id = p_product_id
    ) THEN
        RAISE EXCEPTION 'Product does not exist.';
    END IF;

    -- Delete the product from the product table
    DELETE FROM ecommerce.product
    WHERE product_id = p_product_id;
END;
$$ LANGUAGE plpgsql;
