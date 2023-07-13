-- Function to update product

CREATE OR REPLACE FUNCTION ecommerce.update_product(
    p_product_id INT, -- Product ID of the product trying to update the product
    p_product_name TEXT, -- New product name
    p_image TEXT, -- New product image url
    p_price NUMERIC, -- New product price
    p_description TEXT, -- New product description
    p_category_id INT, -- New product category
    p_modified_at DATE, -- Date of modification
    p_user_id INT -- User ID of the user trying to update the product
)
RETURNS VOID AS $$
DECLARE
    v_is_admin BOOLEAN;
BEGIN
    -- Check if the user is an admin
    SELECT is_admin INTO v_is_admin
    FROM ecommerce.user
    WHERE user_id = p_user_id;

    -- If the user is not an admin, raise an exception
    IF NOT v_is_admin THEN
        RAISE EXCEPTION 'User does not have permission to update the product.';
    END IF;

    -- Update the product in the product table
    UPDATE ecommerce.product
    SET
        product_name = p_product_name,
        image = p_image,
        price = p_price,
        description = p_description,
        category_id = p_category_id,
        modified_at = p_modified_at
    WHERE product_id = p_product_id;

    -- Check if the update affected any rows
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Product update failed. Product with the specified ID does not exist.';
    END IF;
END;
$$ LANGUAGE plpgsql;
