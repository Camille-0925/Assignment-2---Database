-- Part 3: SQL data operations for the Corner Shelf Bookstore.
-- A ? marks a value that comes from user input; bookstore_cli.py fills each
-- placeholder with a parameterized query (never with string concatenation).

PRAGMA foreign_keys = ON;

-- CREATE: insert a new book
INSERT INTO book (categoryId, title, author, isbn, price, image, readNow)
VALUES (?, ?, ?, ?, ?, ?, ?);

-- READ: view all categories
SELECT categoryId, categoryName, categoryImage
FROM category
ORDER BY categoryId;

-- READ: view all books
SELECT bookId, title, author, isbn, price, image, readNow, categoryId
FROM book
ORDER BY title;

-- READ: view all books in a given category (JOIN)
SELECT book.bookId, book.title, book.author, category.categoryName
FROM book
JOIN category ON book.categoryId = category.categoryId
WHERE category.categoryId = ?
ORDER BY book.title;

-- READ: search for books by a user-supplied title keyword (case-insensitive)
SELECT bookId, title, author, price
FROM book
WHERE instr(lower(title), lower(?)) > 0
ORDER BY title;

-- UPDATE: change the price of a book given its book id
UPDATE book SET price = ? WHERE bookId = ?;

-- DELETE: remove a book given its book id
DELETE FROM book WHERE bookId = ?;

-- EXTRA FEATURE: count books per category (includes empty categories)
SELECT category.categoryName, COUNT(book.bookId) AS bookCount
FROM category
LEFT JOIN book ON category.categoryId = book.categoryId
GROUP BY category.categoryId, category.categoryName
ORDER BY category.categoryName;
