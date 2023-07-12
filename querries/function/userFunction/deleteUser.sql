-- Function to delete an existing user

CREATE OR REPLACE FUNCTION delete_user(
    delete_user_id INT
)
RETURNS VOID AS $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM "user" WHERE user_id = delete_user_id) THEN
            RAISE EXCEPTION 'User with ID % does not exist.', delete_user_id;
        END IF;

        DELETE FROM "user"
        WHERE user_id = delete_user_id;
    END;
$$ LANGUAGE plpgsql;