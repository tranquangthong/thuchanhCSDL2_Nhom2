CREATE DATABASE QUANLY_CTGH;
GO
USE QUANLY_CTGH;
-- 1. T?o b?ng KHACHHANG (Khách hàng)
CREATE TABLE KHACHHANG (
    MaKHACHANG INT PRIMARY KEY,
    TenCongTy NVARCHAR(255),
    TenGiaoDich NVARCHAR(255),
    DiaChi NVARCHAR(255),
    Email NVARCHAR(255),
    DienThoai NVARCHAR(15),
    Fax NVARCHAR(15)
);

-- 2. T?o b?ng NHACUNGCAP (Nhà cung c?p)
CREATE TABLE NHACUNGCAP (
    MaCongTy INT PRIMARY KEY,
    TenCongTy NVARCHAR(255),
    TenGiaoDich NVARCHAR(255),
    DiaChi NVARCHAR(255),
    DienThoai NVARCHAR(15),
    Fax NVARCHAR(15),
    Email NVARCHAR(255)
);

-- 3. T?o b?ng LOAIHANG (Lo?i hàng)
CREATE TABLE LOAIHANG (
    MaLoaiHang INT PRIMARY KEY,
    TenLoaiHang NVARCHAR(255)
);

-- 4. T?o b?ng MATHANG (M?t hàng)
CREATE TABLE MATHANG (
    MaHang INT PRIMARY KEY,
    TenHang NVARCHAR(255),
    MaCongTy INT,
    MaLoaiHang INT,
    SoLuong INT,
    DonViTinh NVARCHAR(50),
    GiaHang FLOAT,
    FOREIGN KEY (MaCongTy) REFERENCES NHACUNGCAP(MaCongTy),
    FOREIGN KEY (MaLoaiHang) REFERENCES LOAIHANG(MaLoaiHang)
);

-- 5. T?o b?ng NHANVIEN (Nhân viên)
CREATE TABLE NHANVIEN (
    MaNhanVien INT PRIMARY KEY,
    Ho NVARCHAR(50),
    Ten NVARCHAR(50),
    NgaySinh DATE,
    NgayLamViec DATE,
    DiaChi NVARCHAR(255),
    DienThoai NVARCHAR(15),
    LuongCoBan FLOAT,
    PhuCap FLOAT,
    CONSTRAINT CK_Tuoi CHECK (DATEDIFF(YEAR, NgaySinh, GETDATE()) BETWEEN 18 AND 60) -- Ràng bu?c tu?i t? 18 ??n 60
);

-- 6. T?o b?ng DONDATHANG (??n ??t hàng)
CREATE TABLE DONDATHANG (
    SoHoaDon INT PRIMARY KEY,
    MaKHACHANG INT,
    MaNhanVien INT,
    NgayDatHang DATE,
    NgayGiaoHang DATE,
    NgayChuyenHang DATE,
    NoiGiaoHang NVARCHAR(255),
    FOREIGN KEY (MaKHACHANG) REFERENCES KHACHHANG(MaKHACHANG),
    FOREIGN KEY (MaNhanVien) REFERENCES NHANVIEN(MaNhanVien),
    CONSTRAINT CK_NgayGiaoHang CHECK (NgayGiaoHang >= NgayDatHang), -- Ngày giao hàng ph?i sau ho?c b?ng ngày ??t hàng
    CONSTRAINT CK_NgayChuyenHang CHECK (NgayChuyenHang >= NgayDatHang) -- Ngày chuy?n hàng ph?i sau ho?c b?ng ngày ??t hàng
);

-- 7. T?o b?ng CHITIETDATHANG (Chi ti?t ??t hàng)
CREATE TABLE CHITIETDATHANG (
    SoHoaDon INT,
    MaHang INT,
    GiaBan FLOAT,
    SoLuong INT DEFAULT 1, -- Giá tr? m?c ??nh cho s? l??ng là 1
    MucGiamGia FLOAT DEFAULT 0, -- Giá tr? m?c ??nh cho m?c gi?m giá là 0
    PRIMARY KEY (SoHoaDon, MaHang),
    FOREIGN KEY (SoHoaDon) REFERENCES DONDATHANG(SoHoaDon),
    FOREIGN KEY (MaHang) REFERENCES MATHANG(MaHang)
);