# 1 Describe the data request:
- **Table "Sách" includes fields:**

     - ID_book: Unique identifier of the book.
     - Tensach: Full name of the book.
     - ID_tacgia: Name of author or related authors.
     - Theloai: Genre of the book (e.g. fiction, technical, academic, etc.).
     - Soluong: Number of books available in the library.
  
- **The "Đọc Giả" table includes the following fields:**
     - ID_docgia: Reader's unique identifier.
     - Tendocgia: Reader's full name.
     - Diachi: Reader's address.
     - Email: Reader's email address.
     - SDT: Reader's contact phone number.
     - TinhtrangDocgia: status of readers whether they owe books or not.
  
- **The "Mượn sách" table includes the following fields:**
     - ID_muonsach: Primary key that uniquely identifies a book loan order
     - ID_book: Links to the "Books" table to identify the list of books that customers borrow.
     - ID_docgia: Linked to the "Readers" table to identify customers who borrow books.
     - ID_nhanvien: Linked to the "Employee" table to identify the employee who lent that book
     - Phaomuon: The day the book was borrowed.
     - Doanhhethan: The date when the book must be returned.
     - TinhtrangMuonsach: Status of whether borrowed books have been returned or not.

- **The "Nhân viên" table includes the following fields:**
     - ID_nhanvien: Unique identifier of the employee.
     - Tenhanvien: Full name of the employee.
     - Position: Job position of library staff.
     - Email: Employee's email.
     - Diachi: Address of the employee
     - Salary: Salary of the employee.
    
- **The "Tác giả" table includes the following fields:**
     - ID_tacgia: Author's unique identifier.
     - Tentacgia: full name of the author.
     - Date of birth: Author's date of birth.
     - Evenmat: Date of death of the author.
     - Mota: Brief description of the author's favorite genre's life.

    ![image](https://github.com/manh21082002/Library-Distributed-Database./assets/100988312/7fa4f219-5452-4d1b-9e0b-9b0daf6d83d3)
# 2 Distributed design:
- There are 4 data stations: using link energy algorithm for vertical fragmentation and query frequency for horizontal fragmentation
- Two tables are selected for vertical fragmentation: employee table, reader table.
- Selected table with horizontal fragmentation: author table.
- Selected table derived horizontal fragmentation: book table
- Duplicate selected table: Borrow book
# 3 Control and manipulate data:

## "Sách" table.

**Create a book insert procdure with the following conditions:**

- The primary key of the book does not exist
- Author foreign key already exists
- Insert into the correct site needed.

**Create procedure delete_sach with the following conditions:**

- The book must exist to be deleted (primary key exists).
- Books that are being loaned cannot be deleted (a lock exists in the book loan table).
- Find the right site to delete.

## "Tác Giả" table

**Create procedure to insert author with the following conditions:**

- Check the primary key to see if it exists at the sites
- Insert data into the correct site as needed.

**Create procedure delete author with the following conditions:**

- The author must exist to delete (primary key exists)
- There must be no more books by the author in the book store (no foreign key exists in the books table)
- Find the correct site with deleted data to delete

## "Đọc Giả" Table:

**Create DOCGIA insert procedure with the following conditions:**

- No duplicate primary key.
- Insert correct information for fragments at sites.

**Create procedure delete docgia with the following conditions:**

- If the reader does not exist, do not delete (duplicate primary key).
- If the reader is borrowing the book, do not delete it (the foreign key still exists).
- Can delete data on all sites.
  
## "Nhân Viên" Table:

**Create procedure insert NHANVIEN with conditions**

- No duplicate primary key.
- Insert data into the correct pieces at the site.

**Create procedure delete NHANVIEN with the following conditions:**

- Check the primary key condition exists.
- Delete on all sites.

## "Mượn sách" table

**Create a return procudure with the following conditions:**
 
- Id_book must exist
- Change book borrowing status from 0 to 1

**Trigger insert for MUONSACH table with the following requirements:**

- Book loan codes cannot overlap with previous codes
- The fake reader code must exist in advance.
- The employee code must exist in advance.
- The book code must exist before
- The number of books must be greater than 0
- Check if the reader's condition is bad and do not lend
- Tinhtrangdocgia must be different from 0
- The number of books will decrease by 1 if the insert is successful



