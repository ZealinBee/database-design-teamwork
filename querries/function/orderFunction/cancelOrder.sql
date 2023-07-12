-- Function to cancel order

CREATE OR REPLACE FUNCTION ecommerce.cancel_order(p_order_id INTEGER)
RETURNS VOID AS $$
DECLARE
    v_product_id INTEGER;
    v_product_quantity INTEGER;
    v_subtotal NUMERIC;
BEGIN
    SELECT product_id, product_quantity INTO v_product_id, v_product_quantity
    FROM ecommerce.order_details
    WHERE order_id = p_order_id;
    
    SELECT subtotal INTO v_subtotal
    FROM ecommerce.order
    WHERE order_id = p_order_id;
    
    DELETE FROM ecommerce.order_details
    WHERE order_id = p_order_id;
    
    UPDATE ecommerce.inventory
    SET total_quantity = total_quantity + v_product_quantity,
        modified_at = CURRENT_DATE
    WHERE product_id = v_product_id;
    
    UPDATE ecommerce.order
    SET subtotal = subtotal - v_subtotal,
        modified_at = CURRENT_DATE
    WHERE order_id = p_order_id;
    
    DELETE FROM ecommerce.order
    WHERE order_id = p_order_id;
    
    RETURN;
END;
$$ LANGUAGE plpgsql;

--SELECT ecommerce.cancel_order(2) deletes order and order detail from table 