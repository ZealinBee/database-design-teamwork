-- Function to place order

CREATE OR REPLACE FUNCTION ecommerce.place_order(
    p_user_id INTEGER, -- User ID placing the order
    p_product_id INTEGER, -- ID of the product being ordered
    p_product_quantity INTEGER -- Quantity of the product being ordered
)
RETURNS INTEGER AS $$
DECLARE
    v_order_id INTEGER; -- Variable to store the generated order ID
    v_product_price NUMERIC; -- Variable to store the price of the product
    v_subtotal NUMERIC := 0; -- Variable to store the calculated subtotal of the order
    v_available_quantity INTEGER; -- Variable to store the available quantity of the product in the inventory
BEGIN
    -- Retrieve the available quantity and price of the product from the inventory
    SELECT total_quantity, price INTO v_available_quantity, v_product_price
    FROM ecommerce.inventory
    JOIN ecommerce.product ON inventory.product_id = product.product_id
    WHERE inventory.product_id = p_product_id;
    
    -- Check if the available quantity is sufficient for the requested product quantity
    IF v_available_quantity < p_product_quantity THEN
        RAISE EXCEPTION 'Insufficient quantity in inventory.';
    END IF;
    
    -- Calculate the subtotal of the order by multiplying the product price with the requested quantity
    v_subtotal := v_product_price * p_product_quantity;

    -- Create a new order in the "order" table and retrieve the generated order ID
    INSERT INTO ecommerce."order" (user_id, subtotal, created_at, modified_at)
    VALUES (p_user_id, v_subtotal, CURRENT_DATE, CURRENT_DATE)
    RETURNING order_id INTO v_order_id;
    
    -- Insert the order details in the "order_details" table
    INSERT INTO ecommerce.order_details (order_id, product_id, product_quantity, created_at, modified_at)
    VALUES (v_order_id, p_product_id, p_product_quantity, CURRENT_DATE, CURRENT_DATE);
    
    -- Update the inventory by subtracting the ordered product quantity
    UPDATE ecommerce.inventory
    SET total_quantity = total_quantity - p_product_quantity,
        modified_at = CURRENT_DATE
    WHERE product_id = p_product_id;
    
    -- Return the generated order ID
    RETURN v_order_id;
END;
$$ LANGUAGE plpgsql;

-- Will create a new entry in the "order"table, adding the genereted order_id and given user_id. 
-- Will create an entry to the "order_details" table, adding the order_id, product_id and quantity 
SELECT ecommerce.place_order(1, 7, 4) 

-- If the quantity exceed the stock in inventory, will display error message:'Insufficient quantity in inventory.'
SELECT ecommerce.place_order(1, 5, 250) 