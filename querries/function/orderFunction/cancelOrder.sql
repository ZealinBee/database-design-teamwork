-- Function to cancel order by order id

CREATE OR REPLACE FUNCTION ecommerce.cancel_order(
    p_order_id INTEGER, -- Order ID of the order
    p_user_id INTEGER -- User ID of the user trying to cancel the order
)
RETURNS VOID AS $$
DECLARE
    v_product_id INTEGER; -- Variable to store the product ID of the canceled order
    v_product_quantity INTEGER; -- Variable to store the product quantity of the canceled order
    v_subtotal NUMERIC; -- Variable to store the subtotal of the canceled order
    v_order_user_id INTEGER; -- Variable to store the user ID of the order
BEGIN
    -- Get the user ID for the order
    SELECT user_id INTO v_order_user_id
    FROM ecommerce."order"
    WHERE order_id = p_order_id;
    
    -- Check if the user is the one who made the order
    IF v_order_user_id = p_user_id THEN
        -- Get the product ID and quantity for the canceled order from the order_details table
        SELECT product_id, product_quantity INTO v_product_id, v_product_quantity
        FROM ecommerce.order_details
        WHERE order_id = p_order_id;
        
        -- Get the subtotal for the canceled order from the order table
        SELECT subtotal INTO v_subtotal
        FROM ecommerce."order"
        WHERE order_id = p_order_id;
        
        -- Delete order details associated with the canceled order
        DELETE FROM ecommerce.order_details
        WHERE order_id = p_order_id;
        
        -- Update inventory by adding back the canceled quantity
        UPDATE ecommerce.inventory
        SET total_quantity = total_quantity + v_product_quantity,
            modified_at = CURRENT_DATE
        WHERE product_id = v_product_id;
        
        -- Update the subtotal for the canceled order
        UPDATE ecommerce."order"
        SET subtotal = subtotal - v_subtotal,
            modified_at = CURRENT_DATE
        WHERE order_id = p_order_id;
        
        -- Delete the canceled order from the order table
        DELETE FROM ecommerce."order"
        WHERE order_id = p_order_id;
    END IF;
    
    RETURN;
END;
$$ LANGUAGE plpgsql;


-- Will delete entry from "order" table by order_id
-- Will delete entry from "order_details" table by order_id 
-- If the id does not match, the order will not cancel
SELECT ecommerce.cancel_order(2 , 1) 