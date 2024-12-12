
CREATE DATABASE QLBH_Nhom_2;
GO
-- sử dụng cơ sở dữ liệu quản lý bán hàng
use QLBH_Nhom_2;
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
	('KH001', 'Nha Cung Cap A', 'Giao Dich A', 'Dia Chi A', 'a@example.com', '0123456789', '0123456789'),
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
('NCC001', 'Nha Cung Cap A', 'Giao Dich A', 'Dia Chi NCC1', '0123456789', '0123456789', 'ncc1@gmail.com'),
('NCC002', 'Nha Cung Cap B', 'Giao Dich B', 'Dia Chi NCC2', '0123456789', '0123456789', 'ncc2@gmail.com'),
('NCC003', 'Nha Cung Cap C', 'Giao Dich C', 'Dia Chi NCC3', '0123456789', '0123456789', 'ncc3@gmail.com'),
('NCC004', 'Nha Cung Cap D', 'Giao Dich D', 'Dia Chi NCC4', '0123456789', '0123456789', 'ncc4@gmail.com'),
('NCC005', 'Nha Cung Cap E', 'Giao Dich E', 'Dia Chi NCC5', '0123456789', '0123456789', 'ncc5@gmail.com');
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
('DDH001', 'KH001', 'NV001', getdate(), null, null, 'Dia Chi Giao Hang 1'),
('DDH002', 'KH002', 'NV002', getdate(), null, null, 'Dia Chi Giao Hang 2'),
('DDH003', 'KH002', 'NV001', getdate(), null, getdate()+3, 'Dia Chi Giao Hang 3'),
('DDH004', 'KH003', 'NV004', getdate(), null, getdate()+3, 'Dia Chi Giao Hang 4'),
('DDH005', 'KH001', 'NV005', getdate(), null, getdate()+3, 'Dia Chi Giao Hang 5');

INSERT INTO CHITIETDATHANG (SOHOADON, MAHANG, GIABAN, SOLUONG, MUCGIAMGIA) 
VALUES
('DDH001', 'MH001', 10000, 50, 0),
('DDH002', 'MH005', 20000, 20, 0),
('DDH003', 'MH003', 30000, 30, 0),
('DDH004', 'MH003', 40000, 40, 0),
('DDH005', 'MH005', 50000, 50, 0);
-- Câu 1:
UPDATE DONDATHANG
SET NGAYCHUYENHANG=NGAYDATHANG
WHERE NGAYCHUYENHANG IS NULL
--CÂU 2:
UPDATE MATHANG
SET SOLUONG=SOLUONG*2
FROM NHACUNGCAP NCC
WHERE MATHANG.MACONGTY=NCC.MACONGTY AND NCC.TENCONGTY='Nha Cung Cap A';
--CÂU 3:
UPDATE KHACHHANG
SET DIACHI = NCC.DIACHI,
    DIENTHOAI = NCC.DIENTHOAI,
    FAX = NCC.FAX,
    EMAIL = NCC.EMAIL
FROM KHACHHANG KH
JOIN NHACUNGCAP NCC ON KH.TENCONGTY = NCC.TENCONGTY AND KH.TENGIAODICH = NCC.TENGIAODICH;
--Câu 4:
UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN * 1.5
WHERE MANHANVIEN IN (
    SELECT MANHANVIEN
    FROM DONDATHANG DDH
    JOIN CHITIETDATHANG CTDH ON DDH.SOHOADON = CTDH.SOHOADON
    WHERE YEAR(DDH.NGAYDATHANG) = 2022
    GROUP BY MANHANVIEN
    HAVING SUM(CTDH.SOLUONG) > 100
);
--Câu 5
--bước 1: tạo bảng tạm chứa số hoá đơn và tổng số lượng hàng bán ra cho từng hoá đơn
WITH TongSoLuongTheoHoaDon AS (
    SELECT SOHOADON, SUM(SOLUONG) AS TongSoLuong
    FROM CHITIETDATHANG
    GROUP BY SOHOADON--nhóm các bản ghi theo mã hoá đơn để tính toán tổng số lượng hàng bán ra
),
-- Bước 2: Tìm tổng số lượng lớn nhất
--Bảng tạm này chỉ chứa 1 giá trị duy nhất là giá trị lớn nhất được lấy ra từ tổng số lượng theo hoá đơn
SoLuongLonNhat AS (
    SELECT MAX(TongSoLuong) AS SoLuongLonNhat
    FROM TongSoLuongTheoHoaDon
)
-- Bước 3: Cập nhật phụ cấp cho những nhân viên phụ trách đơn hàng có tổng số lượng lớn nhất
UPDATE NHANVIEN
SET PHUCAP = PHUCAP + LUONGCOBAN * 0.5
WHERE MANHANVIEN IN (
    -- Lấy mã nhân viên phụ trách các đơn hàng có tổng số lượng lớn nhất
    SELECT DONDATHANG.MANHANVIEN
    FROM TongSoLuongTheoHoaDon
    JOIN DONDATHANG ON TongSoLuongTheoHoaDon.SOHOADON = DONDATHANG.SOHOADON
    WHERE TongSoLuongTheoHoaDon.TongSoLuong = (SELECT SoLuongLonNhat FROM SoLuongLonNhat)
);

