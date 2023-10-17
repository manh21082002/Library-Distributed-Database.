--SITE2
use thuvien
--Phan manh doc
go
select ID_docgia, diachi,sdt  into DOCGIA_SITE2 from site1.thuvien.dbo.docgia

select ID_nhanvien, chucvu, diachi into NHANVIEN_SITE2 from site1.thuvien.dbo.nhanvien

go
-- Phan manh ngang
select * into TACGIA_SITE2 from site1.thuvien.dbo.tacgia where mota=N'Nhà thơ' and gioitinh=N'Nữ'

select s.* into SACH_SITE2 from site1.thuvien.dbo.sach s join TACGIA_SITE2 on s.ID_tacgia=TACGIA_SITE2.ID_tacgia

go
--test tất cả các mảnh
select * from SACH_SITE2
select * from NHANVIEN_SITE2
select * from DOCGIA_SITE2
select * from TACGIA_SITE2
select * from muonsach
go






--//////////////////////////////////////////////////////////////////
-- Tạo trigger insert cho bảng MUONSACH với các điều kiện sau:
-- + Mã đọc giả phải tồn tại từ trước.
-- + Mã nhân viên phải tồn tại từ trước.
-- + Mã sách phải tồn tại từ trước
-- + Số lượng sách phải lớn hơn 0
-- + Mã mượn sách không được trùng với các mã trước
drop trigger check_MUONSACH
create trigger check_MUONSACH on muonsach
instead of insert
as
begin
	begin tran
	set nocount on
	declare @idsach  varchar(4)
	declare @iddocgia varchar(4)
	declare @idnhanvien varchar(4)
	declare @idmuonsach varchar(6)
	declare @ngaymuon date
	declare @ngayhethan date
	declare @soluong int
	select @idmuonsach=ID_muonsach, @idsach=ID_sach, 
	@iddocgia=ID_docgia,@idnhanvien=ID_nhanvien, @ngaymuon=ngaymuon,@ngayhethan=ngayhethan from inserted
	----------check muon sach id
	if not exists (select 1 from muonsach where ID_muonsach=@idmuonsach)
	begin 
	------check docgia
		if not exists (select * from DOCGIA_SITE2 where ID_docgia=@iddocgia)
		begin 
			raiserror (N'đọc giả này chưa có, vui lòng thêm mới độc giả trước',16,1)
			rollback
			return
		end
		else
		begin
			if 0=(select tinhtrangdocgia from site1.thuvien.dbo.DOCGIA_SITE1 where ID_docgia=@iddocgia)
			begin
				raiserror (N'độc giả này hiện đang trong tình trạng xấu, hãy xem xét lại',16,1)
				rollback
				return
			end
		end
		------check nhan vien
		if not exists (select * from NHANVIEN_SITE2 where ID_nhanvien=@idnhanvien)
		begin 
			raiserror (N'ID nhân viên không đúng, vui lòng nhập lại id nhân viên',16,1)
			rollback
			return
		end 
		-------------------check sach
		if exists (select ID_sach  from  SITE1.thuvien.dbo.SACH_SITE1 where ID_sach=@idsach)
		begin
			select @soluong=soluong  from  SITE1.thuvien.dbo.SACH_SITE1 where ID_sach=@idsach
			if (@soluong=0) 
			begin
				raiserror (N'sách này hiện không còn trong kho để cho mượn',16,1)
				rollback
				return
			end
			else
			begin
				update SITE1.thuvien.dbo.SACH_SITE1 
				set soluong=soluong - 1 where ID_sach=@idsach
			end
		end
		-------------------------------------
		else 
		begin
			if exists (select ID_sach  from  SACH_SITE2 where ID_sach=@idsach)
			begin
				select @soluong=soluong  from  SACH_SITE2 where ID_sach=@idsach
				if (@soluong=0)
				begin
					raiserror (N'sách này hiện không còn trong kho để cho mượn',16,1)
					rollback
					return
				end
				else--
				begin
					update SACH_SITE2 
					set soluong=soluong - 1 where ID_sach=@idsach
				end
			end
			-----------------------------------
			else 
			begin
				if exists (select ID_sach from  SITE3.thuvien.dbo.SACH_SITE3 where ID_sach=@idsach)
				begin
					select @soluong=soluong  from  SITE3.thuvien.dbo.SACH_SITE3 where ID_sach=@idsach
					if (@soluong=0)
					begin
						raiserror (N'sách này hiện không còn trong kho để cho mượn',16,1)
						rollback
						return
					end
					else--
					begin
						update SITE3.thuvien.dbo.SACH_SITE3
						set soluong=soluong - 1 where ID_sach=@idsach
					end
				end
				else
				begin
					if exists (select ID_sach from  SITE4.thuvien.dbo.SACH_SITE4 where ID_sach=@idsach)
					begin
						select @soluong=soluong  from  SITE4.thuvien.dbo.SACH_SITE4 where ID_sach=@idsach
						if (@soluong=0)
						begin
							raiserror (N'sách này hiện không còn trong kho để cho mượn',16,1)
							rollback
							return
						end
						else--
						begin
							update SITE4.thuvien.dbo.SACH_SITE4
							set soluong=soluong - 1 where ID_sach=@idsach
						end
					end
					else
					begin
						raiserror (N'không có sách này trong kho tàng văn học việt nam',16,1)
						rollback
						return
					end
				end
				--------------
			end
		end
	end
	else
	begin
		raiserror (N'trùng id mượn sách, không thể thêm mới',16,1)
		rollback
		return
	end
	insert into muonsach(ID_muonsach,ID_sach,ID_docgia,ID_nhanvien,ngaymuon,ngayhethan,tinhtrangmuonsach) 
	values (@idmuonsach,@idsach,@iddocgia,@idnhanvien,@ngaymuon,@ngayhethan,0)
	commit tran
