-- CREATE POSTGRESSQL CODE FUNCTION
CREATE OR REPLACE FUNCTION name_code() RETURNS TEXT LANGUAGE plpgsql AS $$
  DECLARE
    random_code TEXT;
  BEGIN
    -- Generate a random code and check for uniqueness
    LOOP
      random_code := CONCAT(LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3));
      -- Check if the generated code is unique in your table
      EXIT WHEN NOT EXISTS (SELECT 1 FROM table_name WHERE code = random_code);
    END LOOP;
    RETURN random_code;
  END;
$$;


-- CREATE USERS TABLE
CREATE TABLE users (
  code VARCHAR(11) PRIMARY KEY UNIQUE DEFAULT user_code(),
  email VARCHAR(250) UNIQUE NOT NULL,
  password TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);


-- CREATE SCHOOLS TABLE
CREATE TABLE schools (
  code VARCHAR(11) PRIMARY KEY UNIQUE DEFAULT school_code(),
  name VARCHAR(250),
  email VARCHAR(250),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  license_end TIMESTAMPTZ DEFAULT NOW() + INTERVAL '30 days'
);


-- CREATE USERS_SCHOOLS TABLE
CREATE TABLE users_schools (
  user_code VARCHAR(11) NOT NULL,
  school_code VARCHAR(11) NOT NULL,
  role VARCHAR(250) NOT NULL,
  status VARCHAR(250) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  -- Add a composite primary key to enforce uniqueness
  PRIMARY KEY (user_code, school_code)
);