-- Function to place order

CREATE OR REPLACE FUNCTION ecommerce.place_order(
    p_user_id INTEGER,
    p_product_id INTEGER,
    p_product_quantity INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    v_order_id INTEGER;
    v_product_price NUMERIC;
    v_subtotal NUMERIC := 0;
    v_available_quantity INTEGER;
BEGIN
    SELECT total_quantity, price INTO v_available_quantity, v_product_price
    FROM ecommerce.inventory
    JOIN ecommerce.product ON inventory.product_id = product.product_id
    WHERE inventory.product_id = p_product_id;
    
    IF v_available_quantity < p_product_quantity THEN
        RAISE EXCEPTION 'Insufficient quantity in inventory.';
    END IF;
    
    v_subtotal := v_product_price * p_product_quantity;

    INSERT INTO ecommerce.order (user_id, subtotal, created_at, modified_at)
    VALUES (p_user_id, v_subtotal, CURRENT_DATE, CURRENT_DATE)
    RETURNING order_id INTO v_order_id;
    
    INSERT INTO ecommerce.order_details (order_id, product_id, product_quantity, created_at, modified_at)
    VALUES (v_order_id, p_product_id, p_product_quantity, CURRENT_DATE, CURRENT_DATE);
    
    UPDATE ecommerce.inventory
    SET total_quantity = total_quantity - p_product_quantity,
        modified_at = CURRENT_DATE
    WHERE product_id = p_product_id;
    
    RETURN v_order_id;
END;
$$ LANGUAGE plpgsql;

SELECT ecommerce.place_order(1, 7, 4) --If enough stock order will be placed, otherwise the message 'Insufficient quantity in inventory.' will be shown.