end
-- ===================================================================
-- test kiểm tra điều kiện mã đọc giả chưa tồn tại
insert into muonsach (ID_muonsach,ID_sach,ID_docgia,ID_nhanvien,ngaymuon,ngayhethan,tinhtrangmuonsach)
values ('MS25','S010','DG10','NV07','2023-06-18','2023-06-30',0)

-- test kiểm tra điều kiện mã nhân viên
insert into muonsach (ID_muonsach,ID_sach,ID_docgia,ID_nhanvien,ngaymuon,ngayhethan,tinhtrangmuonsach)
values ('MS21','S001','DG01','NV09','2023-06-18','2023-06-30',0)

-- test kiểm tra điều kiện mã sách
insert into muonsach (ID_muonsach,ID_sach,ID_docgia,ID_nhanvien,ngaymuon,ngayhethan,tinhtrangmuonsach)
values ('MS21','S100','DG01','NV07','2023-06-18','2023-06-30',0)

-- test kiểm tra điều kiệm mã mượn sách
insert into muonsach (ID_muonsach,ID_sach,ID_docgia,ID_nhanvien,ngaymuon,ngayhethan,tinhtrangmuonsach)
values ('MS01','S001','DG01','NV07','2023-06-18','2023-06-30',0)

-- test kiểm tra điều kiện số lượng > 0
EXECUTE insert_sach 'S042', 'TG02', N'Tên sách', N'Thể loại', 0;
insert into muonsach (ID_muonsach,ID_sach,ID_docgia,ID_nhanvien,ngaymuon,ngayhethan,tinhtrangmuonsach)
values ('MS22','S042','DG01','NV01','2023-06-18','2023-06-30',0)
--================================================================================================
go






