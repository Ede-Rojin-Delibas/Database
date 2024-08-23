SELECT O.ID ORDERID, U.USERNAME_, U.NAMESURNAME ,
O.DATE_ ORDERDATE,O.TOTALPRICE ,A.POSTALCODE,A.ADDRESSTEXT,
I.ITEMCODE,I.ITEMNAME,I.BRAND,I.CATEGORY1,I.CATEGORY2,
OD.AMOUNT, OD.UNITPRICE,OD.LINETOTAL,
C.CITY, T.TOWN, D.DISTRICT
FROM ORDERS O 
JOIN ORDERDETAILS OD ON OD.ORDERID=O.ID 
JOIN USERS U ON U.ID=O.USERID
JOIN ADDRESS A ON A.ID=O.ADDRESSID
JOIN ITEMS I ON I.ID=OD.ITEMID
JOIN CITIES C ON C.ID=A.CITYID
JOIN TOWNS T ON T.ID=A.TOWNID
JOIN DISTRICTS D ON D.ID=A.DISTRICTID
--ger�ek veri seti �rnek 1
-- 2022 YILI OCAK AYI S�PAR��LER� TAR�HE G�RE SIRALI B�T�N S�PAR��LER� GET�R.
--DATE_, ITEMCODE, ITEMNAME , BRAND, CATEGORY1, AMOUNT , UNITPRICE,LINETOTAL KOLONLARININ GET�R�LMES� GEREK�YOR.
--BEN�M SORGUM:
SELECT O.DATE_,I.ITEMCODE,I.ITEMNAME,I.BRAND,I.CATEGORY1,
OD.AMOUNT, I.UNITPRICE , OD.LINETOTAL FROM ORDERDETAILS OD 
JOIN ITEMS I ON OD.ITEMID=I.ID
JOIN ORDERS O ON O.ID=OD.ORDERID
GROUP BY DATE_ 
ORDER BY DATE_
--WHERE DATE_  ='2022' AND DATE_='OCAK'

--OLMASI GEREKEN SORGU:
SELECT O.DATE_,I.ITEMCODE,I.ITEMNAME,I.BRAND, I.CATEGORY1,
OD.AMOUNT,OD.UNITPRICE,OD.LINETOTAL
FROM ORDERS O 
JOIN ORDERDETAILS OD ON O.ID=OD.ORDERID
JOIN ITEMS I ON I.ID=OD.ITEMID
WHERE DATE_ BETWEEN '20220101' AND '2022-01-31  23:59:59' --BU KULLANIM DAHA YAYGIN VE DO�RUDUR.
ORDER BY DATE_ DESC		--BU SORGUDA 31 OCAK TAR�H�NDEK� KAYITLAR GELMED� BUNUN SEBEB�:
                        --VER� T�P�N�N DATET�ME OLMASIDIR. CONVERT ��LEM�YLE YA DA SAAT DETAYI VER�LEREK SORGU D�ND�R�LEB�L�R.
