#1	Mô tả yêu cầu dữ liệu: 
-  Bảng "Sách" gồm các trường:
  -	  ID_sach: Mã định danh duy nhất của sách.
  -   Tensach: Tên đầy đủ của sách.
  -   ID_tacgia: Tên tác giả hoặc các tác giả liên quan.
  -  	Theloai: Thể loại của sách (ví dụ: tiểu thuyết, kỹ thuật, học thuật, v.v.).
  -  	Soluong: Số lượng sách có sẵn trong thư viện.
  
-  	Bảng "Đọc giả" gồm các trường:
    -  	ID_docgia: Mã định danh duy nhất của đọc giả.
    -  	Tendocgia: Tên đầy đủ của đọc giả.
    -  	Diachi: Địa chỉ của đọc giả.
    -  	Email: Địa chỉ email của đọc giả.
    -  	SDT: Số điện thoại liên hệ của đọc giả.
    -  	TinhtrangDocgia: tình trạng đọc giả có nợ sách hay không.
  
-  	Bảng "Mượn sách" gồm các trường:
    -  	ID_muonsach: Khoá chính định danh duy nhất 1 đơn mượn sách
    -  	ID_sach: Liên kết với bảng "Sách" để định danh sách sách mà khách hàng mượn.
    -  	ID_docgia: Liên kết với bảng "Đọc giả" để định danh khách hàng mượn sách.
    -  	ID_nhanvien: Liên kết với bảng “Nhân viên” để định danh nhân viên cho mượn quyển sách đấy 
    -  	Ngaymuon: Ngày mà sách được mượn.
    -  	Ngayhethan: Ngày mà sách phải được trả về.
    -  	TinhtrangMuonsach: Tình trạng mượn sách đã trả hay chưa.
 
-	Bảng "Nhân viên" gồm các trường:
    -	ID_nhanvien: Mã định danh duy nhất của nhân viên.
    -	Tennhanvien: Tên đầy đủ của nhân viên.
    -	Chức vụ: Chức vụ công việc của nhân viên trong thư viện.
    -	Email: Email của nhân viên.
    -	Diachi : Địa chỉ của nhân viên
    -	Luong: Mức lương của nhân viên.
    
-	Bảng “Tác giả” gồm các trường:
    -	ID_tacgia: Mã định danh duy nhất của tác giả.
    -	Tentacgia: họ và tên đầy đủ của tác giả.
    -	Ngaysinh: Ngày tháng năm sinh của tác giả.
    -	Ngaymat: Ngày tháng năm mất của tác giả.
    -	Mota: Mô tả ngắn gọn về cuộc đời thể loại ưa thích của tác giả.

    ![image](https://github.com/manh21082002/Library-Distributed-Database./assets/100988312/7fa4f219-5452-4d1b-9e0b-9b0daf6d83d3)

