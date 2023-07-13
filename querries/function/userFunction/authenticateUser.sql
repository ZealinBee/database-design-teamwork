-- Function to authenticate users

CREATE OR REPLACE FUNCTION authenticate_user(
    auth_email TEXT,
    auth_password TEXT
)
RETURNS BOOLEAN AS $$
DECLARE
    old_password_hash TEXT;
BEGIN
    SELECT password_hash
    INTO old_password_hash
    FROM "user"
    WHERE email = auth_email;

    IF old_password_hash IS NOT NULL AND old_password_hash = crypt(auth_password, old_password_hash) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