--ger�ek veri seti �rnek 2:Nazmiye Ercan isimli kullan�c�n�n verdi�i sipari�lerin detay�n� getiren sorgu
--BEN�M SORGUM:
SELECT U.NAMESURNAME, OD.ORDERID, I.ID,I.ITEMCODE, I.ITEMNAME,
I.UNITPRICE,OD.AMOUNT,OD.LINETOTAL FROM USERS U
JOIN ORDERS O ON U.ID=O.USERID
JOIN ORDERDETAILS OD ON OD.ORDERID=O.ID
JOIN ITEMS I ON I.ID=OD.ITEMID
WHERE NAMESURNAME ='NAZM�YE ERCAN'
--�RNEK: HER �EHR�N �L�ELER�N� GET�REN SORGUYU YAZINIZ.
SELECT C.CITY �EH�RLER,T.TOWN �L�ELER FROM CITIES C
JOIN TOWNS T ON T.CITYID=C.ID
ORDER BY CITY, TOWN
--�RNEK: �STANBUL'DA HANG� �L�E , NE KADAR M��TER� OLDU�UNU GET�REN SORGU YAZINIZ.
SELECT C.CITY,T.TOWN, COUNT(U.ID) FROM 
ADDRESS A
JOIN USERS U ON U.ID =A.USERID
JOIN CITIES C ON C.CITY=A.CITYID
JOIN TOWNS T ON T.ID=A.TOWNID
WHERE CITY='�STANBUL'
GROUP BY C.CITY,T.TOWN
--TEK�L M��TER� SAYISINI GET�RMEK �ST�YORSAK COUNT (DISTINCT KULLANMALIYIZ. 
--Ger�ek veri seti �rnek:
--2022 y�l� mart ay�nda 20 ile 30 ya� aras� m��terilerin verdi�i sipari�leri listeleyiniz.
-- yas almak i�in datediff kullan�l�yor.
SELECT U.NAMESURNAME KULLANICI,DATEDIFF(YEAR,U.BIRTHDATE,GETDATE()) YAS,
C.CITY SEHIR ,O.DATE_ TARIH ,O.ID SIPARISID,O.TOTALPRICE TOPLAMTUTAR
FROM USERS U
JOIN ADDRESS A ON A.USERID=U.ID
JOIN CITIES C ON C.ID=A.CITYID
JOIN ORDERS O ON O.ADDRESSID=A.ID
WHERE DATEDIFF(YEAR,U.BIRTHDATE,GETDATE()) BETWEEN 20 AND 30 AND 
DATE_ BETWEEN '2022-03-01' AND '2022-03-31 23:59:59'
--�RNEK 3 :KULLANICILARIN HANG� SEH�RDE KA� ADRES� OLDU�U B�LG�S�N� GET�R�N�Z.
SELECT U.ID KULLANICIID,U.NAMESURNAME,C.CITY,COUNT(A.ID) ADRESSAYISI FROM USERS U
JOIN ADDRESS A ON A.USERID=U.ID
JOIN CITIES C ON C.ID=A.CITYID
GROUP BY U.ID ,U.NAMESURNAME,C.CITY
ORDER BY U.NAMESURNAME
--�rnek 4: �STANBULDA YILIN �LK �� AYINDA EN �OK SATI� YAPILAN 10 �R�N� GET�REN SORGUYU YAZINIZ.
SELECT TOP 10
C.CITY SEHIR ,I.ITEMCODE URUNKODU,I.ITEMNAME URUNADI,I.BRAND MARKA,I.CATEGORY1 KAT1,
I.CATEGORY2 KAT2,I.CATEGORY3 KAT3,SUM(OD.AMOUNT) TOPLAMMIKTAR,
SUM(OD.LINETOTAL) TOPLAMTUTAR FROM ORDERS O 
JOIN ORDERDETAILS OD ON OD.ORDERID=O.ID
JOIN ITEMS I ON I.ID=OD.ITEMID
JOIN ADDRESS A ON A.ID=O.ADDRESSID
JOIN CITIES C ON C.ID=A.CITYID
WHERE CITY='�STANBUL' AND DATE_ BETWEEN '20220101' AND '2022-03-31 23:59:59'
GROUP BY C.CITY,I.ITEMCODE,I.ITEMNAME,I.BRAND,I.CATEGORY1,I.CATEGORY2,I.CATEGORY3,O.TOTALPRICE
ORDER BY SUM(OD.LINETOTAL) DESC
--ger�ek veri seti �rnek 8 : haftan�n g�nlerine g�re ne kadar al��veri� yap�ld��� bilgisini getiren SQL sorgusunu yaz�n�z.
SELECT DATENAME(DW,DATE_) GUNADI,	--DATEPART g�n numaras�n� getirir.DATENAME de g�n ad�n� getirir.
SUM(TOTALPRICE) AS TOPLAMTUTAR, COUNT(ID)
FROM ORDERS
GROUP BY DATEPART(DW,DATE_),DATENAME(DW,DATE_)
ORDER BY DATEPART(DW,DATE_)
--ger�ek veri seti �rnek 9:saat aral���na g�re ne kadar al��veri� yap�ld���n� getiriniz
SELECT DATEPART(HOUR,DATE_)	SAAT,--DATEPART HOUR �LE SAAT ARALI�INI ��RENEB�L�R�Z 
SUM(TOTALPRICE) TOPLAMTUTAR, COUNT(ID) SIPARISSAYISI
FROM ORDERS
GROUP BY DATEPART(HOUR,DATE_)
ORDER BY 1
--�RNEK 10:Her bir sipari� i�in sevk etme s�resini getiren sorguyu yaz�n�z.
SELECT O.ID SIPARISID ,U.NAMESURNAME KULLANICIADI ,
C.CITY SEHIR,O.DATE_ SIPARISTARIHI , I.DATE_ SEVKIYATTARIHI,
DATEDIFF(HOUR,O.DATE_ , I.DATE_) SEVKEDILMESURESI
FROM ORDERS O 
JOIN USERS U ON U.ID=O.USERID
JOIN ADDRESS A ON A.ID=O.ADDRESSID
JOIN CITIES C ON C.ID=A.CITYID
JOIN INVOICES I ON I.ORDERID=O.ID
ORDER BY O.ID
--�RNEK 11:Sipari�lerin genel olarak, b�lgelere g�re ve �ehirlere g�re ortalama sevketme s�relerini
--getiren sorguyu yaz�n�z.
--1.Genel olarak;
SELECT 
AVG(DATEDIFF(HOUR,O.DATE_ , I.DATE_)) ORT_SEVKEDILMESAATI
FROM ORDERS O 
JOIN ADDRESS A ON A.ID=O.ADDRESSID
JOIN CITIES C ON C.ID=A.CITYID
JOIN INVOICES I ON I.ORDERID=O.ID
--2.B�LGEYE G�RE;
SELECT C.REGION BOLGE,
AVG(DATEDIFF(HOUR,O.DATE_ , I.DATE_ )* 1.0) ORT_SEVKEDILMESAATI
FROM ORDERS O 
JOIN ADDRESS A ON A.ID=O.ADDRESSID
JOIN CITIES C ON C.ID=A.CITYID
JOIN INVOICES I ON I.ORDERID=O.ID
GROUP BY C.REGION
--3.Sehirlere g�re,
SELECT C.CITY SEHIR,
AVG(DATEDIFF(HOUR,O.DATE_ , I.DATE_)* 1.0) ORT_SEVKEDILMESAATI
FROM ORDERS O 
JOIN ADDRESS A ON A.ID=O.ADDRESSID
JOIN CITIES C ON C.ID=A.CITYID
JOIN INVOICES I ON I.ORDERID=O.ID
GROUP BY C.CITY
--�rnek 12:Sipari� tarihinin ay� ile fatura tarihinin ay� farkl� olan sipari�leri getiriniz.
SELECT O.ID SIPARISNO,O.DATE_ SIPARISTARIHI, I.DATE_ FATURATARIHI, O.TOTALPRICE TOPLAMTUTAR,
DATENAME(MONTH,O.DATE_) SIPARIS_AYI, DATENAME(MONTH,I.DATE_) FATURA_AYI
FROM ORDERS O 
JOIN INVOICES I ON I.ORDERID=O.ID
WHERE DATENAME(MONTH,O.DATE_) <> DATENAME(MONTH,I.DATE_)	--<> bu i�aret farkl� anlam�na gelmektedir.
--�rnek-13: Her ay i�in sipari� tarihinin ay� ile fatura tarihinin ay� farkl� olan sipari� say�lar�n� getiriniz.
SELECT
DATENAME(MONTH,O.DATE_) SIPARIS_AYI,COUNT(DATENAME(MONTH,I.DATE_)) 
FATURASI_SONRAKI_AY_KESILEN_SIPARIS_sAYISI
FROM ORDERS O
JOIN INVOICES I ON I.ORDERID=O.ID
WHERE DATENAME(MONTH,O.DATE_) <> DATENAME(MONTH,I.DATE_)
GROUP BY DATENAME(MONTH,O.DATE_),DATEPART(MONTH,O.DATE_)
ORDER BY DATEPART(MONTH,O.DATE_)
--�RNEK-14:Her bir �ehirde ne kadar erkek ne kadar kad�n kullan�c� oldu�unu getiren sorguyu yaz�n�z.
SELECT 
C.CITY SEHIR,U.GENDER CINSIYET,COUNT(U.ID) KULLANICI_SAYISI
FROM USERS U 
JOIN ADDRESS A ON A.USERID=U.ID
JOIN CITIES C ON C.ID=A.CITYID
GROUP BY C.CITY ,U.GENDER
ORDER BY 1
--�rnek 15:�r�n kategorilerini alfabetik olarak ana kategori ve en �ok satan alt kategori olacak �ekilde getiriniz.
SELECT 
I.CATEGORY1 ANA_KATEGORI,I.CATEGORY2 ALT_KATEGORI,SUM(O.TOTALPRICE) TOPLAMSATIS
FROM ITEMS I
JOIN ORDERDETAILS OD ON OD.ITEMID=I.ID
JOIN ORDERS O ON O.ID=OD.ORDERID
GROUP BY I.CATEGORY1,I.CATEGORY2
ORDER BY 1,3 DESC
--�rnek 16:Deterjan Temizlik ve G�da kategorilerindeki �r�nlerin b�lgelere g�re yap�lan toplam sat��lar�n�
--getiriniz. Items tablosu ,cities tablosu,orderdetails
SELECT 
C.REGION BOLGE,I.CATEGORY1 URUN_KATEGORISI ,SUM(OD.LINETOTAL) TOPLAMSATIS
FROM ORDERDETAILS OD 
JOIN ITEMS I ON I.ID=OD.ITEMID
JOIN ORDERS O ON O.ID=OD.ORDERID
JOIN ADDRESS A ON A.ID=O.ADDRESSID
JOIN CITIES C ON C.ID=A.CITYID
WHERE I.CATEGORY1='DETERJAN TEM�ZL�K' AND 'GIDA' --??
GROUP BY C.REGION,I.CATEGORY1
ORDER BY BOLGE

--�RNEK 17: Her bir �r�n i�in toplam ne kadar sat�� yap�ld���n� adet ve toplam ciro olarak getiriniz.Ayr�ca her bir 
--�r�n i�in en d���k, en y�ksek ve ortalama sat�� ve mevcut fiyata g�re kar-zarar yapan sorguyu yaz�n�z.
--	SQL sorgusunu sanki bir tabloymu� gibi kullanarak i� i�e sorgular yazd�k."Dynamic view"
SELECT 
I.ITEMCODE URUNKODU,I.ITEMNAME URUNADI, I.UNITPRICE BIRIM_FIYAT,
SUM(OD.AMOUNT) TOPLAM_ADET,ROUND(SUM(OD.LINETOTAL),0)TOPLAM_SATIS,
MIN(OD.UNITPRICE) ENDUSUK_FIYAT,MAX(OD.UNITPRICE) ENYUKSEK_FIYAT,
ROUND(AVG(OD.UNITPRICE),2) ORTALAMA_FIYAT, ROUND(SUM(I.UNITPRICE*OD.AMOUNT),0) LISTE_FIYATI_SATIS,
ROUND((SUM(OD.LINETOTAL)-SUM(I.UNITPRICE*OD.AMOUNT)),0) KAR_ZARAR,
ROUND(100*(SUM(OD.LINETOTAL)-SUM(I.UNITPRICE*OD.AMOUNT))
/SUM(I.UNITPRICE*OD.AMOUNT),2) KAR_ZARAR_YUZDE
FROM ORDERDETAILS OD 
JOIN ITEMS I ON I.ID =OD.ITEMID
GROUP BY I.ITEMCODE ,I.ITEMNAME ,I.UNITPRICE
ORDER BY I.ITEMCODE
--�RNEK 18: Al�� liste fiyat� ve sat�� liste fiyat� ile sat�lan miktar �zerinden en �ok kar elde edilen 10 �r�n ile
--en az kar edilen 10 �r�n� listeleyiniz.
--En �ok kar edilen 10 �r�n
SELECT TOP 10 *,
TOPLAM_SATIS-LISTE_FIYATI_SATIS KAR_ZARAR,
ROUND(100*(TOPLAM_SATIS-LISTE_FIYATI_SATIS)/LISTE_FIYATI_SATIS,2) KAR_ZARAR_YUZDE
FROM
(
SELECT 
	I.ITEMCODE URUNKODU,I.ITEMNAME URUNADI, I.UNITPRICE BIRIM_FIYAT,
	SUM(OD.AMOUNT) TOPLAM_ADET,ROUND(SUM(OD.LINETOTAL),0)TOPLAM_SATIS,
	MIN(OD.UNITPRICE) ENDUSUK_FIYAT,MAX(OD.UNITPRICE) ENYUKSEK_FIYAT,
	ROUND(AVG(OD.UNITPRICE),2) ORTALAMA_FIYAT, ROUND(SUM(I.UNITPRICE*OD.AMOUNT),0) LISTE_FIYATI_SATIS
FROM ORDERDETAILS OD 
JOIN ITEMS I ON I.ID =OD.ITEMID
GROUP BY I.ITEMCODE ,I.ITEMNAME ,I.UNITPRICE
)T
ORDER BY KAR_ZARAR_YUZDE DESC
--En az kar edilen 10 �r�n
SELECT TOP 10 *,
TOPLAM_SATIS-LISTE_FIYATI_SATIS KAR_ZARAR,
ROUND(100*(TOPLAM_SATIS-LISTE_FIYATI_SATIS)/LISTE_FIYATI_SATIS,2) KAR_ZARAR_YUZDE
FROM
(
SELECT 
	I.ITEMCODE URUNKODU,I.ITEMNAME URUNADI, I.UNITPRICE BIRIM_FIYAT,
	SUM(OD.AMOUNT) TOPLAM_ADET,ROUND(SUM(OD.LINETOTAL),0)TOPLAM_SATIS,
	MIN(OD.UNITPRICE) ENDUSUK_FIYAT,MAX(OD.UNITPRICE) ENYUKSEK_FIYAT,
	ROUND(AVG(OD.UNITPRICE),2) ORTALAMA_FIYAT, ROUND(SUM(I.UNITPRICE*OD.AMOUNT),0) LISTE_FIYATI_SATIS
FROM ORDERDETAILS OD 
JOIN ITEMS I ON I.ID =OD.ITEMID
GROUP BY I.ITEMCODE ,I.ITEMNAME ,I.UNITPRICE
)T
ORDER BY KAR_ZARAR_YUZDE ASC		--Hi�bir �ey yazmazsak da en az kar edilenleri d�nd�r�r.
--Subquery Konusu
--Her bir kullan�c�n�n sahip oldu�u adres say�s�,geleneksel y�ntem
SELECT 
U.ID KULLANICI_ID,U.NAMESURNAME ADSOYAD, COUNT(A.ID) ADRESSAYISI
FROM USERS U ,ADDRESS A
WHERE A.USERID=U.ID
GROUP BY U.ID ,U.NAMESURNAME
ORDER BY 1
--join y�ntemi
SELECT 
U.ID KULLANICI_ID,U.NAMESURNAME ADSOYAD, COUNT(A.ID) ADRESSAYISI
FROM USERS U 
JOIN ADDRESS A ON A.USERID=U.ID
GROUP BY U.ID ,U.NAMESURNAME
ORDER BY 1
--subquery y�ntemi
SELECT
U.ID KULLANICI_ID,U.NAMESURNAME ADSOYAD,
(SELECT COUNT(*) FROM ADDRESS WHERE USERID=U.ID) ADRESSAYISI
FROM USERS U
--�ehri �stanbul olan sat��lar� getirme
SELECT 
O.ID,O.DATE_,O.TOTALPRICE
FROM ORDERS O 
WHERE ADDRESSID IN 
(--Birden fazla alan d�nd���nde 'in' i kullan�r�z ama tek alan d�nerse '=' de kullanabiliriz.
	SELECT ID FROM ADDRESS	
		WHERE CITYID IN --burada = de kullan�labilir.
			(SELECT ID FROM CITIES WHERE CITY='�stanbul')
)
--�rnek1:Her �r�n i�in toplam sat�� adedi, toplam sat�� cirosu,en d���k sat�� fiyat� ve ortalama 
--sat�� fiyat�n� getiren sorguyu subquery kullanarak getiriniz.
--Urun analizi:JOIN ile
SELECT I.ITEMCODE URUNKODU,I.ITEMNAME URUNADI,I.BRAND MARKA,
SUM(OD.AMOUNT) TOPLAM_ADET, SUM(OD.LINETOTAL) TOPLAM_CIRO,
MIN(OD.UNITPRICE) ENDUSUK_FIYAT,MAX(OD.UNITPRICE) ENYUKSEK_FIYAT,
ROUND(AVG(OD.UNITPRICE),2) ORTALAMA_FIYAT
FROM ITEMS I 
LEFT JOIN ORDERDETAILS OD ON OD.ITEMID=I.ID
GROUP BY I.ITEMCODE ,I.ITEMNAME ,I.BRAND		--OUTPUT ROWS:1366
--Urun analizi: SUBQUERY ile
SELECT I.ITEMCODE URUNKODU,I.ITEMNAME URUNADI,I.BRAND MARKA,
(SELECT SUM(AMOUNT) FROM ORDERDETAILS WHERE ITEMID=I.ID) TOPLAM_ADET,
(SELECT SUM(LINETOTAL) FROM ORDERDETAILS WHERE ITEMID=I.ID) TOPLAM_CIRO,
(SELECT MIN(UNITPRICE) FROM ORDERDETAILS WHERE ITEMID=I.ID) ENDUSUK_FIYAT,
(SELECT MAX(UNITPRICE) FROM ORDERDETAILS WHERE ITEMID=I.ID) ENYUKSEK_FIYAT,
(SELECT ROUND(AVG(UNITPRICE),2) FROM ORDERDETAILS WHERE ITEMID=I.ID) ORTALAMA_FIYAT
FROM ITEMS I									--OUTPUT ROWS:1367
--JOIN VE SUBQUERY ARASINDAKI FARKLARI NELERDIR? HANGI DURUMLARDA SUBQUERY HANGI DURUMLARDA JOIN KULLANILMALIDIR?
--Subquery daha okunabilir fakat daha karma��k, ilk g�r��te join daha avantajl� gibi
--Items tablosunda olan fakat hi�bir sat��� olmayan veriler gelmiyor.
--Join de �r�n bilgileri geliyor fakat sat�� bilgileri gelmiyor Bunu �nlemek i�in join yerine left join kullan�labilir.
--Bir sorgunun performans�na bakarken cpu kullan�m�n�na ya da ne kadar okuma yapt���na(*) bakar�z.
--Sorgunun ba��na bu ifade yaz�l�nca ne kadar okuma yapt���n� bulabiliriz.

SET STATISTICS IO ON
SELECT 
I.ITEMCODE URUNKODU,I.ITEMNAME URUNADI,I.BRAND MARKA,
SUM(OD.AMOUNT) TOPLAM_ADET, SUM(OD.LINETOTAL) TOPLAM_CIRO,
MIN(OD.UNITPRICE) ENDUSUK_FIYAT,MAX(OD.UNITPRICE) ENYUKSEK_FIYAT,
ROUND(AVG(OD.UNITPRICE),2) ORTALAMA_FIYAT
FROM ITEMS I 
LEFT JOIN ORDERDETAILS OD ON OD.ITEMID=I.ID
GROUP BY I.ITEMCODE ,I.ITEMNAME ,I.BRAND		
select 1294+445+937=2676 --1 page 8 kb
select 2676*8=21408 --kb l�k okuma ger�ekle�tirir join tablosu(�rnek �zerinden okuma hesaplama)
--2943 Okuma ;Page SQL server datalar�n�n en k���k yap�ta��(8KB l�k bloklar)

SET STATISTICS IO ON
SELECT I.ITEMCODE URUNKODU,I.ITEMNAME URUNADI,I.BRAND MARKA,
		(SELECT SUM(AMOUNT) FROM ORDERDETAILS WHERE ITEMID=I.ID) TOPLAM_ADET

FROM ITEMS I
--2805
--Eklenen her bir alt sorgu i�in okuma nerdeyse %100 artmakta;sorgular teker teker eklenip bu durum test edilebilir.
SET STATISTICS IO ON
SELECT I.ITEMCODE URUNKODU,I.ITEMNAME URUNADI,I.BRAND MARKA,
		(SELECT SUM(AMOUNT) FROM ORDERDETAILS WHERE ITEMID=I.ID) TOPLAM_ADET,
		(SELECT SUM(LINETOTAL) FROM ORDERDETAILS WHERE ITEMID=I.ID) TOPLAM_CIRO,
		(SELECT MIN(UNITPRICE) FROM ORDERDETAILS WHERE ITEMID=I.ID) ENDUSUK_FIYAT
FROM ITEMS I 
--�ki komut daha eklenince okuma 7580 e ��kt�.
--SONU�:Subquery ler join e g�re daha yava�t�rlar ��nk� daha fazla okuma i�lemi ger�ekle�tirirler.Sorgular� m�mk�nse
--join ile yapmal�y�z .En k�t� durumda e�er join ile ya da ba�ka bir �ekilde yapamazsak o zaman subquery kullan�lmal�
--20.07.2024
--subquery-join kar��la�t�rmas�
--joinler bo� verileri vermiyor ancak subquery de bo� olan verileri de yani hepsini g�rebiliriz.
--�RNEK1:Her marka i�in toplam �r�n say�s�,toplam ana kategori ve alt kategori say�s�n� getiren subquery yi yaz�n�z.
SELECT DISTINCT BRAND MARKA,
(SELECT COUNT(DISTINCT CATEGORY1) FROM ITEMS I WHERE BRAND=I.BRAND) ANAKATEGORI_SAYISI,
(SELECT COUNT(DISTINCT CATEGORY2) FROM ITEMS I WHERE BRAND=I.BRAND) ALTKATEGORI_SAYISI,
(SELECT COUNT(ID) FROM ITEMS I WHERE BRAND=I.BRAND) URUN_SAYISI
FROM ITEMS I 
--�RNEK2: G�da ve Deterjan-Temizlik katorilerinin hangi �ehirde ne kadar sat�ld���n� yanyana getiren sql c�mlesini subquery ile yaz�n�z.
--g�da ve det tem s�tunlar�n� yan yana g�rmek ve ayn� zamanda daha az sat�rda getirmek i�in subquery kulland�k.
SELECT
CITY SEHIR,
(		SELECT SUM(OD.LINETOTAL) FROM ORDERS O
		JOIN ORDERDETAILS OD ON OD.ORDERID=O.ID
		JOIN ADDRESS A ON A.ID=O.ADDRESSID
		JOIN ITEMS I ON I.ID=OD.ITEMID
		WHERE I.CATEGORY1='GIDA' AND A.CITYID=C.ID
)GIDA ,
(		SELECT SUM(OD.LINETOTAL) FROM ORDERS O
		JOIN ORDERDETAILS OD ON OD.ORDERID=O.ID
		JOIN ADDRESS A ON A.ID=O.ADDRESSID
		JOIN ITEMS I ON I.ID=OD.ITEMID
		WHERE I.CATEGORY1='DETERJAN TEM�ZL�K' AND A.CITYID=C.ID
)  DETERJAN_TEMIZLIK
FROM CITIES C
--�rnek4(Subquery):Her bir �ehir i�in ka� erkek, ka� kad�n	m��teri oldu�unu Erkek ve Kad�n s�tunlar� yan yana olacak �ekilde getiriniz.
SELECT 
CITY SEHIR,
(SELECT COUNT(DISTINCT USERID) FROM USERS U
JOIN ADDRESS A ON A.USERID=U.ID
WHERE U.GENDER='E' AND A.CITYID=C.ID) ERKEKSAYISI,
(SELECT COUNT(DISTINCT USERID) FROM USERS U
JOIN ADDRESS A ON A.USERID=U.ID
WHERE U.GENDER='K' AND A.CITYID=C.ID) KADINSAYISI
FROM CITIES C
--�rnek5:�ehirlerin aylara g�re sat���n� aylar yukar�da yan yana s�tunlar olacak �ekilde getiriniz.
SELECT C.CITY SEHIR,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=1) OCAK ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=2) SUBAT ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=3) MART ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=4) NISAN ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=5) MAYIS ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=6) HAZIRAN ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=7) TEMMUZ ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=8) AGUSTOS ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=9) EYLUL ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=10) EKIM ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=11) KASIM ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=12) ARALIK ,
(SELECT 
ROUND(SUM(O.TOTALPRICE),0)
FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
WHERE A.CITYID=C.ID) TOPLAM
FROM CITIES C 
ORDER BY CITY
--�rnek6: B�lgelerin aylara g�re sat��lar�n� aylar yukar�da yan yana s�tun olacak �ekilde getiriniz.
SELECT BOLGE ,SUM(OCAK) OCAK,SUM(SUBAT) SUBAT,SUM(MART) MART,SUM(NISAN) NISAN,SUM(MAYIS) MAYIS,SUM(HAZIRAN) HAZIRAN,
SUM(TEMMUZ) TEMMUZ,SUM(AGUSTOS) AGUSTOS,SUM(EYLUL) EYLUL,SUM(EKIM) EKIM,SUM(KASIM) KASIM,SUM(ARALIK) ARALIK,SUM(TOPLAM)
TOPLAM

