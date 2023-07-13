-- create new review
CREATE OR REPLACE FUNCTION ecommerce.create_new_review(userId integer, productId integer, reviewText text)
RETURNS boolean
AS
$$
BEGIN
    IF NOT EXISTS (SELECT * FROM ecommerce.user WHERE user_id = userId) THEN
        RAISE EXCEPTION 'invalid id, user does not exist';
    ELSIF NOT EXISTS (SELECT * FROM ecommerce.product WHERE product_id = productId) THEN
        RAISE EXCEPTION 'invalid id, product does not exist';
    ELSE
        INSERT INTO ecommerce.review(user_id, product_id, review_text, created_at)
        VALUES (userId, productId, reviewText, CURRENT_DATE);
        RETURN TRUE;
    END IF;
END;
$$
LANGUAGE plpgsql;

-- testing functions
SELECT ecommerce.create_new_review(15, 2, 'new review'); --should raise exception 'invalid id, user does not exist'
SELECT ecommerce.create_new_review(1, 20, 'new review'); --should raise exception 'invalid id, product does not exist'
SELECT ecommerce.create_new_review(1, 2, 'new review'); --should return true, add new column into table review