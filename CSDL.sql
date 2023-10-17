use master
go
if exists(select * from sysdatabases where name ='thuvien')
	drop database thuvien
create database thuvien
go
use thuvien
--tạo bảng
go
create table tacgia (
	ID_tacgia varchar(4),
	tentacgia nvarchar(40),
	ngaysinh date,
	ngaymat date,
	mota nvarchar(1000),
	gioitinh nvarchar(5)
	)
go
create table sach(
	ID_sach varchar(4),
	ID_tacgia varchar(4),
	tensach nvarchar(400),
	theloai nvarchar(40),
	soluong int
	);
go
create table docgia(
	ID_docgia varchar(4),
	tendocgia nvarchar(40),
	Diachi nvarchar(100),
	email varchar(40),
	sdt varchar(10),
	tinhtrangdocgia binary
	);
go
create table nhanvien(
	ID_nhanvien varchar(4),
	tennhanvien nvarchar(40),
	chucvu nvarchar(40),
	email varchar(40),
	Diachi nvarchar(100),
	luong money
	);
go
create table muonsach(
	ID_muonsach varchar(4),
	ID_sach varchar(4),
	ID_docgia varchar(4),
	ID_nhanvien varchar(4),
	ngaymuon date,
	ngayhethan date,
	tinhtrangmuonsach binary
	);
go
--insert dữ liệu
insert into tacgia(ID_tacgia,tentacgia,ngaysinh,ngaymat,mota,gioitinh)
values
	('TG01',N'Kim Lân','1920-8-1','2007-7-20',N'Nhà văn',N'Nam'),
	('TG02',N'Xuân Diệu','1916-2-2','1985-12-18',N'Nhà thơ',N'Nam'),
	('TG03',N'Tố Hữu','1920-10-4','2002-2-19',N'Nhà thơ',N'Nam'),
	('TG04',N'Huy Cận', '1908-12-04','1956-07-09',N'Nhà thơ',N'Nam'),
	('TG05',N'Tô Hoài', '1920-08-15','2014-06-30',N'Nhà văn',N'Nam'),
	('TG06',N'Nguyễn Minh Châu','1930-05-12','1989-05-27',N'Nhà văn',N'Nam'),
	('TG07',N'Bà Huyện Thanh Quan','1805-01-1','1848-1-1',N'Nhà thơ',N'Nữ'),
	('TG08',N'Xuân Quỳnh','1942-10-6','1988-08-29',N'Nhà thơ',N'Nữ'),
	('TG09',N'Hồ Xuân Hương','1772-1-1','1822-1-1',N'Nhà văn',N'Nữ'),
	('TG10',N'Anh Thơ', '1921-1-25','2005-3-1',N'Nhà Văn',N'Nữ')

insert into sach(ID_sach,ID_tacgia,tensach,theloai,soluong)
values
	('S001','TG01',N'Làng',N'Truyện ngắn',10),
	('S002','TG01',N'Vợ Nhặt',N'Tryện ngắn',12),
	('S003','TG01',N'Con mã mái',N'Truyện ngắn',7),
	('S004','TG01',N'Đứa con người vợ lẽ',N'Truyện ngắn',10),
	('S005','TG01',N'Chó săn',N'Tryện ngắn',12),
	('S006','TG01',N'Cô Vịa',N'Truyện ngắn',7),
	('S007','TG02',N'Thơ thơ',N'Thơ',10),
	('S008','TG02',N'Ngôi sao',N'Thơ',12),
	('S009','TG02',N'Gửi hương cho gió',N'Thơ',7),
	('S010','TG02',N'Tôi giàu đôi mắt',N'Thơ',10),
	('S011','TG02',N'Phấn thông vàng',N'Văn xuôi',12),
	('S012','TG02',N'Từ ấy',N'Văn xuôi',7),
	('S013','TG03','Việt Bắc',N'Thơ',10),
	('S014','TG03',N'Gió lộng',N'Thơ',12),
	('S015','TG03',N'Ra trận',N'Thơ',7),
	('S016','TG03',N'Máu và Hoa',N'Thơ',10),
	('S017','TG03',N'Xây dựng một nền văn nghệ lớn xứng đáng với nhân dân ta, với thời đại ta ',N'Tiểu luận',12),
	('S018','TG03',N' Cuộc sống cách mạng và văn học nghệ thuật',N'Tiểu luận',7),
	('S019','TG05',N'Miền Tây',N'Văn xuôi',8),
	('S020','TG05',N'Dế Mèn phiêu lưu ký',N'Văn xuôi',12),
	('S021','TG05',N'Vợ chồng A Phủ',N'Truyện ngắn',10),
	('S022','TG05',N'Họ Giàng ở Phìn Sa',N'Tiểu thuyết',5),
	('S023','TG05',N'Tuổi trẻ Hoàng Văn Thụ',N'Tiểu thuyết',4),
	('S024','TG04',N'Đất nở hoa',N'Thơ',7),
	('S025','TG04',N'Bài thơ cuộc đời',N'Thơ',8),
	('S026','TG04',N'Cô gái Mèo',N'Thơ',9),
	('S027','TG04',N'Hai bàn tay em',N'Thơ',10),
	('S028','TG06',N'Chiếc thuyền ngoài xa',N'Truyện ngắn',15),
	('S029','TG06',N'Cửa sông',N'Tiểu thuyết',5),
	('S030','TG06',N'Miền cháy',N'Tiểu thuyết',6),
	('S031','TG07',N'Qua đèo ngang',N'Thơ',4),
	('S032','TG07',N'Cảnh hương sơn',N'Thơ',6),
	('S033','TG07',N'Thăng Long hoài cổ',N'Thơ',6),
	('S034','TG08',N'Sóng',N'Thơ',6),
	('S035','TG08',N'Thuyền và biển',N'Thơ',2),
	('S036','TG08',N'Tự hát',N'Thơ',6),
	('S037','TG09',N'Bánh trôi nước',N'Thơ',6),
	('S038','TG09',N'Vấn nguyệt',N'Thơ',6),
	('S039','TG10',N'Chiều Xuân',N'Thơ',6),
	('S040','TG10',N'Trưa hè',N'Thơ',6),
	('S041','TG10',N'Rằm tháng tám',N'Thơ',6),
	('S042','TG05',N'Quên',N'Thơ',3),
	('S043','TG05',N'Cảm Xúc',N'Thơ',13)


