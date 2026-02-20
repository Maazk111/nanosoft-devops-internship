-- Week7: Docker Volumes & Backup
CREATE TABLE IF NOT EXISTS students (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO students (name, email) VALUES
('Mohsin', 'mohsin.khan@example.com'),
('Sarah Ahmed', 'sarah.ahmed@example.com'),
('Hassan Raza', 'hassan.raza@example.com')
ON CONFLICT (email) DO NOTHING;