FROM
(SELECT C.REGION BOLGE,C.CITY,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=1) OCAK ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=2) SUBAT ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=3) MART ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=4) NISAN ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=5) MAYIS ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=6) HAZIRAN ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=7) TEMMUZ ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=8) AGUSTOS ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=9) EYLUL ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=10) EKIM ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=11) KASIM ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID AND DATEPART(MONTH,O.DATE_)=12) ARALIK ,
	(SELECT ROUND(SUM(O.TOTALPRICE),0) FROM ORDERS O
	JOIN ADDRESS A ON A.ID=O.ADDRESSID
	WHERE A.CITYID=C.ID) TOPLAM

FROM CITIES C )
T
GROUP BY BOLGE
ORDER BY BOLGE
--24.07.2024
--�rnek7(subquery):Her bir �ehir i�in en �ok al��veri� yap�lan kategori ile en az al��veri� yap�lan kategorileri(CATEGORY2) getiren sorguyu yaz�n�z
--totalprice,�ehir baz�nda categori2 deki en �ok ve en az
SELECT C.CITY SEHIR,
(SELECT TOP 1 I.CATEGORY2 FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
JOIN ORDERDETAILS OD ON OD.ORDERID=O.ID
JOIN ITEMS I ON I.ID=OD.ITEMID
WHERE A.CITYID=C.ID
GROUP BY  I.CATEGORY2
ORDER BY SUM(OD.LINETOTAL) DESC
) EN_FAZLA_SATIS_YAPILAN_KATEGORI,