--------
--Cau 1:Cho biết danh sách các đối tác cung cấp hàng cho công ty
SELECT DISTINCT NHACUNGCAP.TENCONGTY, NHACUNGCAP.TENGIAODICH, NHACUNGCAP.DIACHI, NHACUNGCAP.DIENTHOAI
FROM NHACUNGCAP
LEFT JOIN MATHANG ON NHACUNGCAP.MACONGTY = MATHANG.MACONGTY;
--Cần lấy tất cả các nhà cung cấp dù nhà cung cấp đó chưa cung cấp mặt hàng nào cho công ty

--Cau 2:Mã hàng, tên hàng và số lượng của các mặt hàng hiện có trong công ty.
SELECT MAHANG, TENHANG, SOLUONG
FROM MATHANG;


--Cau 3:Họ tên và địa chỉ và năm bắt đầu làm việc của các nhân viên trong công ty
select HO,TEN,DIACHI,year(NGAYLAMVIEC) as NAM_BAT_DAU_LAM_VIEC
from NHANVIEN
--Cau 4:Địa chỉ và điện thoại của nhà cung cấp có tên giao dịch [VINAMILK] là gì?
select DIACHI,DIENTHOAI
from NHACUNGCAP
where TENGIAODICH='VINAMILK'
--Cau 5:Cho biết mã và tên của các mặt hàng có giá lớn hơn 100000 và số lượng hiện có ít hơn 50
select MAHANG,TENHANG
from MATHANG
where GIAHANG>100000 and SOLUONG <50
--Cau 6:Cho biết mỗi mặt hàng trong công ty do ai cung cấp
select MH.TENHANG, NCC.TENCONGTY
from MATHANG MH
join NHACUNGCAP NCC on MH.MACONGTY = NCC.MACONGTY;
--Cau 7:Công ty [Việt Tiến] đã cung cấp những mặt hàng nào?
select MH.TENHANG
from MATHANG MH
join NHACUNGCAP NCC on MH.MACONGTY = NCC.MACONGTY
where ncc.TENCONGTY=N'Việt Tiến'
--Cau 8:Loại hàng thực phẩm do những công ty nào cung cấp và địa chỉ của các công ty đó là gì?
select ncc.MACONGTY,ncc.TENCONGTY,ncc.DIACHI
from NHACUNGCAP ncc
join MATHANG mh on mh.MACONGTY = ncc.MACONGTY
join LOAIHANG lh on lh.MALOAIHANG=mh.MALOAIHANG
where lh.TENLOAIHANG=N'Thực phẩm'
--Cau 9:Những khách hàng nào (tên giao dịch) đã đặt mua mặt hàng Sữa hộp XYZ của công ty?
select KHACHHANG.TENGIAODICH
from CHITIETDATHANG
join DONDATHANG on CHITIETDATHANG.SOHOADON = DONDATHANG.SOHOADON
join KHACHHANG on DONDATHANG.MAKHACHHANG = KHACHHANG.MAKHACHHANG
join MATHANG on CHITIETDATHANG.MAHANG = MATHANG.MAHANG
where MATHANG.TENHANG = 'Sữa hộp XYZ';
--Cau 10:Đơn đặt hàng số 1 do ai đặt và do nhân viên nào lập, thời gian và địa điểm giao hàng là ở đâu?
select kh.TENCONGTY as CONGTYDATHANG,nv.HO + ' ' + nv.TEN AS NHANVIENLAPDON,ddh.NGAYDATHANG,ddh.NOIGIAOHANG
from DONDATHANG ddh
join NHANVIEN nv on nv.MANHANVIEN=ddh.MANHANVIEN
join KHACHHANG kh on kh.MAKHACHHANG=ddh.MAKHACHHANG
where ddh.SOHOADON='DDH001'
--Cau 11:Hãy cho biết số tiền lương mà công ty phải trả cho mỗi nhân viên là bao nhiêu (lương = lương cơ bản + phụ cấp).
select nv.HO +' '+nv.TEN AS HOTEN,(LUONGCOBAN+isnull(PHUCAP,0)) as TONGLUONG
from NHANVIEN nv
--isnull(column,value) để thay thế nhưng giá trị null thành giá trị 0
--Cau 12:Hãy cho biết có những khách hàng nào lại chính là đối tác cung cấp hàng của công ty (tức là có cùng tên giao dịch).
select kh.MAKHACHHANG,kh.TENCONGTY
from KHACHHANG kh,NHACUNGCAP ncc
where kh.TENGIAODICH=ncc.TENGIAODICH

