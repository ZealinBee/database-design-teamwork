-- Function to register users
-- Install the pgcrypto extension before running command.
-- You can run the command `CREATE EXTENSION IF NOT EXISTS pgcrypto;` to install the extension.

CREATE OR REPLACE FUNCTION register_user(
    new_first_name TEXT,
    new_last_name TEXT,
    new_password_hash TEXT,
    new_email TEXT,
    new_phone TEXT,
    new_image TEXT,
    new_address TEXT,
    new_is_admin BOOLEAN
)
RETURNS VOID AS $$
DECLARE
    new_password_hash TEXT;
BEGIN
    IF new_email IS NULL OR new_email = '' THEN
        RAISE EXCEPTION 'Email cannot be empty.';
    END IF;

    -- Generates the password hash using the 'pgcrypto' extension
    new_password_hash := crypt(new_password, gen_salt('bf'));

    INSERT INTO "user" (first_name, last_name, password_hash, email, phone, image, address, is_admin)
    VALUES (new_first_name, new_last_name, new_password_hash, new_email, new_phone, new_image, new_address, new_is_admin);
END;
$$ LANGUAGE plpgsql;