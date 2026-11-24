PRAGMA foreign_keys = ON;

BEGIN;
INSERT INTO category (categoryId, categoryName, categoryImage) VALUES
    (1, 'Classic Fiction', 'classic-fiction.jpg'),
    (2, 'Science Fiction', 'science-fiction.jpg'),
    (3, 'Memoir', 'memoir.jpg'),
    (4, 'Popular Science', 'popular-science.jpg');

INSERT INTO book (bookId, categoryId, title, author, isbn, price, image, readNow) VALUES
    (1, 1, 'Pride and Prejudice', 'Jane Austen', '9780141439518', 10.99, 'pride-and-prejudice.jpg', 1),
    (2, 1, 'Jane Eyre', 'Charlotte Bronte', '9780141441146', 11.99, 'jane-eyre.jpg', 0),
    (3, 1, 'Great Expectations', 'Charles Dickens', '9780141439563', 10.99, 'great-expectations.jpg', 0),
    (4, 2, 'Dune', 'Frank Herbert', '9780441172719', 10.99, 'dune.jpg', 1),
    (5, 2, 'The Martian', 'Andy Weir', '9780553418026', 17.99, 'the-martian.jpg', 0),
    (6, 2, 'The Left Hand of Darkness', 'Ursula K. Le Guin', '9780441478125', 10.99, 'left-hand-of-darkness.jpg', 0),
    (7, 3, 'Educated', 'Tara Westover', '9780399590528', 18.99, 'educated.jpg', 1),
    (8, 3, 'Born a Crime', 'Trevor Noah', '9780399588198', 18.99, 'born-a-crime.jpg', 0),
    (9, 3, 'Becoming', 'Michelle Obama', '9781524763138', 19.99, 'becoming.jpg', 0),
    (10, 4, 'A Brief History of Time', 'Stephen Hawking', '9780553380163', 18.99, 'brief-history-of-time.jpg', 1),
    (11, 4, 'The Selfish Gene', 'Richard Dawkins', '9780198788607', 18.99, 'selfish-gene.jpg', 0),
    (12, 4, 'The Immortal Life of Henrietta Lacks', 'Rebecca Skloot', '9781400052189', 18.99, 'henrietta-lacks.jpg', 0);
COMMIT;