--Cau 13:Trong công ty có những nhân viên nào có cùng ngày sinh?
select nv1.MANHANVIEN,nv1.HO,nv1.TEN,nv1.NGAYSINH
from NHANVIEN nv1
join NHANVIEN nv2
	on month(nv1.NGAYSINH)=month(nv2.NGAYSINH)
	and day(nv1.NGAYSINH)=day(nv2.NGAYSINH)
	and nv1.MANHANVIEN<>nv2.MANHANVIEN--đảm bảo không so sánh với chính nó
--Cau 13:
SELECT MANHANVIEN, HO, TEN, NGAYSINH, DIACHI, DIENTHOAI, LUONGCOBAN, PHUCAP
FROM NHANVIEN
WHERE MONTH(NGAYSINH) IN (
    SELECT MONTH(NGAYSINH)
    FROM NHANVIEN
    GROUP BY MONTH(NGAYSINH), DAY(NGAYSINH)
    HAVING COUNT(*) > 1
)
AND DAY(NGAYSINH) IN (
    SELECT DAY(NGAYSINH)
    FROM NHANVIEN
    GROUP BY MONTH(NGAYSINH), DAY(NGAYSINH)
    HAVING COUNT(*) > 1
);

--Cau 14:Những đơn đặt hàng nào yêu cầu giao hàng ngay tại công ty đặt hàng và những đơn đó là của công ty nào
--Cách hiểu 1: Công ty trong đề bài là công ty của khách hàng
SELECT DONDATHANG.SOHOADON, KHACHHANG.TENCONGTY
FROM DONDATHANG
JOIN KHACHHANG ON DONDATHANG.MAKHACHHANG = KHACHHANG.MAKHACHHANG
WHERE DONDATHANG.NOIGIAOHANG = KHACHHANG.DIACHI;

--Cách hiểu 2: Công ty mà đề bài yêu cầu là công ty của nhà cung cấp đơn hàng
SELECT DONDATHANG.SOHOADON, NHACUNGCAP.TENCONGTY
FROM DONDATHANG
JOIN CHITIETDATHANG ON DONDATHANG.SOHOADON = CHITIETDATHANG.SOHOADON
JOIN MATHANG ON CHITIETDATHANG.MAHANG = MATHANG.MAHANG
JOIN NHACUNGCAP ON MATHANG.MACONGTY = NHACUNGCAP.MACONGTY
WHERE DONDATHANG.NOIGIAOHANG = NHACUNGCAP.DIACHI;

--Cau 15:. Cho biết tên công ty, tên giao dịch, địa chỉ và điện thoại của các khách hàng và các nhà cung cấp hàng cho công ty.
SELECT TENCONGTY,TENGIAODICH, DIACHI, DIENTHOAI
FROM KHACHHANG
UNION
SELECT TENCONGTY,TENGIAODICH, DIACHI, DIENTHOAI
FROM NHACUNGCAP;
--Cau 16:Những mặt hàng nào chưa từng được khách hàng đặt mua?
select mh.MAHANG,mh.TENHANG
from MATHANG mh
where mh.MAHANG not in (
	select distinct MAHANG
	from CHITIETDATHANG
);
--Cau 17:Những nhân viên nào của công ty chưa từng lập bất kỳ một hoá đơn đặt hàng nào?
SELECT HO + ' ' + TEN AS HOTENNHANVIEN
FROM NHANVIEN
WHERE MANHANVIEN NOT IN (SELECT DISTINCT MANHANVIEN FROM DONDATHANG);
--CAU 18:Những nhân viên nào của công ty có lương cơ bản cao nhất?
SELECT HO + ' ' + TEN AS HOTEN, LUONGCOBAN
FROM NHANVIEN
WHERE LUONGCOBAN = (SELECT MAX(LUONGCOBAN) FROM NHANVIEN);

