create database alaughabet;

CREATE TABLE users(
	user_id INT NOT NULL AUTO_INCREMENT,
	user_name VARCHAR(100) NOT NULL,
	PRIMARY KEY ( user_id )
)

CREATE TABLE group_mappings(
	user_id INT NOT NULL,
	group_id INT NOT NULL,
	admin INT,
	PRIMARY KEY ( user_id, group_id )
);

CREATE TABLE groups(
	group_id INT NOT NULL AUTO_INCREMENT,
	group_name VARCHAR(255) NOT NULL,
	PRIMARY KEY ( group_id )
);

INSERT INTO users (user_name) VALUES ('johnflan');
INSERT INTO groups (group_name) VALUES ('Castletown flyboyz');
INSERT INTO group_mappings (user_id, group_id, admin) VALUES (1, 1, 1);
INSERT INTO users (user_name) VALUES ('Buzz');
INSERT INTO users (user_name) VALUES ('TheViper');
INSERT INTO users (user_name) VALUES ('Frenchtoast');
INSERT INTO users (user_name) VALUES ('TheBoo');
INSERT INTO users (user_name) VALUES ('Salmon');
INSERT INTO users (user_name) VALUES ('Eddie');
INSERT INTO users (user_name) VALUES ('Stateside');
INSERT INTO users (user_name) VALUES ('BigMick');
INSERT INTO users (user_name) VALUES ('CowboyLavin');
INSERT INTO group_mappings (user_id, group_id, admin) VALUES (2, 1, 0);
INSERT INTO group_mappings (user_id, group_id, admin) VALUES (3, 1, 0);
INSERT INTO group_mappings (user_id, group_id, admin) VALUES (4, 1, 0);
INSERT INTO group_mappings (user_id, group_id, admin) VALUES (5, 1, 0);
INSERT INTO group_mappings (user_id, group_id, admin) VALUES (6, 1, 0);
INSERT INTO group_mappings (user_id, group_id, admin) VALUES (7, 1, 0);
INSERT INTO group_mappings (user_id, group_id, admin) VALUES (8, 1, 0);
INSERT INTO group_mappings (user_id, group_id, admin) VALUES (9, 1, 0);
INSERT INTO group_mappings (user_id, group_id, admin) VALUES (10, 1, 0);


CREATE TABLE chat(
	message_id INT NOT NULL AUTO_INCREMENT,
	group_id INT NOT NULL,
	user_id INT NOT NULL,
	message VARCHAR(255),
	info INT DEFAULT 0,
	timestamp INT NOT NULL,
	PRIMARY KEY ( message_id )
);

INSERT INTO group_mappings (group_id, user_id, message, info, timestamp) VALUES (1, 2, 'Ahah ya c*nt.', 0, 1401303781);
INSERT INTO group_mappings (group_id, user_id, message, info, timestamp) VALUES (10, 2, 'Can anyone lend a score.', 0, 1401303825);