(SELECT TOP 1 SUM(OD.LINETOTAL) FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
JOIN ORDERDETAILS OD ON OD.ORDERID=O.ID
JOIN ITEMS I ON I.ID=OD.ITEMID
WHERE A.CITYID=C.ID
GROUP BY  I.CATEGORY2
ORDER BY SUM(OD.LINETOTAL) DESC
) TUTAR,
(SELECT TOP 1 I.CATEGORY2 FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
JOIN ORDERDETAILS OD ON OD.ORDERID=O.ID
JOIN ITEMS I ON I.ID=OD.ITEMID
WHERE A.CITYID=C.ID
GROUP BY  I.CATEGORY2
ORDER BY SUM(OD.LINETOTAL) ASC
) EN_AZ_SATIS_YAPILAN_KATEGORI,

(SELECT TOP 1 SUM(OD.LINETOTAL) FROM ORDERS O
JOIN ADDRESS A ON A.ID=O.ADDRESSID
JOIN ORDERDETAILS OD ON OD.ORDERID=O.ID
JOIN ITEMS I ON I.ID=OD.ITEMID
WHERE A.CITYID=C.ID
GROUP BY  I.CATEGORY2
ORDER BY SUM(OD.LINETOTAL) ASC
) TUTAR

FROM CITIES C 
--�rnek8:Her bir �ehir i�in en �ok al��veri� yap�lan marka ile en az al��veri� yap�lan markalar� getiren sorgu.
--Bu �rne�in videosu a��lmad�
--�rnek9:Her bir marka i�in en �ok sat�lan kategorileri ve en az sat�lan kategorileri getiren sorgu
SELECT DISTINCT BRAND,
	(SELECT TOP 1 I.CATEGORY1 FROM ORDERDETAILS OD
	JOIN ITEMS I ON I.ID = OD.ITEMID
	WHERE I.BRAND=I1.BRAND
	GROUP BY I.CATEGORY1 ORDER BY SUM(OD.LINETOTAL) DESC
) EN_FAZLA_SATILAN_KATEGORI,
	(SELECT TOP 1 SUM(OD.LINETOTAL) FROM ORDERDETAILS OD
	JOIN ITEMS I ON I.ID = OD.ITEMID
	WHERE I.BRAND=I1.BRAND
	GROUP BY I.CATEGORY1 ORDER BY SUM(OD.LINETOTAL) DESC
) TUTAR,
	(SELECT TOP 1 I.CATEGORY1 FROM ORDERDETAILS OD
	JOIN ITEMS I ON I.ID = OD.ITEMID
	WHERE I.BRAND=I1.BRAND
	GROUP BY I.CATEGORY1 ORDER BY SUM(OD.LINETOTAL) ASC
) EN_AZ_SATILAN_KATEGORI,
	(SELECT TOP 1 SUM(OD.LINETOTAL) FROM ORDERDETAILS OD
	JOIN ITEMS I ON I.ID = OD.ITEMID
	WHERE I.BRAND=I1.BRAND
	GROUP BY I.CATEGORY1 ORDER BY SUM(OD.LINETOTAL) ASC
) TUTAR
FROM ITEMS I1
--Her bir kategori i�in	en �ok sat�lan marka ve en az sat�lan markay� yanyana yazd�r�n.
SELECT DISTINCT I1.CATEGORY1 KATEGORI ,
(	SELECT TOP 1 I.BRAND FROM ORDERDETAILS OD
	JOIN ITEMS I ON I.ID=OD.ITEMID
	WHERE I.CATEGORY1=I1.CATEGORY1
	GROUP BY I.BRAND
	ORDER BY SUM(OD.LINETOTAL) DESC
) EN_FAZLA_SATILAN_MARKA,
(	SELECT TOP 1 SUM(OD.LINETOTAL) FROM ORDERDETAILS OD
	JOIN ITEMS I ON I.ID=OD.ITEMID
	WHERE I.CATEGORY1=I1.CATEGORY1
	GROUP BY I.BRAND
	ORDER BY SUM(OD.LINETOTAL) ASC
) TUTAR,
(	SELECT TOP 1 I.BRAND FROM ORDERDETAILS OD
	JOIN ITEMS I ON I.ID=OD.ITEMID
	WHERE I.CATEGORY1=I1.CATEGORY1
	GROUP BY I.BRAND
	ORDER BY SUM(OD.LINETOTAL) ASC
) EN_AZ_SATILAN_MARKA,
(	SELECT TOP 1 SUM(OD.LINETOTAL) FROM ORDERDETAILS OD
	JOIN ITEMS I ON I.ID=OD.ITEMID
	WHERE I.CATEGORY1=I1.CATEGORY1
	GROUP BY I.BRAND
	ORDER BY SUM(OD.LINETOTAL) DESC
) TUTAR
FROM ITEMS I1 
--04.08.24 Pazar:11. �rnekteyim 