--THỦ TỤC
ALTER PROC ThemMatHang
 @MAHANG CHAR(10),
 @TENHANG NVARCHAR(100),
 @MACONGTY CHAR(10),
 @MALOAIHANG CHAR(10),
 @SOLUONG INT,
 @DONVITINH VARCHAR(10),
 @GIAHANG DECIMAL(10,2)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM MATHANG WHERE MAHANG=@MAHANG)
	BEGIN
		PRINT N'MÃ HÀNG ĐÃ TỒN TẠI KHÔNG THỂ THÊM BẢNG GHI!';
		RETURN;
	END;
	IF NOT EXISTS (SELECT 1 FROM NHACUNGCAP WHERE MACONGTY=@MACONGTY)
	BEGIN
		PRINT N'MÃ CÔNG TY KHÔNG TỒN TẠI TRONG BẢNG NHÀ CUNG CẤP!';
		RETURN;
	END;
	IF NOT EXISTS (SELECT 1 FROM LOAIHANG WHERE MALOAIHANG=@MALOAIHANG)
	BEGIN
		PRINT N'MÃ LOẠI HÀNG KHÔNG TỒN TẠI TRONG BẢNG LOẠI HÀNG!';
		RETURN;
	END;
	IF (@SOLUONG <=0)
	BEGIN
		PRINT N'SỐ LƯỢNG MẶT HÀNG PHẢI LỚN HƠN 0!';
		RETURN;
	END;
	IF(@GIAHANG<=0)
	BEGIN
		PRINT N'GIÁ HÀNG PHẢI LỚN HƠN 0';
		RETURN;
	END;
	INSERT INTO MATHANG
	VALUES 
		(@MAHANG, @TENHANG, @MACONGTY,@MALOAIHANG,@SOLUONG,@DONVITINH,@GIAHANG)
	PRINT N'THÊM MẶT HÀNG THÀNH CÔNG!';
	RETURN;
END;
EXEC ThemMatHang
    @MAHANG = 'MH007', 
    @TENHANG = 'Mat Hang F', 
    @MACONGTY = 'NCC001', 
    @MALOAIHANG = 'LH002', 
    @SOLUONG = -1, 
    @DONVITINH = 'Cai', 
    @GIAHANG = 25000
--Câu 2
ALTER PROC ThongKeTongSoLuong
	@MAHANG CHAR(10),
	@TONGSOLUONG INT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM MATHANG WHERE MAHANG=@MAHANG)
	BEGIN
		PRINT N'MÃ HÀNG KHÔNG TỒN TẠI';
		SET @TONGSOLUONG=0;
		RETURN;
	END;
	SELECT @TONGSOLUONG = SUM(SOLUONG)
	FROM CHITIETDATHANG
	WHERE @MAHANG=MAHANG
	IF @TONGSOLUONG IS NULL
	BEGIN
		SET @TONGSOLUONG=0;
	END;
	PRINT N'THỐNG KÊ THÀNH CÔNG!';
	SELECT MAHANG,@TONGSOLUONG AS TONGSOLUONGDABAN
	FROM MATHANG
	WHERE MAHANG=@MAHANG
END;
DECLARE @OutputTongSoLuong INT;
EXEC ThongKeTongSoLuong 
    @MAHANG = 'MH001', 
    @TongSoLuong = @OutputTongSoLuong OUTPUT;
print @OutputTongSoLuong
select * from MATHANG
select * from CHITIETDATHANG;
go
--Câu 2:
ALTER PROCEDURE ThongKeSoLuongBan
    @MAHANG CHAR(10)
AS
BEGIN
    -- Kiểm tra tham số đầu vào
    IF @MAHANG IS NULL OR LEN(@MAHANG) = 0
    BEGIN
        PRINT 'Lỗi: Mã hàng không được để trống.';
        RETURN;
    END

    -- Kiểm tra mã hàng có tồn tại trong bảng MATHANG
    IF NOT EXISTS (SELECT 1 FROM MATHANG WHERE MAHANG = @MAHANG)
    BEGIN
        PRINT 'Lỗi: Mã hàng không tồn tại trong bảng MATHANG.';
        RETURN;
    END

    -- Khai báo biến để lưu tổng số lượng bán
    DECLARE @TongSoLuong INT;

    -- Thống kê tổng số lượng hàng bán được
    SELECT @TongSoLuong = ISNULL(SUM(SOLUONG), 0)
    FROM CHITIETDATHANG
    WHERE MAHANG = @MAHANG;

    -- Kết quả trả về
    PRINT 'Tong so luong hang ban duoc cua ma hang [' + @MAHANG + ']: ' + CAST(@TongSoLuong AS NVARCHAR);
