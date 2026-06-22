create database project;

use project;

/*creation of table*/
create table Users(
user_id int primary key auto_increment,
full_name varchar(100) not null,

email varchar(100) unique not null,
city varchar(100) not null,

registration_date date not null

);


create table Events(
event_id int primary key auto_increment,

title varchar(200) not null,
description text ,
city varchar(100) not null,
start_date datetime not null,
end_date datetime not null,
status enum ('upcoming','completed','cancelled'),
organizer_id int,
foreign key (organizer_id) references Users(user_id)
);


create table Sessions(
session_id int primary key auto_increment,
event_id int ,
foreign key(event_id) references Events(event_id),
title varchar(200) not null,

speaker_name varchar(100) not null,
start_time datetime not null,
end_time datetime not null
);



create table Registrations(
registration_id int primary key auto_increment,
 user_id int,
 
 foreign key(user_id) references Users(user_id),
 event_id int ,
  foreign key(event_id) references Events(event_id),
  registration_date date not null
 
);


create table Feedback(
feedback_id int primary key auto_increment,
user_id int ,
foreign key(user_id) references Users(user_id),
event_id int,
foreign key(event_id) references Events(event_id),
 rating int check(rating between 1 and 5),
 
 comments text,
 feedback_date date not null
);

create table Resources(

resource_id int primary key auto_increment,
event_id int,
foreign key(event_id) references Events(event_id),
resource_type ENUM ('pdf','image','link'),
resource_url VARCHAR(255) NOT NULL,
uploaded_at DATETIME NOT NULL
);

/* inserting values into tables */

insert into Users values
(1,"Alice Johnson", "alice@example.com","New York","2024-12-01"),
(2 ,"Bob Smith" ,"bob@example.com","Los Angeles","2024-12-05"),
(3 ,"Charlie Lee", "charlie@example.com" ,"Chicago" ,"2024-12-10"),
(4 ,"Diana King" ,"diana@example.com" ,"New York" ,"2025-01-15"),
(5 ,"Ethan Hunt", "ethan@example.com" ,"Los Angeles" ,"2025-02-01");


select * from Users;

INSERT INTO Events
(title, description, city, start_date, end_date, status, organizer_id)
VALUES
(
    'Tech Innovators Meetup',
    'A meetup for tech enthusiasts.',
    'New York',
    '2025-06-10 10:00:00',
    '2025-06-10 16:00:00',
    'upcoming',
    1
),
(
    'AI & ML Conference',
    'Conference on AI and ML advancements.',
    'Chicago',
    '2025-05-15 09:00:00',
    '2025-05-15 17:00:00',
    'completed',
    3
),
(
    'Frontend Development Bootcamp',
    'Hands-on training on frontend tech.',
    'Los Angeles',
    '2025-07-01 10:00:00',
    '2025-07-03 16:00:00',
    'upcoming',
    2
);

INSERT INTO Sessions
(event_id, title, speaker_name, start_time, end_time)
VALUES
(1, 'Opening Keynote', 'Dr. Tech', '2025-06-10 10:00:00', '2025-06-10 11:00:00'),
(1, 'Future of Web Dev', 'Alice Johnson', '2025-06-10 11:15:00', '2025-06-10 12:30:00'),
(2, 'AI in Healthcare', 'Charlie Lee', '2025-05-15 09:30:00', '2025-05-15 11:00:00'),
(3, 'Intro to HTML5', 'Bob Smith', '2025-07-01 10:00:00', '2025-07-01 12:00:00');

INSERT INTO Registrations
(user_id, event_id, registration_date)
VALUES
(1, 1, '2025-05-01'),
(2, 1, '2025-05-02'),
(3, 2, '2025-04-30'),
(4, 2, '2025-04-28'),
(5, 3, '2025-06-15');

INSERT INTO Feedback
(user_id, event_id, rating, comments, feedback_date)
VALUES
(3, 2, 4, 'Great insights!', '2025-05-16'),
(4, 2, 5, 'Very informative.', '2025-05-16'),
(2, 1, 3, 'Could be better.', '2025-06-11');

select * from Feedback;




INSERT INTO Resources
(event_id, resource_type, resource_url, uploaded_at)
VALUES
(1, 'pdf',
 'https://portal.com/resources/tech_meetup_agenda.pdf',
 '2025-05-01 10:00:00'),

(2, 'image',
 'https://portal.com/resources/ai_poster.jpg',
 '2025-04-20 09:00:00'),

(3, 'link',
 'https://portal.com/resources/html5_docs',
 '2025-06-25 15:00:00');


/*Exercises*/


-- 1
SELECT
    e.event_id,
    e.title,
    e.city,
    e.start_date,
    e.end_date
FROM Users u
JOIN Registrations r
    ON u.user_id = r.user_id
JOIN Events e
    ON r.event_id = e.event_id
WHERE u.user_id = 1
  AND u.city = e.city
  AND e.status = 'upcoming'
ORDER BY e.start_date;




-- 2
SELECT
    e.event_id,
    e.title,
    AVG(f.rating) AS avg_rating,
    COUNT(f.feedback_id) AS feedback_count
FROM Events e
JOIN Feedback f
    ON e.event_id = f.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(f.feedback_id) >= 10
ORDER BY avg_rating DESC;


-- 3


SELECT
    u.user_id,
    u.name
FROM Users u
WHERE u.user_id NOT IN (
    SELECT DISTINCT user_id
    FROM Registrations
    WHERE registration_date >= CURDATE() - INTERVAL 90 DAY
);




-- 4


SELECT
    e.event_id,
    e.title,
    COUNT(s.session_id) AS session_count
FROM Events e
JOIN Sessions s
    ON e.event_id = s.event_id
