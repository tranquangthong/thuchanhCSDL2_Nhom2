
CREATE DATABASE QLBH;
GO
-- sử dụng cơ sở dữ liệu quản lý bán hàng
use QLBH;
go
--tạo các bảng trong cơ sở dữ liệu
create table KHACHHANG
(
	MAKHACHHANG char(10) primary key,
	TENCONGTY nvarchar(100) not null,
	TENGIAODICH nvarchar(100) null,
	DIACHI nvarchar(100) not null,
	EMAIL varchar(100) not null,
	DIENTHOAI varchar(11) not null,
	FAX varchar(10) null
);
go
create table NHANVIEN
(
	MANHANVIEN char(10) primary key,
	HO nvarchar(20) not null,
	TEN nvarchar(20) not null,
	NGAYSINH date not null,
	NGAYLAMVIEC date not null,
	DIACHI nvarchar(100) not null,
	DIENTHOAI varchar(11) not null,
	LUONGCOBAN decimal(10,2) not null,
	PHUCAP decimal(10,2) null
);
go
create table DONDATHANG
(
	SOHOADON char(10) primary key,
	MAKHACHHANG char(10) not null,
	MANHANVIEN char(10) not null,
	NGAYDATHANG date not null,
	NGAYGIAOHANG date,--khi chưa có ngày giao hàng cụ thể thì giá trị mặc định là null
	NGAYCHUYENHANG date,
	NOIGIAOHANG nvarchar(100) not null,
	foreign key (MAKHACHHANG) references KHACHHANG(MAKHACHHANG),
	foreign key (MANHANVIEN) references NHANVIEN(MANHANVIEN)
);
go
create table NHACUNGCAP
(
	MACONGTY char(10) primary key,
	TENCONGTY nvarchar(100) not null,
	TENGIAODICH nvarchar(100),
	DIACHI nvarchar(200) not null,
	DIENTHOAI varchar(10) not null,
	FAX varchar(10),
	EMAIL varchar(100) unique not null
);
go 
create table LOAIHANG(
	MALOAIHANG char(10) primary key,
	TENLOAIHANG nvarchar(100) not null
);
create table MATHANG
(
	MAHANG char(10) primary key,
	TENHANG nvarchar(100) unique not null,
	MACONGTY char(10) not null,
	MALOAIHANG char(10) not null,
	SOLUONG int not null,
	DONVITINH varchar(10) not null,
	GIAHANG decimal(10,2) not null,
	foreign key (MACONGTY) references NHACUNGCAP(MACONGTY),
	foreign key (MALOAIHANG) references LOAIHANG(MALOAIHANG)
);
go
create table CHITIETDATHANG
(
	SOHOADON char(10) not null,
	MAHANG char(10) not null,
	GIABAN decimal(10,2) not null,
	SOLUONG int not null,
	MUCGIAMGIA decimal(10,2),
	primary key (SOHOADON,MAHANG),
	foreign key (SOHOADON) references DONDATHANG(SOHOADON),
	foreign key (MAHANG) references MATHANG(MAHANG)
);
--Bổ sung ràng buộc thiết lập giá trị mặc định bằng 1 cho cột SOLUONG và băng 0 cho cột MUCGIAMGIA trong bảng CHITIETDATHANG
go
alter table CHITIETDATHANG 
	add constraint DF_SOLUONG default 1 for SOLUONG;
alter table CHITIETDATHANG
add constraint DF_MUCGIAMGIA default 0 for MUCGIAMGIA,
	constraint CK_MucGiamGia_ChiTietDatHang check (MUCGIAMGIA>=0),
	constraint CK_GiaBan_ChiTietDatHang check (GIABAN >=0);
--Bổ sung cho bảng DONDATHANG ràng buộc kiểm tra ngày giao hàng và ngày chuyển hàng phải sau hoặc bằng với ngày đặt hàng. 
alter table DONDATHANG
	add constraint DF_NGAYDATHANG default getdate() for NGAYDATHANG;
alter table DONDATHANG 
	add constraint CK_NGAYGIAOHANG check (NGAYGIAOHANG is null or NGAYGIAOHANG>=NGAYDATHANG);
alter table DONDATHANG
	add constraint CK_NGAYCHUYENHANG check (NGAYCHUYENHANG is null or NGAYCHUYENHANG>=NGAYDATHANG);
--	Bổ sung ràng buộc cho bảng NHANVIEN để đảm bảo rằng một 
-- nhân viên chỉ có thể làm việc trong công ty khi đủ 18 tuổi và không quá 60 tuổi.
alter table NHANVIEN
	add constraint CK_TUOI_NHANVIEN check (datediff(year,NGAYSINH,NGAYLAMVIEC)>=18 AND datediff(year,NGAYSINH,NGAYLAMVIEC)<=60);
	--datediff sử dụng để tính toán sự khác biệt của ngaysinh và ngaylamviec, trả về giá trị là sự chênh lệch giữa số năm giữa ngay làm việc và ngày sinh
alter table KHACHHANG
	add constraint CK_Email_KhachHang check (EMAIL like '%_@__%.__%'),
		constraint CK_DIENTHOAI_KHACHHANG check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' or DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');
alter table NHANVIEN
	add constraint CK_DIENTHOAI_NHANVIEN check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' or DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');
SET DATEFORMAT ymd;
GO
	--Thêm dữ liệu vào bảng khách hàng