END;
GO
EXEC ThongKeSoLuongBan @MAHANG = 'MH001';
GO
--Câu 3:
CREATE FUNCTION ThongKeTongSoLuongHang ()
RETURNS @KetQua TABLE
(
    MAHANG CHAR(10),
    TENHANG NVARCHAR(100),
    SOLUONG_HIENTAI INT,
    SOLUONG_DABAN INT,
    TONG_SOLUONG INT
)
AS
BEGIN
    -- Chèn dữ liệu vào bảng trả về
    INSERT INTO @KetQua (MAHANG, TENHANG, SOLUONG_HIENTAI, SOLUONG_DABAN, TONG_SOLUONG)
    SELECT 
        MH.MAHANG, -- Mã hàng
        MH.TENHANG, -- Tên hàng
        MH.SOLUONG AS SOLUONG_HIENTAI, -- Số lượng hiện tại trong bảng MATHANG
        ISNULL(SUM(CT.SOLUONG), 0) AS SOLUONG_DABAN, -- Tổng số lượng đã bán (tính từ bảng CHITIETDATHANG)
        MH.SOLUONG + ISNULL(SUM(CT.SOLUONG), 0) AS TONG_SOLUONG -- Tổng cộng (hiện tại + đã bán)
    FROM 
        MATHANG MH
    LEFT JOIN 
        CHITIETDATHANG CT ON MH.MAHANG = CT.MAHANG -- Hiển thị tất cả mặt hàng kể cả khi mặt hàng đó chưa được bán
    GROUP BY 
        MH.MAHANG, MH.TENHANG, MH.SOLUONG;

    RETURN;
END;
GO
SELECT * FROM ThongKeTongSoLuongHang();
GO
--Câu 4
CREATE TRIGGER trg_CHITIETDATHANG
ON CHITIETDATHANG
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Biến khai báo
    DECLARE @MAHANG CHAR(10), @SOHOADON CHAR(10), @SOLUONG_MOI INT, @SOLUONG_CU INT;
    DECLARE @SOLUONG_HIENTAI INT;

    -- Lấy thông tin từ INSERTED (bản ghi mới hoặc được cập nhật)
    SELECT @MAHANG = MAHANG, @SOHOADON = SOHOADON, @SOLUONG_MOI = SOLUONG
    FROM INSERTED;

    -- Lấy số lượng hàng hiện có trong kho từ bảng MATHANG
    SELECT @SOLUONG_HIENTAI = SOLUONG
    FROM MATHANG
    WHERE MAHANG = @MAHANG;

    -- Xử lý trường hợp thêm mới (INSERT)
    IF EXISTS (SELECT * FROM INSERTED EXCEPT SELECT * FROM DELETED)
    BEGIN
        -- Kiểm tra: Số lượng hàng trong kho phải đủ để đáp ứng đơn hàng
        IF @SOLUONG_HIENTAI IS NULL OR @SOLUONG_HIENTAI < @SOLUONG_MOI
        BEGIN
            PRINT 'Lỗi: Không đủ số lượng hàng trong kho để thêm chi tiết đặt hàng.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Giảm số lượng hàng trong kho
        UPDATE MATHANG
        SET SOLUONG = SOLUONG - @SOLUONG_MOI
        WHERE MAHANG = @MAHANG;

        PRINT 'Thêm chi tiết đặt hàng thành công. Số lượng hàng đã được cập nhật.';
    END

    -- Xử lý trường hợp cập nhật (UPDATE)
    IF EXISTS (SELECT * FROM INSERTED INTERSECT SELECT * FROM DELETED)
    BEGIN
        -- Lấy số lượng cũ từ DELETED
        SELECT @SOLUONG_CU = SOLUONG
        FROM DELETED
        WHERE SOHOADON = @SOHOADON AND MAHANG = @MAHANG;

        -- Tính sự chênh lệch số lượng
        DECLARE @CHENH_LECH INT = @SOLUONG_MOI - @SOLUONG_CU;

        -- Kiểm tra: Số lượng mới không vượt quá kho và không nhỏ hơn 1
        IF @CHENH_LECH > 0 AND @SOLUONG_HIENTAI < @CHENH_LECH
        BEGIN
            PRINT 'Lỗi: Không đủ hàng trong kho để cập nhật số lượng.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @SOLUONG_MOI < 1
        BEGIN
            PRINT 'Lỗi: Số lượng hàng bán phải lớn hơn hoặc bằng 1.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Cập nhật số lượng hàng trong kho
        UPDATE MATHANG
        SET SOLUONG = SOLUONG - @CHENH_LECH
        WHERE MAHANG = @MAHANG;

        PRINT 'Cập nhật chi tiết đặt hàng thành công. Số lượng hàng đã được cập nhật.';
    END
END;
GO

