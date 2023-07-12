-- read
-- get all reviews from a user
CREATE OR REPLACE FUNCTION ecommerce.get_all_reviews(userId integer)
RETURNS TABLE
(
	review_id integer,
	review_text text,
	product_name varchar(50),
	created_at date
)
AS
$$
BEGIN
    IF NOT EXISTS (SELECT * FROM ecommerce.user WHERE user_id = userId) THEN
        RAISE EXCEPTION 'invalid id, user does not exist';
    ELSE
		RETURN QUERY
        SELECT
            r.review_id,
            r.review_text,
            p.product_name,
            r.created_at
        FROM ecommerce.user u
        JOIN ecommerce.review r
        ON u.user_id = r.user_id
        JOIN ecommerce.product p
        ON r.product_id = p.product_id
        WHERE u.user_id = userId
        ORDER BY r.review_id;
	END IF;
END;
$$
LANGUAGE plpgsql;

-- testing functions
SELECT *
FROM
	ecommerce.get_all_reviews(1) --should return valid table

SELECT *
FROM
	ecommerce.get_all_reviews(5); --should return empty table

-- get 1 review from a user
CREATE OR REPLACE FUNCTION ecommerce.get_1_review(userId integer, reviewId integer)
RETURNS TABLE
(
	review_text text,
    product_id integer,
	product_name varchar(50),
	created_at date,
    modified_at date
)
AS
$$
BEGIN
    IF NOT EXISTS (SELECT * FROM ecommerce.user WHERE user_id = userId) THEN
        RAISE EXCEPTION 'invalid id, user does not exist';
	ELSIF NOT EXISTS (SELECT * FROM ecommerce.review WHERE user_id = userId) THEN
		RAISE EXCEPTION 'user did not have any reviews';
    ELSIF NOT EXISTS (SELECT * FROM ecommerce.review WHERE review_id = reviewId) THEN
        RAISE EXCEPTION 'invalid id, review does not exist';
    ELSE
		RETURN QUERY
        SELECT
            r.review_text,
            p.product_id,
            p.product_name,
            r.created_at,
            r.modified_at
        FROM ecommerce.user u
        JOIN ecommerce.review r
        ON u.user_id = r.user_id
        JOIN ecommerce.product p
        ON r.product_id = p.product_id
        WHERE
            u.user_id = userId
            AND r.review_id = reviewId;
	END IF;
END;
$$
LANGUAGE plpgsql;

-- testing functions
SELECT * 
FROM
	ecommerce.get_1_review(15, 1); --should raise exception 'invalid id, user does not exist'

SELECT * 
FROM
	ecommerce.get_1_review(6, 1); --should raise exception 'user did not have any reviews'

SELECT * 
FROM
	ecommerce.get_1_review(1, 7); --should raise exception 'invalid id, review does not exist';

SELECT * 
FROM
	ecommerce.get_1_review(1, 1); --should return valid table

SELECT * 
FROM
	ecommerce.get_1_review(1, 2); --should return empty table since user_id does not match with any review_id

