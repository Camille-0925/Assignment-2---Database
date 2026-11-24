# Corner Shelf Bookstore

**Author:** Minjun Cai

Corner Shelf is a small bookstore catalog with 12 real books across Classic Fiction,
Science Fiction, Memoir, and Popular Science. Each category starts with three books.
Prices are sample USD prices. Image fields store filenames for future use.

## Database setup

The workspace includes a populated SQLite database. To recreate the starter catalog,
run these commands from the project directory. Rebuilding resets both tables and
discards any catalog changes you have made.

```bash
sqlite3 -bail bookstore.db < createTables.sql &&
sqlite3 -bail bookstore.db < insertRows.sql
```

`createTables.sql` defines the tables and their constraints. `insertRows.sql`
adds the categories and books. Each book belongs to one category, has a unique
ISBN, has a nonnegative price, and uses 0 or 1 for its read-now flag.

## SQL queries

`queries.sql` lists every Part 3 SQL operation (create, read, update, delete,
and the extra feature). A `?` marks a value that comes from user input;
`bookstore_cli.py` runs the same queries as parameterized queries.

## Run the Python CLI

```bash
python3 bookstore_cli.py
```

Use options 1–4 to browse categories, browse books, filter by category ID, or
search by title keyword. Options 5–7 add a book, update a price, and delete a
book. Use the IDs shown by the listing options. Changes are saved after each
successful operation. Option 8 quits.

Option 9, **Count Books per Category**, shows the number of book records in every
category, including categories with zero books. It uses a LEFT JOIN with COUNT
of the book ID. User-supplied SQL values are passed through placeholders.
