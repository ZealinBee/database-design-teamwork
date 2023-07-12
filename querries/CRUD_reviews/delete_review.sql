-- delete 1 review
CREATE OR REPLACE FUNCTION ecommerce.delete_review(userId integer, reviewId integer)
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
        DELETE FROM ecommerce.review
        WHERE
            user_id = userId
            AND review_id = reviewId;
        RETURN TRUE;
    END IF;
END;
$$
LANGUAGE plpgsql;

-- testing functions
SELECT ecommerce.delete_review(1, 4); --should return true and delete row from table
SELECT ecommerce.delete_review(1, 2); --should raise exception 'user_id and review_id do not match'
SELECT ecommerce.delete_review(5, 1); --should raise exception 'user did not have any reviews'