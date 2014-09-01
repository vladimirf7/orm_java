INSERT INTO "section" (section_title) VALUES ('Programming');

INSERT INTO "category" (category_title, section_id) VALUES ('Java', 1);
INSERT INTO "category" (category_title, section_id) VALUES ('C++', 1);
INSERT INTO "category" (category_title, section_id) VALUES ('PHP', 1);
INSERT INTO "category" (category_title, section_id) VALUES ('Python', 1);

INSERT INTO "post" (post_title, post_content, category_id) VALUES (
    '12 More Essential Skills for Software Architects: Technology Innovation',
    'This chapter from 12 More Essential Skills for Software Architects unveils one of the essential skills needed by a software architect: the ability to identify, assess, and infuse new and potentially disruptive technologies in a business-centric fashion.',
    1
);
INSERT INTO "post" (post_title, post_content, category_id) VALUES (
    'Building a Game from Scratch, Part 1: Setting the Foundation',
    'This article is the first in a multi-part series from the author of Sams Teach Yourself Scratch 2.0 in 24 Hours in which we create an online game by using the Scratch 2.0 educational programming language.',
    1
);
INSERT INTO "post" (post_title, post_content, category_id) VALUES (
    'How to Work with Variables, Data Types, and Arithmetic Expressions in the C Programming Language',
    'C has a rich variety of math operators that you can use to manipulate your data. In this chapter from Programming in C, 4th Edition, Stephen G. Kochan covers the int, float, double, char, and _Bool data types, modifying data types with short, long, and long long, the rules for naming variables, basic math operators and arithmetic expressions, and type casting.',
    2
);
INSERT INTO "post" (post_title, post_content, category_id) VALUES (
    'Angular JS Fundamental Concepts for Building Web Applications: Part 2',
    'In Part 2 of a two-part series, programming expert Jesse Smith continues his discussion of Angular JS by exploring modules and services.',
    3
);
INSERT INTO "post" (post_title, post_content, category_id) VALUES (
    'Preface to The Art of Computer Programming, Volume 3: Sorting and Searching, 2nd Edition',
    'To mark the release of the official multi-format ebook of Donald Knuths Art of Computer Programming, Volume 3: Sorting and Searching, 2nd Edition, we are pleased to make available the preface.',
    3
);
INSERT INTO "post" (post_title, post_content, category_id) VALUES (
    'Introduction to Programming in PHP, Fourth Edition',
    'Stephan G. Kochan provides some background about the C programming language and describes the contents and organization of the fourth edition of his book, Programming in C.',
    3
);
INSERT INTO "post" (post_title, post_content, category_id) VALUES (
    'Preface to 12 More Essential Skills for Software Architects',
    'Dave Hendricksen introduces his book, 12 More Essential Skills for Software Architects; learn the three sets of skills that will have the greatest impact on your ability to succeed and ascend.',
    4
);

INSERT INTO "tag" (tag_name) VALUES ('Beginner');
INSERT INTO "tag" (tag_name) VALUES ('Intermediate');
INSERT INTO "tag" (tag_name) VALUES ('Advanced');
INSERT INTO "tag" (tag_name) VALUES ('Math');
INSERT INTO "tag" (tag_name) VALUES ('Trick');
INSERT INTO "tag" (tag_name) VALUES ('New feature');
