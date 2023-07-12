-- Function to update an existing user

CREATE OR REPLACE FUNCTION update_user(
    new_user_id INT,
    new_first_name TEXT,
    new_last_name TEXT,
    new_password TEXT,
    new_email TEXT,
    new_phone TEXT,
    new_image TEXT,
    new_address TEXT
)
RETURNS VOID AS $$
DECLARE
    new_password_hash TEXT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "user" WHERE user_id = new_user_id) THEN
        RAISE EXCEPTION 'User with ID % does not exist.', new_user_id;
    END IF;

    -- Generate the password hash if a new password is provided
    IF new_password IS NOT NULL AND new_password <> '' THEN
        new_password_hash := crypt(new_password, gen_salt('bf'));
    ELSE
        new_password_hash := (SELECT password_hash FROM "user" WHERE user_id = new_user_id);
    END IF;

    -- Update the user details excluding user_id and is_admin columns
    UPDATE "user"
    SET
        first_name = new_first_name,
        last_name = new_last_name,
        password_hash = new_password_hash,
        email = new_email,
        phone = new_phone,
        image = new_image,
        address = new_address
    WHERE user_id = new_user_id;
END;
$$ LANGUAGE plpgsql;