go
-- Tạo procedure insert tác giả với các điều kiện sau
-- + kiểm tra khoá chính xem đã tồn tại tại các site chưa
-- + insert vào đúng site dữ liệu.
CREATE PROCEDURE insert_Tacgia (
    @ID_tacgia varchar(4),
    @tentacgia nvarchar(40),
	@ngaysinh date,
	@ngaymat date,
	@mota nvarchar(1000),
	@gioitinh nvarchar(5)
)
AS
BEGIN
    -- Kiểm tra khóa chính trên tất cả các site
    IF EXISTS (
        SELECT 1
        FROM (select * from TACGIA_SITE2
		union ALL select * from SITE1.thuvien.dbo.TACGIA_SITE1 
		union ALL select * from SITE3.thuvien.dbo.TACGIA_SITE3 
		union ALL select * from SITE4.thuvien.dbo.TACGIA_SITE4 ) as s
        WHERE s.ID_tacgia = @ID_tacgia
    )
    BEGIN
        RAISERROR(N'Khóa chính đã tồn tại trên một site khác!', 16, 1)
        RETURN
    END

    -- Chèn dữ liệu vào site thích hợp

    IF @mota = N'Nhà thơ' and @gioitinh= N'Nam'
    BEGIN
        INSERT INTO SITE1.thuvien.dbo.TACGIA_SITE1(ID_tacgia, tentacgia, ngaysinh, ngaymat, mota, gioitinh)
        VALUES (@ID_tacgia, @tentacgia, @ngaysinh, @ngaymat, @mota, @gioitinh)
		PRINT N'Dữ liệu đã được chèn thành công vào site 1'

    END

    ELSE IF  @mota = N'Nhà thơ' and @gioitinh= N'Nữ'
    BEGIN
        INSERT INTO TACGIA_SITE2 (ID_tacgia, tentacgia, ngaysinh, ngaymat, mota, gioitinh)
        VALUES (@ID_tacgia, @tentacgia, @ngaysinh, @ngaymat, @mota, @gioitinh)
		PRINT N'Dữ liệu đã được chèn thành công vào site 2'

    END

	ELSE IF  @mota = N'Nhà văn' and @gioitinh= N'Nam'
    BEGIN
        INSERT INTO SITE3.thuvien.dbo.TACGIA_SITE3 (ID_tacgia, tentacgia, ngaysinh, ngaymat, mota, gioitinh)
        VALUES (@ID_tacgia, @tentacgia, @ngaysinh, @ngaymat, @mota, @gioitinh)
		PRINT N'Dữ liệu đã được chèn thành công vào site 3'

    END

	ELSE IF  @mota = N'Nhà văn' and @gioitinh= N'Nữ'
    BEGIN
        INSERT INTO SITE4.thuvien.dbo.TACGIA_SITE4 (ID_tacgia, tentacgia, ngaysinh, ngaymat, mota, gioitinh)
        VALUES (@ID_tacgia, @tentacgia, @ngaysinh, @ngaymat, @mota, @gioitinh)
		PRINT N'Dữ liệu đã được chèn thành công vào site 4'

    END
END
go
--=============================================================================
--test điều kiện khoá chính
EXECUTE insert_Tacgia 'TG01', N'Tác giả 1', '1990-01-01', NULL, N'Nhà thơ', N'Nữ';
-- test insert thành công 
EXECUTE insert_Tacgia 'TG18', N'Tác giả 1', '1990-01-01', NULL, N'Nhà thơ', N'Nam';
-- ==============================================================================
go