WHERE TIME(s.start_time) BETWEEN '10:00:00' AND '12:00:00'
GROUP BY e.event_id, e.title;





-- 5

SELECT
    e.city,
    COUNT(DISTINCT r.user_id) AS total_users
FROM Events e
JOIN Registrations r
    ON e.event_id = r.event_id
GROUP BY e.city
ORDER BY total_users DESC
LIMIT 5;


-- 6


SELECT
    e.event_id,
    e.title,
    COUNT(r.resource_id) AS total_resources
FROM Events e
LEFT JOIN Resources r
    ON e.event_id = r.event_id
GROUP BY e.event_id, e.title;



-- 7


SELECT
    u.name,
    e.title,
    f.rating,
    f.comments
FROM Feedback f
JOIN Users u
    ON f.user_id = u.user_id
JOIN Events e
    ON f.event_id = e.event_id
WHERE f.rating < 3;



-- 8

SELECT
    e.event_id,
    e.title,
    COUNT(s.session_id) AS total_sessions
FROM Events e
LEFT JOIN Sessions s
    ON e.event_id = s.event_id
WHERE e.status = 'upcoming'
GROUP BY e.event_id, e.title;


-- 9 

SELECT
    u.user_id,
    u.name,
    e.status,
    COUNT(e.event_id) AS total_events
FROM Users u
JOIN Events e
    ON u.user_id = e.organizer_id
GROUP BY u.user_id, u.name, e.status
ORDER BY u.user_id;


-- 10

SELECT DISTINCT e.event_id, e.title
FROM Events e
JOIN Registrations r ON e.event_id = r.event_id
LEFT JOIN Feedback f ON e.event_id = f.event_id
WHERE f.feedback_id IS NULL;



-- 11


SELECT registration_date,
       COUNT(DISTINCT user_id) AS new_users
FROM Registrations
WHERE registration_date >= CURDATE() - INTERVAL 7 DAY
GROUP BY registration_date
ORDER BY registration_date;



-- 12


SELECT e.event_id, e.title, COUNT(s.session_id) AS session_count
FROM Events e
JOIN Sessions s ON e.event_id = s.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(s.session_id) = (
    SELECT MAX(session_count)
    FROM (
        SELECT COUNT(*) AS session_count
        FROM Sessions
        GROUP BY event_id
    ) t
);


-- 13


SELECT e.city,
       ROUND(AVG(f.rating),2) AS avg_rating
FROM Events e
JOIN Feedback f ON e.event_id = f.event_id
GROUP BY e.city;



-- 14


SELECT e.event_id,
       e.title,
       COUNT(r.registration_id) AS registrations
FROM Events e
JOIN Registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.title
ORDER BY registrations DESC
LIMIT 3;



-- 15

SELECT
    s1.event_id,
    s1.session_id AS session1,
    s2.session_id AS session2
FROM Sessions s1
JOIN Sessions s2
ON s1.event_id = s2.event_id
AND s1.session_id < s2.session_id
AND s1.start_time < s2.end_time
AND s1.end_time > s2.start_time;


-- 16 

SELECT u.user_id, u.name
FROM Users u
LEFT JOIN Registrations r
ON u.user_id = r.user_id
WHERE u.created_at >= CURDATE() - INTERVAL 30 DAY
AND r.registration_id IS NULL;




-- 17

SELECT speaker_name,
       COUNT(*) AS total_sessions
FROM Sessions
GROUP BY speaker_name
HAVING COUNT(*) > 1;



-- 18

SELECT e.event_id,
       e.title
FROM Events e
LEFT JOIN Resources r
ON e.event_id = r.event_id
WHERE r.resource_id IS NULL;




-- 19


SELECT
    e.event_id,
    e.title,
    COUNT(DISTINCT r.registration_id) AS total_registrations,
    ROUND(AVG(f.rating),2) AS avg_rating
FROM Events e
LEFT JOIN Registrations r
ON e.event_id = r.event_id
LEFT JOIN Feedback f
ON e.event_id = f.event_id
WHERE e.status = 'completed'
GROUP BY e.event_id, e.title;


-- 20


SELECT
    u.user_id,
    u.name,
    COUNT(DISTINCT r.event_id) AS events_attended,
    COUNT(DISTINCT f.feedback_id) AS feedbacks_given
FROM Users u
LEFT JOIN Registrations r
ON u.user_id = r.user_id
LEFT JOIN Feedback f
ON u.user_id = f.user_id
GROUP BY u.user_id, u.name;


-- 21


SELECT
    u.user_id,
    u.name,
    COUNT(f.feedback_id) AS feedback_count
FROM Users u
JOIN Feedback f
ON u.user_id = f.user_id
GROUP BY u.user_id, u.name
ORDER BY feedback_count DESC
LIMIT 5;






-- 22

SELECT
    user_id,
    event_id,
    COUNT(*) AS registrations
FROM Registrations
GROUP BY user_id, event_id
HAVING COUNT(*) > 1;




-- 23



SELECT
    YEAR(registration_date) AS year,
    MONTH(registration_date) AS month,
    COUNT(*) AS registrations
FROM Registrations
WHERE registration_date >= CURDATE() - INTERVAL 12 MONTH
GROUP BY YEAR(registration_date),
         MONTH(registration_date)
ORDER BY year, month;



-- 24


SELECT
    e.event_id,
    e.title,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                s.start_time,
                s.end_time
            )
        ),2
    ) AS avg_duration_minutes
FROM Events e
JOIN Sessions s
ON e.event_id = s.event_id
GROUP BY e.event_id, e.title;




-- 25


SELECT
    e.event_id,
    e.title
FROM Events e
LEFT JOIN Sessions s
ON e.event_id = s.event_id
WHERE s.session_id IS NULL;


	









