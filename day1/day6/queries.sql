-- ==========================================
-- BLOCK 1: Setup Schema (Run this first)
-- ==========================================

CREATE TABLE users (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
email TEXT NOT NULL UNIQUE
);

CREATE TABLE notes (
id INTEGER PRIMARY KEY AUTOINCREMENT,
user_id INTEGER NOT NULL,
text TEXT NOT NULL,
created_at TEXT DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE tags (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL UNIQUE
);

CREATE TABLE note_tags (
note_id INTEGER NOT NULL,
tag_id INTEGER NOT NULL,
PRIMARY KEY (note_id, tag_id),
FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);


 -- ==========================================
 -- BLOCK 2: Get all of Amina's notes (Newest first)
 -- ==========================================

SELECT notes.text, notes.created_at
FROM notes
JOIN users ON notes.user_id = users.id
WHERE users.name = 'Amina'
ORDER BY notes.created_at DESC;


 -- ==========================================
 -- BLOCK 3: Get all notes tagged "urgent"
 -- ==========================================

SELECT notes.text
FROM notes
JOIN note_tags ON note_tags.note_id = notes.id
JOIN tags ON tags.id = note_tags.tag_id
WHERE tags.name = 'urgent';


-- ==========================================
-- BLOCK 4: Count how many notes each user has
-- ==========================================

SELECT users.name, COUNT(notes.id) AS note_count
FROM users
LEFT JOIN notes ON notes.user_id = users.id
GROUP BY users.id;