go
-- Tạo procdure insert sách với các điều kiện L
-- + khoá chính của sách chưa tồn tại
-- + khoá ngoại tác giả đã tồn tại
-- + insert vào đúng site cần thiết
create procedure insert_sach(
	@ID_sach varchar(4),
	@ID_tacgia varchar(4),
	@tensach nvarchar(40),
	@theloai nvarchar(40),
	@solong int
)
as
begin
	if exists (SELECT 1
        FROM (select * from SACH_SITE2
		union ALL select * from SITE1.thuvien.dbo.SACH_SITE1 
		union ALL select * from SITE3.thuvien.dbo.SACH_SITE3 
		union ALL select * from SITE4.thuvien.dbo.SACH_SITE4 ) as s
        WHERE s.ID_sach = @ID_sach
	)
	BEGIN
        RAISERROR(N'Khóa chính đã tồn tại trên một site khác!', 16, 1)
        RETURN
    END
	
	IF not EXISTS (
        SELECT 1
        FROM (select * from TACGIA_SITE2
		union ALL select * from SITE1.thuvien.dbo.TACGIA_SITE1 
		union ALL select * from SITE3.thuvien.dbo.TACGIA_SITE3 
		union ALL select * from SITE4.thuvien.dbo.TACGIA_SITE4 ) as s
        WHERE s.ID_tacgia = @ID_tacgia
    )
    BEGIN
        RAISERROR(N'Tác giả chưa tồn tại hoặc đã sai ID_tacgia!', 16, 1)
        RETURN
    END

	if exists (select 1 from TACGIA_SITE2 t where t.ID_tacgia=@ID_tacgia)
	begin
		insert into SACH_SITE2(ID_sach,ID_tacgia,tensach,theloai,soluong)
		values (@ID_sach,@ID_tacgia,@tensach,@theloai,@solong)
		PRINT N'Dữ liệu đã được chèn thành công vào site 2'
	end

	else if exists (select 1 from SITE1.thuvien.dbo.TACGIA_SITE1 t where t.ID_tacgia=@ID_tacgia)
	begin
		insert into SITE1.thuvien.dbo.SACH_SITE1(ID_sach,ID_tacgia,tensach,theloai,soluong)
		values (@ID_sach,@ID_tacgia,@tensach,@theloai,@solong)
		PRINT N'Dữ liệu đã được chèn thành công vào site 1'
	end

	else if exists (select 1 from SITE3.thuvien.dbo.TACGIA_SITE3 t where t.ID_tacgia=@ID_tacgia)
	begin
		insert into SITE3.thuvien.dbo.SACH_SITE3(ID_sach,ID_tacgia,tensach,theloai,soluong)
		values (@ID_sach,@ID_tacgia,@tensach,@theloai,@solong)
		PRINT N'Dữ liệu đã được chèn thành công vào site 3'
	end

	else if exists (select 1 from SITE4.thuvien.dbo.TACGIA_SITE4 t where t.ID_tacgia=@ID_tacgia)
	begin
		insert into SITE4.thuvien.dbo.SACH_SITE4(ID_sach,ID_tacgia,tensach,theloai,soluong)
		values (@ID_sach,@ID_tacgia,@tensach,@theloai,@solong)
		PRINT N'Dữ liệu đã được chèn thành công vào site 4'
	end
end
--=============================================================
-- test điều kiện khoá chính trùng
EXECUTE insert_sach 'S001', 'TG02', N'Tên sách', N'Thể loại', 10;
-- test điều kiện tác giả chưa tồn tại
EXECUTE insert_sach 'S999', 'TG18', N'Tên sách', N'Thể loại', 10; 
-- insert thành công
EXECUTE insert_sach 'S999', 'TG02', N'Tên sách', N'Thể loại', 10; 
go



go
--====================================================================
-- tạo procedure delete_sach với các điều kiền:
-- + phải tồn tại sách thì mới xoá được
-- + sách đang cho mượn thì không được xoá (tồn tại khoá tại bảng mượn sách)
-- + tìm được đúng site để xoá
create PROCEDURE delete_sach (
    @ID_sach varchar(4)
)
AS
BEGIN
	IF not EXISTS (
			SELECT 1
			FROM (select * from SACH_SITE2
			union ALL select * from SITE1.thuvien.dbo.SACH_SITE1 
			union ALL select * from SITE3.thuvien.dbo.SACH_SITE3 
			union ALL select * from SITE4.thuvien.dbo.SACH_SITE4 ) as s
			WHERE s.ID_sach = @ID_sach
		)
		begin
			RAISERROR(N'Khóa chính không tồn tại trong bảng Sách!', 16, 1)
			RETURN
		END
    -- Kiểm tra sự tồn tại của khóa chính trong bảng MUONSACH
    IF EXISTS (
        SELECT 1
        FROM MUONSACH
        WHERE ID_sach = @ID_sach
    )
    BEGIN
        RAISERROR(N'Khóa chính tồn tại trong bảng MUONSACH!', 16, 1)
        RETURN
    END

    -- TÌM đến đúng site để xoá dữ liệu 
	if exists ( select 1 from SACH_SITE2 where ID_sach = @ID_sach)
	begin
		DELETE FROM SACH_SITE2
		WHERE ID_sach = @ID_sach
		PRINT N'Dữ liệu đã được xóa thành công từ bảng SACH_site2'
	end
	else if exists ( select 1 from SITE1.thuvien.dbo.SACH_SITE1 where ID_sach = @ID_sach)
	begin
		DELETE FROM SITE1.thuvien.dbo.SACH_SITE1 
		WHERE ID_sach = @ID_sach
		PRINT N'Dữ liệu đã được xóa thành công từ bảng SACH_site1'
	end
	else if exists ( select 1 from SITE3.thuvien.dbo.SACH_SITE3 where ID_sach = @ID_sach)
	begin
		DELETE FROM SITE3.thuvien.dbo.SACH_SITE3 
		WHERE ID_sach = @ID_sach
		PRINT N'Dữ liệu đã được xóa thành công từ bảng SACH_site3'
	end
	else if exists ( select 1 from SITE4.thuvien.dbo.SACH_SITE4 where ID_sach = @ID_sach)
	begin
		DELETE FROM SITE4.thuvien.dbo.SACH_SITE4 
		WHERE ID_sach = @ID_sach
		PRINT N'Dữ liệu đã được xóa thành công từ bảng SACH_site4'
	end
