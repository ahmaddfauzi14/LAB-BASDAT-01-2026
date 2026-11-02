CREATE TABLE Anggota(
	id_anggota INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nama_anggota VARCHAR(50) NOT NULL,
	kota_domisili VARCHAR (20) NOT NULL
)

CREATE TABLE Buku(
	id_buku INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	judul_buku VARCHAR(100) NOT NULL,
	genre VARCHAR(20) NOT NULL,
	stok INT DEFAULT 1
)

CREATE TABLE Peminjaman(
	id_peminjaman INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	id_anggota INT,
	CONSTRAINT fk_peminjaman_anggota
		FOREIGN KEY (id_anggota)
		REFERENCES Anggota(id_anggota),
	id_buku INT,
	CONSTRAINT fk_peminjaman_buku
		FOREIGN KEY (id_buku)
		REFERENCES Buku(id_buku),
	tanggal_pinjam DATE NOT NULL,
	tanggal_kembali DATE,
	denda INT DEFAULT 0
)

CREATE INDEX index_genre
ON Buku(genre)

CREATE INDEX index_kota_domisili
ON Anggota(kota_domisili)
