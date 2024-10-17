--tạo cơ sử dữ liệu quản lý bán hàng
create database QLBH;
go
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
)
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
	MUCGIAMGIA decimal(10,2),
	primary key (SOHOADON,MAHANG),
	foreign key (SOHOADON) references DONDATHANG(SOHOADON),
	foreign key (MAHANG) references MATHANG(MAHANG)
)