END
--=================================================
--test điều kiện sách chưa tồn tại
exec delete_sach 'S999'
-- test kiêu kiện sách đang cho mượn
exec delete_sach 'S001'
-- xoá sách thành công
EXECUTE delete_sach 'S999'
go
--===============================================================




go
-- tạo procedure delete tác giả với các điều kiện sau:
-- + phải tồn tại tác giả mới xoá được (tồn tại khoá chính)
-- + phải không còn sách của tác giả trong kho sách (không tồn tại khoá ngoại tại bảng sách)
-- + tìm đến đúng site có dữ liệu xoá để xoá
create PROCEDURE delete_tacgia (
    @ID_tacgia varchar(4)
)
AS
BEGIN
		IF not EXISTS (
			SELECT 1
			FROM (select * from TACGIA_SITE2
				union ALL select * from SITE1.thuvien.dbo.TACGIA_SITE1
			union ALL select * from SITE3.thuvien.dbo.TACGIA_SITE3 
			union ALL select * from SITE4.thuvien.dbo.TACGIA_SITE4 ) as s
			WHERE s.ID_tacgia = @ID_tacgia
		)
		begin
			RAISERROR(N'Khóa chính không tồn tại trong bảng tacgia!', 16, 1)
			RETURN
		END
    -- Kiểm tra sự tồn tại của khóa chính trong bảng MUONSACH
    IF EXISTS (
        SELECT 1
        FROM (select * from SACH_SITE2
		union ALL select * from SITE1.thuvien.dbo.SACH_SITE1 
		union ALL select * from SITE3.thuvien.dbo.SACH_SITE3 
		union ALL select * from SITE4.thuvien.dbo.SACH_SITE4 ) as s
        WHERE s.ID_tacgia = @ID_tacgia
    )
	begin
        RAISERROR(N'Khóa chính tồn tại trong bảng Sách!', 16, 1)
        RETURN
    END

    -- TÌM đến đúng site để xoá dữ liệu 
	if exists ( select 1 from TACGIA_SITE2 where ID_tacgia = @ID_tacgia)
	begin
		DELETE FROM TACGIA_SITE2
		WHERE ID_tacgia = @ID_tacgia
		PRINT N'Dữ liệu đã được xóa thành công từ bảng TACGIA_SITE2'
	end
	else if exists ( select 1 from SITE1.thuvien.dbo.TACGIA_SITE1 where ID_tacgia = @ID_tacgia)
	begin
		DELETE FROM SITE1.thuvien.dbo.TACGIA_SITE1 
		WHERE ID_tacgia = @ID_tacgia
		PRINT N'Dữ liệu đã được xóa thành công từ bảng TACGIA_SITE1'
	end
	else if exists ( select 1 from SITE3.thuvien.dbo.TACGIA_SITE3 where ID_tacgia = @ID_tacgia)
	begin
		DELETE FROM SITE3.thuvien.dbo.TACGIA_SITE3 
		WHERE ID_tacgia = @ID_tacgia
		PRINT N'Dữ liệu đã được xóa thành công từ bảng TACGIA_SITE3'
	end
	else if exists ( select 1 from SITE4.thuvien.dbo.TACGIA_SITE4 where ID_tacgia = @ID_tacgia)
	begin
		DELETE FROM SITE4.thuvien.dbo.TACGIA_SITE4 
		WHERE ID_tacgia = @ID_tacgia
		PRINT N'Dữ liệu đã được xóa thành công từ bảng TACGIA_SITE4'
	end
