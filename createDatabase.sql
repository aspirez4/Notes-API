CREATE DATABASE Notes;

use Notes;

CREATE TABLE notes (
	id INT NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	title VARCHAR(500), 
	content TEXT
);

CREATE TABLE labels (
	id INT NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	note_id INT,
	FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
	title VARCHAR(500)
);