-- update 1 review
CREATE OR REPLACE FUNCTION ecommerce.update_review(userId integer, reviewId integer, reviewText text)
RETURNS boolean
AS
$$
BEGIN
    IF NOT EXISTS (SELECT * FROM ecommerce.user WHERE user_id = userId) THEN
        RAISE EXCEPTION 'invalid id, user does not exist';
    ELSIF NOT EXISTS (SELECT * FROM ecommerce.review WHERE user_id = userId) THEN
		RAISE EXCEPTION 'user did not have any reviews';
    ELSIF NOT EXISTS (SELECT * FROM ecommerce.review WHERE review_id = reviewId) THEN
        RAISE EXCEPTION 'invalid id, review does not exist';
    ELSIF NOT EXISTS (SELECT * FROM ecommerce.review WHERE user_id = userId AND review_id = reviewId) THEN
        RAISE EXCEPTION 'user_id and review_id do not match';
    ELSE
        UPDATE ecommerce.review
        SET
            review_text = reviewText
        WHERE
            user_id = userId
            AND review_id = reviewId;
        RETURN TRUE;
    END IF;
END;
$$
LANGUAGE plpgsql;

-- testing functions
SELECT ecommerce.update_review(1, 4, 'Great product, recommend'); --should return true & update table
SELECT ecommerce.update_review(1, 2, 'Great product, recommend'); --should raise exception 'user_id and review_id do not match'