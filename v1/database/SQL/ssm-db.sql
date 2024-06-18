CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE OR REPLACE FUNCTION user_code() RETURNS TEXT LANGUAGE plpgsql AS $$
  DECLARE
    random_code TEXT;
  BEGIN
    -- Generate a random code and check for uniqueness
    LOOP
      random_code := CONCAT(LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3));
      -- Check if the generated code is unique in your table
      EXIT WHEN NOT EXISTS (SELECT 1 FROM users WHERE code = random_code);
    END LOOP;
    RETURN random_code;
  END;
$$;

CREATE OR REPLACE FUNCTION school_code() RETURNS TEXT LANGUAGE plpgsql AS $$
  DECLARE
    random_code TEXT;
  BEGIN
    -- Generate a random code and check for uniqueness
    LOOP
      random_code := CONCAT(LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3));
      -- Check if the generated code is unique in your table
      EXIT WHEN NOT EXISTS (SELECT 1 FROM schools WHERE code = random_code);
    END LOOP;
    RETURN random_code;
  END;
$$;

-- CREATE USERS TABLE
CREATE TABLE users (
  code varchar(11) PRIMARY KEY UNIQUE DEFAULT user_code(),
  email varchar(250) UNIQUE NOT NULL,
  provider varchar(20) NOT NULL,
  providerdata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);


-- CREATE SCHOOLS TABLE
CREATE TABLE schools (
  code VARCHAR(11) PRIMARY KEY UNIQUE DEFAULT school_code(),
  name VARCHAR(126),
  email VARCHAR(250),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  license_end TIMESTAMPTZ DEFAULT NOW() + INTERVAL '30 days'
);


-- CREATE USERS_SCHOOLS TABLE
CREATE TABLE users_schools (
  user_code VARCHAR(11) NOT NULL REFERENCES users(code),
  school_code VARCHAR(11) NOT NULL REFERENCES schools(code),
  type VARCHAR(126) NOT NULL,
  rules JSONB DEFAULT '{}'::jsonb,
  status VARCHAR(126) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  -- Add a composite primary key to enforce uniqueness
  PRIMARY KEY (user_code, school_code)
);

-- CREATE TABLE link (
--    uid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--    user_code VARCHAR(11) NOT NULL REFERENCES users(code),
--    school_code VARCHAR(11) NOT NULL REFERENCES schools(code),
--    type VARCHAR(126) NOT NULL,
--    rules JSONB DEFAULT '{}'::jsonb,
--    status VARCHAR(126) NOT NULL,
--    created_at TIMESTAMPTZ DEFAULT NOW(),
--    CONSTRAINT link_unique_user_school UNIQUE (user_code, school_code) 
);

CREATE TABLE courses (
  uid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  teacher VARCHAR(126) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  school VARCHAR(11) REFERENCES schools(code) ON DELETE CASCADE
);

CREATE TABLE students (
  uid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(126) NOT NULL,
  birthday VARCHAR(10) NOT NULL,
  email VARCHAR(255),
  phone VARCHAR(20),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  school VARCHAR(11) REFERENCES schools(code) ON DELETE CASCADE
);

CREATE TABLE payments (
  uid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  school VARCHAR(11) REFERENCES schools(code),
  user_code VARCHAR(11) REFERENCES users(code),
  user_name VARCHAR(126) NOT NULL,
  student UUID REFERENCES students(uid),
  course UUID REFERENCES courses(uid),
  course_name VARCHAR(255) NOT NULL,
  price numeric NOT NULL,
  quantity integer NOT NULL,
  total numeric NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE lessons (
  uid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  school VARCHAR(11) REFERENCES schools(code),
  course UUID REFERENCES courses(uid),
  presents UUID[], -- Assuming an array of student UIDs
  absents UUID[],   -- Assuming an array of student UIDs
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TABLE timetables (
    uid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    school_code VARCHAR(11) REFERENCES schools(code) ON DELETE CASCADE,
    course_uid UUID REFERENCES courses(uid),
    day VARCHAR(20),
    week VARCHAR(20),
    date VARCHAR(20),
    start_at TIME NOT NULL,
    end_at TIME NOT NULL,
    type VARCHAR(120) DEFAULT 'default',
  created_at TIMESTAMPTZ DEFAULT NOW()
);