insert into docgia(ID_docgia,tendocgia,Diachi,email,sdt,tinhtrangdocgia)
values
	('DG01',N'Nguyễn Huy Mạnh',N'Cầu Giấy','manhdg01@gmail.com','0985028676',1),
	('DG02',N'Nguyễn Đăng Hùng',N'Thanh Xuân','hungdg02@gmail.com','0985238676',1),
	('DG03',N'Nguyễn Ngọc Ngà',N'Hoàng Mai','manhdg03@gmail.com','0999999999',1),
	('DG04',N'Phạm Đăng Hưng',N'Hà Đông','hungdg04@gmail.com','0944238666',0),
	('DG05',N'Uyên Mai',N'Thanh Xuân','maiuyen@gmail.com','0985231236',1),
	('DG06',N'Lê Minh Hiếu',N'Cầu Giấy','hieulm@gmail.com','0325144256',1),
	('DG07',N'Đỗ Khánh Linh',N'Thanh Xuân','kinh@gmail.com','0325678910',0),
	('DG08',N'Vũ Ngọc Mai',N'Hoàng Mai','maivn@gmail.com','0326142566',1),
	('DG09',N'Hoàng Bá Long',N'Hà Đông','longhb@gmail.com','0326541222',1),
	('DG10',N'Mai Quỳnh Trang',N'Thanh Xuân','trang@gmail.com','0934576888',0),
	('DG11',N'Phạm Mai Anh',N'Cầu Giấy','maipn@gmail.com','0982561333',1),
	('DG12',N'Nguyễn Bảo Ngọc',N'Hoàng Mai','ngoc2gmail.com','0987345621',1)
	
insert into nhanvien(ID_nhanvien,tennhanvien,chucvu,email,Diachi,luong)
values
	('NV01',N'Trần văn cường',N'Lễ Tân','cuongtv@gmail.com',N'Hoàng Mai', 100000),
	('NV02',N'Lê Duy Đức', N'Quản lí',N'Hoàng Mai','ducld@gmail.com',200000),
	('NV03',N'Nguyễn Đình khánh',N'Lễ Tân','khanhnd@gmail.com',N'Thanh Xuân', 100000),
	('NV04',N'Lê Duy Đức', N'Quản lí','leducduy@gmail.com',N'Thanh Xuân',200000),
	('NV05',N'Nguyễn Đăng Khôi',N'Lễ Tân','khoind@gmail.com',N'Cầu Giấy',100000),
	('NV06',N'Nguyễn Minh Đức', N'Quản lí','ducnm@gmail.com',N'Cầu Giấy',200000),
	('NV07',N'Lý Hoài Lê',N'Lễ Tân','lehl@gmail.com',N'Hà Đông',100000),
	('NV08',N'Hoàng Xuân Tùng',N'Quản lí','tungxh@gmail.com',N'Hà Đông',200000)

insert into muonsach(ID_muonsach,ID_sach,ID_docgia,ID_nhanvien,ngaymuon,ngayhethan,tinhtrangmuonsach)
values
	('MS01','S001','DG01','NV05','2023-2-21','2023-2-28',1),
	('MS02','S002','DG01','NV05','2023-2-21','2023-2-28',1),
	('MS03','S004','DG03','NV01','2023-2-21','2023-2-28',1),
	('MS04','S003','DG05','NV03','2023-2-21','2023-2-28',1),
	('MS05','S002','DG02','NV03','2023-3-21','2023-3-29',1),
	('MS06','S002','DG09','NV07','2023-3-21','2023-3-29',1),
	('MS07','S003','DG03','NV01','2023-3-21','2023-3-29',1),
	('MS08','S003','DG04','NV07','2023-3-21','2023-3-29',1),
	('MS09','S003','DG06','NV05','2023-3-22','2023-3-30',1),
	('MS11','S006','DG02','NV04','2023-3-22','2023-4-29',1),
	('MS12','S006','DG05','NV04','2023-3-22','2023-4-29',1),
	('MS13','S007','DG02','NV04','2023-3-22','2023-4-29',1),
	('MS14','S008','DG03','NV02','2023-3-22','2023-4-20',1),
	('MS15','S008','DG04','NV08','2023-3-24','2023-4-20',1),
	('MS16','S008','DG01','NV02','2023-3-24','2023-4-22',1),
	('MS17','S010','DG01','NV02','2023-3-24','2023-5-1',1),
	('MS18','S011','DG01','NV05','2023-3-25','2023-3-29',1),
	('MS19','S011','DG05','NV03','2023-3-25','2023-3-29',1),
	('MS20','S016','DG01','NV06','2023-3-26','2023-3-31',1),
	('MS21','S016','DG04','NV03','2023-3-26','2023-3-31',0),
	('MS22','S016','DG07','NV03','2023-3-26','2023-3-31',0),
	('MS23','S016','DG10','NV03','2023-3-26','2023-3-31',0),
	('MS24','S042','DG01','NV01','2023-4-12','2023-4-18',1),
	('MS25','S042','DG02','NV01','2023-3-12','2023-4-18',1),
	('MS26','S043','DG05','NV01','2023-3-12','2023-4-18',1)