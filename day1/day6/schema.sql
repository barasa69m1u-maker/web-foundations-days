-- 1. Users Table
CREATE TABLE users (

id INTEGER PRIMARY KEY AUTOINCREMENT,

name TEXT NOT NULL,
email TEXT NOT NULL UNIQUE
);

 -- 2. Notes Table (One-to-Many relationship with users)



CREATE TABLE notes (
id INTEGER PRIMARY KEY AUTOINCREMENT,
user_id INTEGER NOT NULL,
text TEXT NOT NULL,
created_at TEXT DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Tags Table
CREATE TABLE tags (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL UNIQUE
);

-- 4. Note_Tags Join Table (Many-to-Many relationship)
CREATE TABLE note_tags (
note_id INTEGER NOT NULL,
tag_id INTEGER NOT NULL,
PRIMARY KEY (note_id, tag_id), -- composite primary key prevents duplicate tags on the same note
FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);
