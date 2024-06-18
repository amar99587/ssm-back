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

CREATE TABLE timetables (
    uid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    school_code VARCHAR(11) REFERENCES schools(code) ON DELETE CASCADE,
    course_uid UUID REFERENCES courses(uid),
    day VARCHAR(255),
    date VARCHAR(255),
    start_at TIME NOT NULL,
    end_at TIME NOT NULL,
    type VARCHAR(255) DEFAULT 'default',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- CREATE USERS TABLE
-- CREATE TABLE users (
--   code VARCHAR(11) PRIMARY KEY UNIQUE DEFAULT user_code(),
--   email VARCHAR(250) UNIQUE NOT NULL,
--   password TEXT NOT NULL,
--   created_at TIMESTAMPTZ DEFAULT NOW()
-- );

CREATE TABLE users (
  code          varchar(11) PRIMARY KEY UNIQUE DEFAULT user_code(),
  email         varchar(250) UNIQUE NOT NULL,
  provider      varchar(20) NOT NULL,
  providerdata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- CREATE SCHOOLS TABLE
CREATE TABLE schools (
  code VARCHAR(11) PRIMARY KEY UNIQUE DEFAULT school_code(),
  name VARCHAR(250),
  email VARCHAR(250),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  license_end TIMESTAMPTZ DEFAULT NOW() + INTERVAL '14 days'
);


-- CREATE USERS_SCHOOLS TABLE
CREATE TABLE users_schools (
  user_code VARCHAR(11) NOT NULL REFERENCES users(code),
  school_code VARCHAR(11) NOT NULL REFERENCES schools(code),
  type VARCHAR(250) NOT NULL,
  rules JSONB DEFAULT '{}'::jsonb,
  status VARCHAR(250) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  -- Add a composite primary key to enforce uniqueness
  PRIMARY KEY (user_code, school_code)
);

CREATE TABLE courses (
  uid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  teacher VARCHAR(255) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  school VARCHAR(11) REFERENCES schools(code) ON DELETE CASCADE
);

CREATE TABLE students (
  uid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
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
  user_name VARCHAR(255) NOT NULL,
  student UUID REFERENCES students(uid),
  course UUID REFERENCES courses(uid),
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



INSERT INTO students (name, birthday, email, phone, school)
SELECT
  arabic_names.name,
  FLOOR(RANDOM() * (2006 - 2000) + 2000)::TEXT || '-' || LPAD(FLOOR(RANDOM() * 12 + 1)::TEXT, 2, '0') || '-' || LPAD(FLOOR(RANDOM() * 28 + 1)::TEXT, 2, '0'),
  CASE
    WHEN FLOOR(RANDOM() * 2) = 1 THEN arabic_names.email
    ELSE NULL
  END,
  CASE
    WHEN FLOOR(RANDOM() * 2) = 1 THEN
      CASE
        WHEN arabic_names.phone_prefix = '05' THEN '05' || LPAD(FLOOR(RANDOM() * 1000000000)::TEXT, 9, '0')
        WHEN arabic_names.phone_prefix = '06' THEN '06' || LPAD(FLOOR(RANDOM() * 1000000000)::TEXT, 9, '0')
        WHEN arabic_names.phone_prefix = '07' THEN '07' || LPAD(FLOOR(RANDOM() * 1000000000)::TEXT, 9, '0')
      END
    ELSE NULL
  END,
  '360-c6a-20b' AS school
FROM
  (SELECT
    UNNEST(ARRAY[
  'Ahmed', 'Mohammed', 'Fatima', 'Amina', 'Youssef',
  'Noor', 'Layla', 'Omar', 'Ali', 'Sara',
  'Hassan', 'Aisha', 'Khaled', 'Lina', 'Tariq',
  'Noura', 'Ziad', 'Yara', 'Karim', 'Rana',
  'Bilal', 'Mona', 'Samir', 'Rima', 'Nabil',
  'Leila', 'Farid', 'Rania', 'Adel', 'Dina',
  'Omar', 'Amina', 'Rami', 'Samar', 'Walid',
  'Nadia', 'Mazen', 'Maya', 'Zakaria', 'Hoda',
  'Khalid', 'Nour', 'Hussein', 'Jasmine', 'Sami',
  'Hala', 'Tamer', 'Yasmin', 'Mahmoud', 'Rasha',
  'Tarek', 'Rana', 'Mustafa', 'Laila', 'Wael',
  'Amal', 'Ali', 'Lina', 'Karim', 'Layla',
  'Adnan', 'Salma', 'Riad', 'Maha', 'Hamza',
  'Dina', 'Kamal', 'Soraya', 'Raed', 'Mai',
  'Fadi', 'Lina', 'Imad', 'Sawsan', 'Fares',
  'Samar', 'Nader', 'Reem', 'Wael', 'Dalia',
  'Zakariya', 'Inas', 'Rafik', 'Nina', 'Maher',
  'Leila', 'Rami', 'Nadia', 'Yassin', 'Rima',
  'Ahmad', 'Rasha', 'Khaled', 'Noura', 'Amr'
]
) AS name,
    LOWER(UNNEST(ARRAY[
  'Ahmed', 'Mohammed', 'Fatima', 'Amina', 'Youssef',
  'Noor', 'Layla', 'Omar', 'Ali', 'Sara',
  'Hassan', 'Aisha', 'Khaled', 'Lina', 'Tariq',
  'Noura', 'Ziad', 'Yara', 'Karim', 'Rana',
  'Bilal', 'Mona', 'Samir', 'Rima', 'Nabil',
  'Leila', 'Farid', 'Rania', 'Adel', 'Dina',
  'Omar', 'Amina', 'Rami', 'Samar', 'Walid',
  'Nadia', 'Mazen', 'Maya', 'Zakaria', 'Hoda',
  'Khalid', 'Nour', 'Hussein', 'Jasmine', 'Sami',
  'Hala', 'Tamer', 'Yasmin', 'Mahmoud', 'Rasha',
  'Tarek', 'Rana', 'Mustafa', 'Laila', 'Wael',
  'Amal', 'Ali', 'Lina', 'Karim', 'Layla',
  'Adnan', 'Salma', 'Riad', 'Maha', 'Hamza',
  'Dina', 'Kamal', 'Soraya', 'Raed', 'Mai',
  'Fadi', 'Lina', 'Imad', 'Sawsan', 'Fares',
  'Samar', 'Nader', 'Reem', 'Wael', 'Dalia',
  'Zakariya', 'Inas', 'Rafik', 'Nina', 'Maher',
  'Leila', 'Rami', 'Nadia', 'Yassin', 'Rima',
  'Ahmad', 'Rasha', 'Khaled', 'Noura', 'Amr'
]
)) || '@email.com' AS email,
    UNNEST(ARRAY['05', '06', '07']) AS phone_prefix
  ) AS arabic_names
LIMIT 100;

-- open psql from cmd
-- 1 - cd C:\Program Files\PostgreSQL\15\bin
-- 2 - psql -h localhost -p 3000 -U postgres school
-- 3 - enter password