END
--==================================================
--test điều kiện khoá chính chưa tồn tại
exec delete_tacgia 'TG99'
--test điều kiện khoá chính tồn tại trong bảng sách
exec delete_tacgia 'TG01'
-- xoá thành công
exec delete_tacgia 'TG18'
go
--==============================================








go
--Tạo insert DOCGIA với các điều kiện:
-- + không trùng khoá chính.
-- + insert đúng thông tin cho các mảnh dọc
alter procedure insert_docgia 
	(@ID_docgia varchar(4),
	@tendocgia nvarchar(40),
	@Diachi nvarchar(100),
	@email varchar(40),
	@sdt varchar(10),
	@tinhtrangdocgia binary)
as 
begin
	if exists (select * from site1.thuvien.dbo.DOCGIA_SITE1 where ID_docgia=@ID_docgia)
	begin
		raiserror ('trung ID_docgia, khong the them moi',16,1)
		return
	end
	else
	begin
	
		insert into site1.thuvien.dbo.DOCGIA_SITE1 (ID_docgia,tendocgia,email,tinhtrangdocgia)
		values (@ID_docgia,@tendocgia,@email,@tinhtrangdocgia)
		
		insert into site3.thuvien.dbo.DOCGIA_SITE3(ID_docgia,tendocgia,email,tinhtrangdocgia)
		values (@ID_docgia,@tendocgia,@email,@tinhtrangdocgia)
		insert into DOCGIA_SITE2(ID_docgia,diachi,sdt)
		values (@ID_docgia,@Diachi,@sdt)
		insert into site4.thuvien.dbo.DOCGIA_SITE4(ID_docgia,diachi,sdt)
		values (@ID_docgia,@Diachi,@sdt)
		print (N'insert thành công vào tất cả các site')
		
	end
end
--================================================
--test điều kiện khoá chính
exec insert_docgia 'DG01',N'Phạm Quốc Hưng','new york','phamquochung019@gmail.com','0945425765',1
-- insert thành công
exec insert_docgia 'DG13',N'Phạm Quốc Hưng','new york','phamquochung019@gmail.com','0945425765',1
--================================================
go




go
--procedure delete docgia với các điều kiện:
-- + nếu mà đọc giả chưa tồn tại thì không xoá (trùng khoá chính)
-- + nếu đọc giả đang mượn sách thì không xoá (còn tồn tại khoá ngoại)
-- + xoá được dữ liệu ở tất cả các site

alter procedure delete_docgia @id_docgia varchar(4)--not done
as
begin
	if not exists (select * from site1.thuvien.dbo.DOCGIA_SITE1 where ID_docgia=@id_docgia)
	begin
		raiserror (N'không tồn tại mã đọc  giả này, vui lòng kiểm tra lại',16,1)
		return
	end
	else 
	begin
		if exists (select * from muonsach where ID_docgia=@id_docgia ) 
		begin
			raiserror (N'đọc giả này hiện đang còn tồn tại trong bảng muonsach, không thể xóa',16,1)
			return
		end
		else
			begin
				delete from site1.thuvien.dbo.DOCGIA_SITE1 where ID_docgia=@id_docgia
				delete from docgia_site2 where ID_docgia=@id_docgia
				delete from site3.thuvien.dbo.docgia_site3 where ID_docgia=@id_docgia
				delete from site4.thuvien.dbo.docgia_site4 where ID_docgia=@id_docgia
				print(N'xoá thành công đọc giả ở các site')
			end
	end
end
--=================================================
--test điều kiện khoá chính
exec delete_docgia 'DG99'
-- test điều kiện khoá ngoại
exec delete_docgia 'DG01'
-- xoá thành công
exec delete_docgia 'DG13'
go






go
-- insert NHANVIEN với các điều kiện 
-- + khoá chính không được trùng
-- + insert dữ liệu vào đúng các site
alter procedure insert_nhanvien 
	(@ID_nhanvien varchar(4),
	@tennhanvien nvarchar(40),
	@chucvu nvarchar(40),
	@email varchar(40),
	@Diachi nvarchar(100),
	@luong money)