INSERT INTO KHACHHANG (MAKHACHHANG, TENCONGTY, TENGIAODICH, DIACHI, EMAIL, DIENTHOAI, FAX)
VALUES
	('KH001', 'Cong Ty A', 'Giao Dich A', 'Dia Chi A', 'a@example.com', '0123456789', '0123456789'),
	('KH002', 'Cong Ty B', 'Giao Dich B', 'Dia Chi B', 'b@example.com', '0123456789', '0123456789'),
	('KH003', 'Cong Ty C', 'Giao Dich C', 'Dia Chi C', 'c@example.com', '0123456789', '0123456789'),
	('KH004', 'Cong Ty D', 'Giao Dich D', 'Dia Chi D', 'd@example.com', '0123456789', '0123456789'),
	('KH005', 'Cong Ty E', 'Giao Dich E', 'Dia Chi E', 'e@example.com', '0123456789', '0123456789');
--Thêm dữ liệu vào bảng nhân viên
INSERT INTO NHANVIEN (MANHANVIEN, HO, TEN, NGAYSINH, NGAYLAMVIEC, DIACHI, DIENTHOAI, LUONGCOBAN, PHUCAP)
VALUES
	('NV001', 'Nguyen', 'A', '1980-01-01', '2020-01-01', 'Dia Chi NV1', '0123456789', 5000000, 1000000),
	('NV002', 'Tran', 'B', '1985-02-02', '2020-02-02', 'Dia Chi NV2', '0123456789', 6000000, 2000000),
	('NV003', 'Le', 'C', '1990-03-03', '2020-03-03', 'Dia Chi NV3', '0123456789', 7000000, 3000000),
	('NV004', 'Pham', 'D', '1995-04-04', '2020-04-04', 'Dia Chi NV4', '0123456789', 8000000, 4000000),
	('NV005', 'Hoang', 'E', '2000-05-05', '2020-05-05', 'Dia Chi NV5', '0123456789', 9000000, 5000000);
	--Thêm dữ liệu vào bảng nhà cung cấp
INSERT INTO NHACUNGCAP (MACONGTY, TENCONGTY, TENGIAODICH, DIACHI, DIENTHOAI, FAX, EMAIL)
VALUES
('NCC001', 'Cong Ty A', 'Giao Dich A', 'Dia Chi NCC1', '0123456789', '0123456789', 'ncc1@gmail.com'),
('NCC002', 'Cong Ty B', 'Giao Dich B', 'Dia Chi NCC2', '0123456789', '0123456789', 'ncc2@gmail.com'),
('NCC003', 'Cong Ty C', 'Giao Dich C', 'Dia Chi NCC3', '0123456789', '0123456789', 'ncc3@gmail.com'),
('NCC004', 'Cong Ty D', 'Giao Dich D', 'Dia Chi NCC4', '0123456789', '0123456789', 'ncc4@gmail.com'),
('NCC005', 'Cong Ty E', 'Giao Dich E', 'Dia Chi NCC5', '0123456789', '0123456789', 'ncc5@gmail.com');
--Thêm dữ liệu vào  bảng loại hàng
INSERT INTO LOAIHANG (MALOAIHANG, TENLOAIHANG)
VALUES
('LH001', 'Loai Hang A'),
('LH002', 'Loai Hang B'),
('LH003', 'Loai Hang C'),
('LH004', 'Loai Hang D'),
('LH005', 'Loai Hang E');
--Thêm dữ liệu vào bảng mặt hàng
INSERT INTO MATHANG (MAHANG, TENHANG, MACONGTY, MALOAIHANG, SOLUONG, DONVITINH, GIAHANG)
VALUES
('MH001', 'Mat Hang A', 'NCC001', 'LH001', 100, 'Cai', 10000),
('MH002', 'Mat Hang B', 'NCC002', 'LH002', 200, 'Cai', 20000),
('MH003', 'Mat Hang C', 'NCC003', 'LH003', 300, 'Cai', 30000),
('MH004', 'Mat Hang D', 'NCC003', 'LH004', 400, 'Cai', 40000),
('MH005', 'Mat Hang E', 'NCC001', 'LH004', 500, 'Cai', 50000);
--Thêm dữ liệu vào bảng đơn đặt hàng
INSERT INTO DONDATHANG (SOHOADON, MAKHACHHANG, MANHANVIEN, NGAYDATHANG, NGAYGIAOHANG, NGAYCHUYENHANG, NOIGIAOHANG) 
VALUES
('DDH001', 'KH001', 'NV001', getdate(), null, getdate()+3, 'Dia Chi Giao Hang 1'),
('DDH002', 'KH002', 'NV002', getdate(), null, getdate()+3, 'Dia Chi Giao Hang 2'),
('DDH003', 'KH002', 'NV001', getdate(), null, getdate()+3, 'Dia Chi Giao Hang 3'),
('DDH004', 'KH003', 'NV004', getdate(), null, getdate()+3, 'Dia Chi Giao Hang 4'),
('DDH005', 'KH001', 'NV005', getdate(), null, getdate()+3, 'Dia Chi Giao Hang 5');

INSERT INTO CHITIETDATHANG (SOHOADON, MAHANG, GIABAN, SOLUONG, MUCGIAMGIA) 
VALUES
('DDH001', 'MH001', 10000, 10, 0),
('DDH002', 'MH005', 20000, 20, 0),
('DDH003', 'MH003', 30000, 30, 0),
('DDH004', 'MH003', 40000, 40, 0),
('DDH005', 'MH005', 50000, 50, 0);
