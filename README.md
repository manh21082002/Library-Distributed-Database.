# 1	Mô tả yêu cầu dữ liệu:# 
-  **Bảng "Sách" gồm các trường:**

    - ID_sach: Mã định danh duy nhất của sách.
    - Tensach: Tên đầy đủ của sách.
    - ID_tacgia: Tên tác giả hoặc các tác giả liên quan.
    - Theloai: Thể loại của sách (ví dụ: tiểu thuyết, kỹ thuật, học thuật, v.v.).
    - Soluong: Số lượng sách có sẵn trong thư viện.
  
-  	**Bảng "Đọc giả" gồm các trường:**
    -  	ID_docgia: Mã định danh duy nhất của đọc giả.
    -  	Tendocgia: Tên đầy đủ của đọc giả.
    -  	Diachi: Địa chỉ của đọc giả.
    -  	Email: Địa chỉ email của đọc giả.
    -  	SDT: Số điện thoại liên hệ của đọc giả.
    -  	TinhtrangDocgia: tình trạng đọc giả có nợ sách hay không.
  
-  	**Bảng "Mượn sách" gồm các trường:**
    -  	ID_muonsach: Khoá chính định danh duy nhất 1 đơn mượn sách
    -  	ID_sach: Liên kết với bảng "Sách" để định danh sách sách mà khách hàng mượn.
    -  	ID_docgia: Liên kết với bảng "Đọc giả" để định danh khách hàng mượn sách.
    -  	ID_nhanvien: Liên kết với bảng “Nhân viên” để định danh nhân viên cho mượn quyển sách đấy 
    -  	Ngaymuon: Ngày mà sách được mượn.
    -  	Ngayhethan: Ngày mà sách phải được trả về.
    -  	TinhtrangMuonsach: Tình trạng mượn sách đã trả hay chưa.
 
-	**Bảng "Nhân viên" gồm các trường:**
    -	ID_nhanvien: Mã định danh duy nhất của nhân viên.
    -	Tennhanvien: Tên đầy đủ của nhân viên.
    -	Chức vụ: Chức vụ công việc của nhân viên trong thư viện.
    -	Email: Email của nhân viên.
    -	Diachi : Địa chỉ của nhân viên
    -	Luong: Mức lương của nhân viên.
    
-	**Bảng “Tác giả” gồm các trường:**
    -	ID_tacgia: Mã định danh duy nhất của tác giả.
    -	Tentacgia: họ và tên đầy đủ của tác giả.
    -	Ngaysinh: Ngày tháng năm sinh của tác giả.
    -	Ngaymat: Ngày tháng năm mất của tác giả.
    -	Mota: Mô tả ngắn gọn về cuộc đời thể loại ưa thích của tác giả.

    ![image](https://github.com/manh21082002/Library-Distributed-Database./assets/100988312/7fa4f219-5452-4d1b-9e0b-9b0daf6d83d3)
# 2	Thiết kế phân tán:
-    Có 4 trạm dữ liệu: sự dụng thuật toán năng lương liên kết để phân mảnh dọc và tần suất truy vấn đề phân mảnh ngang
-    Hai bảng được chọn phân mảnh dọc : bảng nhân viên, bảng đọc giả.
-    Bảng được chọn phân mảnh ngang: bảng tác giả.
-    Bảng được chọn phân mảnh ngang dẫn xuất: bảng sách
-    Bảng được chọn nhân bản : Mượn sách
# 3 Kiểm soát và thao tác dữ liệu:

## Bảng sách.
## Tạo procdure insert sách với các điều kiện sau :

-    Khoá chính của sách chưa tồn tại
-    Khoá ngoại tác giả đã tồn tại
-    Insert vào đúng site cần thiết.

## Tạo procedure delete_sach với các điều kiện sau:

-    Phải tồn tại sách thì mới xoá được ( tồn tại khoá chính).
-    Sách đang cho mượn thì không được xoá (tồn tại khoá tại bảng mượn sách).
-    Tìm được đúng site để xoá.

## Bảng tác giả
### Tạo procedure insert tác giả với các điều kiện sau:

-    Kiểm tra khoá chính xem đã tồn tại tại các site chưa
-    Insert dữ liệu vào đúng site cần thiết.

### Tạo procedure delete tác giả với các điều kiện sau:

-    Phải tồn tại tác giả mới xoá được (tồn tại khoá chính)
-    Phải không còn sách của tác giả trong kho sách (không tồn tại khoá ngoại tại bảng sách)
-    Tìm đến đúng site có dữ liệu xoá để xoá

## Bảng Đọc Giả:
### Tạo procedure insert DOCGIA với các điều kiện:

-    Không trùng khoá chính.
-    Insert đúng thông tin cho các mảnh tại các site.

### Tạo procedure delete docgia với các điều kiện:

-    Nếu mà đọc giả chưa tồn tại thì không xoá (trùng khoá chính).
-    Nếu đọc giả đang mượn sách thì không xoá (còn tồn tại khoá ngoại).
-    Xoá được dữ liệu ở tất cả các site.
  
## Bảng Nhân Viên:
### Tạo procedure insert NHANVIEN với các điều kiện

-    Không trùng khoá chính.
-    Insert dữ liệu vào đúng các mảnh tại site.

### Tạo procedure delete NHANVIEN với các điều kiện:

-    Kiểm tra điều kiện khoá chính tồn tại. 
-    Xoá ở tất cả các site.

## Bảng mượn sách
### Tạo procudure trả sách với các điệu kiện:
 
-    Id_mượn sách phải tồn tại
-    Chuyển tình trạng mượn sách từ 0 thành 1 

### Trigger insert cho bảng MUONSACH với các điều kiện yêu cầu sau:

-    Mã mượn sách không được trùng với các mã trước
-    Mã đọc giả phải tồn tại từ trước.
-    Mã nhân viên phải tồn tại từ trước.
-    Mã sách phải tồn tại từ trước
-    Số lượng sách phải lớn hơn 0
-    Kiểm tra tình trạng đọc giả xấu thì không cho mượn
-    Tinhtrangdocgia phải khác 0
-    Số lượng sách đó sẽ giảm đi 1 nếu insert thành công