as 
begin
	if exists (select * from site1.thuvien.dbo.NHANVIEN_SITE1 where ID_nhanvien=@ID_nhanvien)
	begin
		raiserror ('trung ID_nhanvien, khong the them moi',16,1)
		return
	end
	else
	begin
		insert into site1.thuvien.dbo.NHANVIEN_SITE1 (ID_nhanvien,tennhanvien,email,luong)
		values (@ID_nhanvien ,@tennhanvien ,@email,@luong)

		insert into site3.thuvien.dbo.NHANVIEN_SITE3 (ID_nhanvien,tennhanvien,email,luong)
		values (@ID_nhanvien ,@tennhanvien ,@email,@luong)

		insert into NHANVIEN_SITE2(ID_nhanvien,chucvu,diachi)
		values (@Id_nhanvien,@chucvu,@Diachi)
		insert into site4.thuvien.dbo.NHANVIEN_SITE4(ID_nhanvien,chucvu,diachi)
		values (@Id_nhanvien,@chucvu,@Diachi)
		print('insert thành công tất cả các site')
	end
end
--===========================================================
-- test điều kiện khoá chính
exec insert_nhanvien 'NV01','phamquochung','giamdoc','phamquochung019@gmail.com','new york',10000
-- insert thành công
exec insert_nhanvien 'NV09','phamquochung','giamdoc','phamquochung019@gmail.com','new york',10000
select * from NHANVIEN_SITE1
--============================================================
go






go
--tạo procedure delete nhanvien:
-- + kiểm tra điều kiện khoá chính tồn tại
-- + kiểm tra điều kiện nhân viên này không chịu trách nhiệm cho mượn sách nào (khoá ngoại)
-- + xoá ở tất cả các site
create procedure delete_nhanvien @id_nhanvien varchar(4)
as
begin
	if not exists (select * from site1.thuvien.dbo.NHANVIEN_SITE1 where ID_nhanvien=@id_nhanvien)
	begin
		raiserror (N'không tồn tại mã nhân viên này, vui lòng kiểm tra lại',16,1)
		return
	end
	else
	begin
		if exists (select * from muonsach where ID_nhanvien=@id_nhanvien)
		begin
			raiserror (N'nhân viên này còn đang chịu trách nhiệm cho một hóa đơn mượn sách, không thể xóa',16,1)
			return
		end
		else
			begin
				delete from site1.thuvien.dbo.NHANVIEN_SITE1 where ID_nhanvien=@id_nhanvien
				delete from NHANVIEN_SITE2 where ID_nhanvien=@id_nhanvien
				delete from site3.thuvien.dbo.NHANVIEN_SITE3 where ID_nhanvien=@id_nhanvien
				delete from site4.thuvien.dbo.NHANVIEN_SITE4 where ID_nhanvien=@id_nhanvien
				print(N'xoá dữ liệu ở tất cả các site')
			end
	end
end
--================================================================
-- test điều kiện khoá chính
exec delete_nhanvien 'NV99'
-- test điều kiện khoá ngoại
exec delete_nhanvien 'NV01'
-- xoá thành công
exec delete_nhanvien 'NV09'
go




go
-- Tạo procudure trả sách với điệu kiện:
-- + id_mượn sách phải tồn tại
-- + chuyển tình trạng mượn sách từ 0 thành 1
-- Tạo procudure trả sách với điệu kiện:
-- + id_mượn sách phải tồn tại
-- + chuyển tình trạng mượn sách từ 0 thành 1
create procedure trasach @ID_muonsach varchar(4)
as
begin
	IF NOT EXISTS (
        SELECT 1
        FROM muonsach
        WHERE ID_muonsach = @ID_muonsach
    )
    BEGIN
        RAISERROR(N'ID_muonsach không tồn tại!', 16, 1)
        RETURN
    END

    -- Chuyển tình trạng muonsach từ 0 thành 1
    UPDATE muonsach
    SET tinhtrangmuonsach = 1
    WHERE ID_muonsach = @ID_muonsach
	print('Thành công')
end
select *  from muonsach
go
--======================================
-- test trả sách thành công
exec trasach 'MS21'
-- =====================================