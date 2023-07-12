-- Function to update product

CREATE OR REPLACE FUNCTION update_product(
    product_id INT,
    product_name TEXT,
    image TEXT,
    price NUMERIC,
    description TEXT,
    category_id INT,
    modified_at date,
)
    RETURNS VOID AS $$
    BEGIN
        UPDATE product
        SET
            product_name = product_name,
            image = image,
            price = price,
            description = description,
            category_id = category_id,
            modified_at = modified_at,
        WHERE product_id = product_id;
    END;
$$ LANGUAGE plpgsql;