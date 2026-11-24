"""Corner Shelf Bookstore: a command-line interface for bookstore.db.

Every value typed by the user is passed to SQLite through ? placeholders
(parameterized queries); no SQL is built with string concatenation.
"""

import math
import sqlite3
from contextlib import closing
from pathlib import Path


DB_PATH = Path(__file__).with_name("bookstore.db")


def show_rows(cursor):
    """Print every row returned by a query, or a message if there are none."""
    rows = cursor.fetchall()
    if not rows:
        print("No results found.")
    for row in rows:
        print(" | ".join(str(value) for value in row))


def view_categories(cursor):
    """1. View all categories."""
    print("ID | Category | Image")
    show_rows(cursor.execute(
        "SELECT categoryId, categoryName, categoryImage FROM category ORDER BY categoryId"
    ))


def view_books(cursor):
    """2. View all books."""
    print("ID | Title | Author | ISBN | Price | Image | Read now | Category ID")
    show_rows(cursor.execute("""
        SELECT bookId, title, author, isbn, printf('%.2f', price), image, readNow, categoryId
        FROM book
        ORDER BY title
    """))


def view_books_in_category(cursor):
    """3. View all books in a given category (uses a JOIN)."""
    category_id = int(input("Category ID: "))
    print("ID | Title | Author | Category")
    show_rows(cursor.execute("""
        SELECT book.bookId, book.title, book.author, category.categoryName
        FROM book
        JOIN category ON book.categoryId = category.categoryId
        WHERE category.categoryId = ?
        ORDER BY book.title
    """, (category_id,)))


def search_by_title(cursor):
    """4. Search for books by a title keyword (case-insensitive)."""
    keyword = input("Title keyword: ").strip()
    if not keyword:
        raise ValueError("Enter a title keyword.")
    print("ID | Title | Author | Price")
    show_rows(cursor.execute("""
        SELECT bookId, title, author, printf('%.2f', price)
        FROM book
        WHERE instr(lower(title), lower(?)) > 0
        ORDER BY title
    """, (keyword,)))


def read_price(prompt):
    """Ask for a price and make sure it is a finite, nonnegative number."""
    price = float(input(prompt))
    if not math.isfinite(price) or price < 0:
        raise ValueError("Enter a finite, nonnegative price.")
    return price


def add_book(cursor):
    """5. Insert a new book."""
    category_id = int(input("Category ID: "))
    title = input("Title: ").strip()
    author = input("Author: ").strip()
    isbn = input("ISBN: ").strip()
    price = read_price("Price: ")
    image = input("Image filename: ").strip()
    read_now = int(input("Read now (0 or 1): "))
    cursor.execute("""
        INSERT INTO book (categoryId, title, author, isbn, price, image, readNow)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, (category_id, title, author, isbn, price, image, read_now))
    print(f"Book added with ID {cursor.lastrowid}.")


def update_price(cursor):
    """6. Update the price of a book given its book id."""
    book_id = int(input("Book ID: "))
    price = read_price("New price: ")
    cursor.execute("UPDATE book SET price = ? WHERE bookId = ?", (price, book_id))
    print("Price updated." if cursor.rowcount else "No book found.")


def delete_book(cursor):
    """7. Delete a book given its book id."""
    book_id = int(input("Book ID to delete: "))
    cursor.execute("DELETE FROM book WHERE bookId = ?", (book_id,))
    print("Book deleted." if cursor.rowcount else "No book found.")


def count_books_per_category(cursor):
    """9. Extra feature: count books in every category."""
    print("Category | Book count")
    show_rows(cursor.execute("""
        SELECT category.categoryName, COUNT(book.bookId)
        FROM category
        LEFT JOIN book ON category.categoryId = book.categoryId
        GROUP BY category.categoryId, category.categoryName
        ORDER BY category.categoryName
    """))


def main():
    """Connect to bookstore.db and run the menu loop until the user quits."""
    if not DB_PATH.is_file():
        print("bookstore.db is missing. Follow the setup instructions in README.md.")
        return

    actions = {
        "1": ("View all categories", view_categories),
        "2": ("View all books", view_books),
        "3": ("View books in a category", view_books_in_category),
        "4": ("Search books by title", search_by_title),
        "5": ("Add a new book", add_book),
        "6": ("Update a book price", update_price),
        "7": ("Delete a book", delete_book),
        "8": ("Quit", None),
        "9": ("Count books per category (extra feature)", count_books_per_category),
    }

    with closing(sqlite3.connect(DB_PATH)) as connection:
        connection.execute("PRAGMA foreign_keys = ON")
        cursor = connection.cursor()
        print("Welcome to the Corner Shelf Bookstore.")
        while True:
            print("\nBookstore Menu")
            for number, (label, _) in actions.items():
                print(f"{number}. {label}")

            try:
                choice = input("Choose an option: ").strip()
                if choice == "8":
                    print("Goodbye!")
                    break
                if choice not in actions:
                    print("Invalid option. Try again.")
                    continue
                # Each operation commits on success and rolls back on error.
                with connection:
                    actions[choice][1](cursor)
            except (ValueError, OverflowError) as error:
                print(f"Invalid input: {error}")
            except sqlite3.Error as error:
                print(f"Database error: {error}")
            except (EOFError, KeyboardInterrupt):
                print("\nGoodbye!")
                break


if __name__ == "__main__":
    main()
