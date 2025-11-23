-- DATABASE AZIENDA AGRICOLA MENFI
-- Portfolio Data Analysis & Data Science
-- Triennio 2023-2025

CREATE DATABASE IF NOT EXISTS azienda_menfi;
USE azienda_menfi;

-- ==========================================
-- TABELLE ANAGRAFICHE
-- ==========================================

-- Contrade e terreni
CREATE TABLE contrade (
    id_contrada INT PRIMARY KEY AUTO_INCREMENT,
    nome_contrada VARCHAR(100) NOT NULL,
    ettari_totali DECIMAL(10,2),
    tipo_produzione ENUM('vigneto', 'uliveto', 'seminato', 'misto') NOT NULL
);

CREATE TABLE vigneti (
    id_vigneto INT PRIMARY KEY AUTO_INCREMENT,
    id_contrada INT,
    vitigno VARCHAR(50) NOT NULL,
    ettari DECIMAL(10,2) NOT NULL,
    anno_impianto YEAR,
    densita_ceppi_ha INT,
    FOREIGN KEY (id_contrada) REFERENCES contrade(id_contrada)
);

CREATE TABLE uliveti (
    id_uliveto INT PRIMARY KEY AUTO_INCREMENT,
    id_contrada INT,
    cultivar VARCHAR(50) NOT NULL,
    ettari DECIMAL(10,2) NOT NULL,
    anno_impianto YEAR,
    numero_piante INT,
    FOREIGN KEY (id_contrada) REFERENCES contrade(id_contrada)
);

CREATE TABLE seminati (
    id_seminato INT PRIMARY KEY AUTO_INCREMENT,
    id_contrada INT,
    tipo_cereale VARCHAR(50) NOT NULL,
    ettari DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_contrada) REFERENCES contrade(id_contrada)
);

-- Prodotti finiti
CREATE TABLE vini (
    id_vino INT PRIMARY KEY AUTO_INCREMENT,
    nome_vino VARCHAR(100) NOT NULL,
    tipologia ENUM('Bianco', 'Rosso', 'Rosè', 'Frizantino', 'Spumante') NOT NULL,
    vitigni_blend VARCHAR(200),
    affinamento ENUM('Acciaio', 'Legno', 'Misto') NOT NULL,
    formato ENUM('0.75cl', 'Magnum') NOT NULL,
    categoria_qualita ENUM('Alta', 'Media', 'Bassa') NOT NULL,
    prezzo_medio DECIMAL(10,2)
);

CREATE TABLE oli (
    id_olio INT PRIMARY KEY AUTO_INCREMENT,
    nome_olio VARCHAR(100) NOT NULL,
    tipo ENUM('Monocultivar', 'Blend') NOT NULL,
    cultivar_composizione VARCHAR(200),
    categoria_qualita ENUM('Alta', 'Media') NOT NULL,
    formato VARCHAR(20),
    prezzo_medio DECIMAL(10,2)
);

CREATE TABLE birre (
    id_birra INT PRIMARY KEY AUTO_INCREMENT,
    nome_birra VARCHAR(100) NOT NULL,
    stile VARCHAR(50),
    categoria_qualita ENUM('Alta', 'Media') NOT NULL,
    formato VARCHAR(20),
    prezzo_medio DECIMAL(10,2)
);

-- ==========================================
-- TABELLE PRODUZIONE
-- ==========================================

CREATE TABLE produzione_vino (
    id_produzione INT PRIMARY KEY AUTO_INCREMENT,
    anno INT NOT NULL,
    id_vino INT,
    id_contrada INT,
    quintali_uva_raccolti DECIMAL(10,2),
    litri_prodotti DECIMAL(12,2),
    bottiglie_prodotte INT,
    resa_percentuale DECIMAL(5,2),
    data_vendemmia DATE,
    FOREIGN KEY (id_vino) REFERENCES vini(id_vino),
    FOREIGN KEY (id_contrada) REFERENCES contrade(id_contrada)
);

CREATE TABLE produzione_olio (
    id_produzione INT PRIMARY KEY AUTO_INCREMENT,
    anno INT NOT NULL,
    id_olio INT,
    id_contrada INT,
    quintali_olive_raccolte DECIMAL(10,2),
    litri_prodotti DECIMAL(12,2),
    resa_percentuale DECIMAL(5,2),
    data_raccolta DATE,
    FOREIGN KEY (id_olio) REFERENCES oli(id_olio),
    FOREIGN KEY (id_contrada) REFERENCES contrade(id_contrada)
);

CREATE TABLE produzione_birra (
    id_produzione INT PRIMARY KEY AUTO_INCREMENT,
    anno INT NOT NULL,
    id_birra INT,
    quintali_cereali_usati DECIMAL(10,2),
    litri_prodotti DECIMAL(12,2),
    bottiglie_prodotte INT,
    data_produzione DATE,
    FOREIGN KEY (id_birra) REFERENCES birre(id_birra)
);

-- ==========================================
-- TABELLE VENDITE
-- ==========================================

CREATE TABLE canali_vendita (
    id_canale INT PRIMARY KEY AUTO_INCREMENT,
    nome_canale VARCHAR(100) NOT NULL,
    tipo_canale ENUM('Export', 'Italia', 'Diretto') NOT NULL,
    categoria ENUM('Enoteca', 'Ristorante', 'Supermercato', 'Wine Resort', 'Online') NOT NULL
);

CREATE TABLE vendite_vino (
    id_vendita INT PRIMARY KEY AUTO_INCREMENT,
    anno INT NOT NULL,
    mese INT NOT NULL,
    id_vino INT,
    id_canale INT,
    paese VARCHAR(50),
    bottiglie_vendute INT,
    ricavo_totale DECIMAL(12,2),
    FOREIGN KEY (id_vino) REFERENCES vini(id_vino),
    FOREIGN KEY (id_canale) REFERENCES canali_vendita(id_canale)
);

CREATE TABLE vendite_olio (
    id_vendita INT PRIMARY KEY AUTO_INCREMENT,
    anno INT NOT NULL,
    mese INT NOT NULL,
    id_olio INT,
    id_canale INT,
    paese VARCHAR(50),
    litri_venduti DECIMAL(10,2),
    ricavo_totale DECIMAL(12,2),
    FOREIGN KEY (id_olio) REFERENCES oli(id_olio),
    FOREIGN KEY (id_canale) REFERENCES canali_vendita(id_canale)
);

CREATE TABLE vendite_birra (
    id_vendita INT PRIMARY KEY AUTO_INCREMENT,
    anno INT NOT NULL,
    mese INT NOT NULL,
    id_birra INT,
    id_canale INT,
    paese VARCHAR(50),
    bottiglie_vendute INT,
    ricavo_totale DECIMAL(12,2),
    FOREIGN KEY (id_birra) REFERENCES birre(id_birra),
    FOREIGN KEY (id_canale) REFERENCES canali_vendita(id_canale)
);

-- ==========================================
-- TABELLA WINE RESORT
-- ==========================================

CREATE TABLE wine_resort_presenze (
    id_presenza INT PRIMARY KEY AUTO_INCREMENT,
    anno INT NOT NULL,
    mese INT NOT NULL,
    numero_ospiti INT,
    notti_totali INT,
    ricavo_camere DECIMAL(12,2),
    ricavo_ristorazione DECIMAL(12,2),
    ricavo_degustazioni DECIMAL(12,2),
    paese_provenienza VARCHAR(50)
);

-- ==========================================
-- INDICI PER PERFORMANCE
-- ==========================================

CREATE INDEX idx_anno_produzione_vino ON produzione_vino(anno);
CREATE INDEX idx_anno_vendite_vino ON vendite_vino(anno, mese);
CREATE INDEX idx_canale_vendite ON vendite_vino(id_canale);
CREATE INDEX idx_paese_vendite ON vendite_vino(paese);

-- ==========================================
-- INSERIMENTO DATI ANAGRAFICI
-- ==========================================

-- Contrade
INSERT INTO contrade (nome_contrada, ettari_totali, tipo_produzione) VALUES
('Santa Caterina', 100, 'vigneto'),
('Gurra Soprana', 50, 'vigneto'),
('Bertolino', 85, 'misto'),
('Finocchio', 15, 'uliveto'),
('Torrenova Agareni', 100, 'misto');

-- Vigneti Santa Caterina
INSERT INTO vigneti (id_contrada, vitigno, ettari, anno_impianto, densita_ceppi_ha) VALUES
(1, 'Chardonnay', 18, 2010, 5000),
(1, 'Syrah', 20, 2012, 4500),
(1, 'Nero d''Avola', 25, 2008, 4800),
(1, 'Grillo', 15, 2011, 5200),
(1, 'Sauvignon Blanc', 12, 2013, 5000),
(1, 'Vermentino', 10, 2014, 4800);

-- Vigneti Gurra Soprana
INSERT INTO vigneti (id_contrada, vitigno, ettari, anno_impianto, densita_ceppi_ha) VALUES
(2, 'Grillo', 12, 2009, 5100),
(2, 'Viognier', 8, 2011, 4900),
(2, 'Merlot', 15, 2010, 4600),
(2, 'Grecanico', 8, 2012, 5000),
(2, 'Fiano', 4, 2015, 5200),
(2, 'Catarratto', 3, 2013, 5100);

-- Vigneti Bertolino
INSERT INTO vigneti (id_contrada, vitigno, ettari, anno_impianto, densita_ceppi_ha) VALUES
(3, 'Alicante', 10, 2009, 4500),
(3, 'Grecanico', 8, 2011, 5000),
(3, 'Vermentino', 9, 2012, 4800),
(3, 'Chenin Blanc', 6, 2014, 5100),
(3, 'Nero d''Avola', 10, 2010, 4700),
(3, 'Syrah', 7, 2013, 4600);

-- Uliveti
INSERT INTO uliveti (id_contrada, cultivar, ettari, anno_impianto, numero_piante) VALUES
(3, 'Nocellara del Belice', 15, 2005, 4500),
(3, 'Biancolilla', 10, 2006, 3000),
(3, 'Cerasuola', 10, 2007, 3000),
(4, 'Nocellara del Belice', 6, 2008, 1800),
(4, 'Biancolilla', 5, 2009, 1500),
(4, 'Cerasuola', 4, 2010, 1200);

-- Seminati
INSERT INTO seminati (id_contrada, tipo_cereale, ettari) VALUES
(5, 'Orzo', 30),
(5, 'Frumento', 20);

-- Vini (18 etichette)
INSERT INTO vini (nome_vino, tipologia, vitigni_blend, affinamento, formato, categoria_qualita, prezzo_medio) VALUES
-- Alta qualità
('Giga in Sol', 'Bianco', 'Catarratto 50%, Grecanico 30%, Chardonnay 20%', 'Acciaio', '0.75cl', 'Alta', 12.50),
('Allemande in Do', 'Rosso', 'Nero d''Avola 60%, Merlot 20%, Syrah 20%', 'Legno', '0.75cl', 'Alta', 15.00),
('Fuga in Re', 'Bianco', 'Fiano 100%', 'Acciaio', '0.75cl', 'Alta', 18.00),
('Toccata e Fuga', 'Rosso', 'Nero d''Avola 50%, Syrah 30%, Alicante 20%', 'Legno', '0.75cl', 'Alta', 35.00),
('Preludio e Fuga', 'Rosso', 'Nero d''Avola 50%, Syrah 30%, Alicante 20%', 'Legno', 'Magnum', 'Alta', 75.00),
('Orfeo', 'Bianco', 'Grillo 70%, Viognier 30%', 'Misto', '0.75cl', 'Alta', 22.00),
('Rosé di Monteverdi', 'Rosè', 'Nero d''Avola 100%', 'Acciaio', '0.75cl', 'Alta', 11.00),
('Brut Monteverdi', 'Spumante', 'Chardonnay 80%, Sauvignon Blanc 20%', 'Acciaio', '0.75cl', 'Alta', 25.00),
-- Media qualità
('Grillo Sicilia DOC', 'Bianco', 'Grillo 100%', 'Acciaio', '0.75cl', 'Media', 8.00),
('Nero d''Avola Sicilia DOC', 'Rosso', 'Nero d''Avola 100%', 'Acciaio', '0.75cl', 'Media', 9.00),
('Catarratto Lucido', 'Bianco', 'Catarratto 100%', 'Acciaio', '0.75cl', 'Media', 7.50),
('Syrah Sicilia IGT', 'Rosso', 'Syrah 100%', 'Misto', '0.75cl', 'Media', 10.00),
('Frizzantino Bianco', 'Frizantino', 'Grecanico 60%, Vermentino 40%', 'Acciaio', '0.75cl', 'Media', 7.00),
-- Bassa qualità
('Bianco da Tavola', 'Bianco', 'Catarratto 70%, Grecanico 30%', 'Acciaio', '0.75cl', 'Bassa', 4.50),
('Rosso da Tavola', 'Rosso', 'Nero d''Avola 80%, Syrah 20%', 'Acciaio', '0.75cl', 'Bassa', 5.00),
('Rosato Fresco', 'Rosè', 'Nero d''Avola 100%', 'Acciaio', '0.75cl', 'Bassa', 4.00),
('Bianco Frizzante', 'Frizantino', 'Catarratto 100%', 'Acciaio', '0.75cl', 'Bassa', 4.50),
('Collezione Famiglia', 'Rosso', 'Nero d''Avola 60%, Merlot 40%', 'Legno', 'Magnum', 'Alta', 45.00);

-- Oli (8 referenze)
INSERT INTO oli (nome_olio, tipo, cultivar_composizione, categoria_qualita, formato, prezzo_medio) VALUES
('Nocellara Monocultivar', 'Monocultivar', 'Nocellara del Belice 100%', 'Alta', '0.50L', 15.00),
('Biancolilla Monocultivar', 'Monocultivar', 'Biancolilla 100%', 'Alta', '0.50L', 14.00),
('Cerasuola Monocultivar', 'Monocultivar', 'Cerasuola 100%', 'Alta', '0.50L', 14.50),
('Blend Siciliano Premium', 'Blend', 'Nocellara 50%, Biancolilla 30%, Cerasuola 20%', 'Alta', '0.75L', 18.00),
('Blend Classico', 'Blend', 'Nocellara 40%, Biancolilla 30%, Cerasuola 30%', 'Alta', '0.50L', 12.00),
('Extra Vergine Selezione', 'Blend', 'Nocellara 60%, Cerasuola 40%', 'Alta', '1L', 20.00),
('Olio Linea Retail', 'Blend', 'Nocellara 50%, Biancolilla 50%', 'Media', '1L', 8.00),
('Olio da Tavola', 'Blend', 'Mix cultivar', 'Media', '1L', 6.50);

-- Birre (6 referenze)
INSERT INTO birre (nome_birra, stile, categoria_qualita, formato, prezzo_medio) VALUES
('Menfi IPA', 'India Pale Ale', 'Alta', '0.33L', 5.50),
('Blonde Ale Siciliana', 'Blonde Ale', 'Alta', '0.33L', 4.80),
('Ambrata Artigianale', 'Amber Ale', 'Alta', 'Alta', 5.20),
('Weiss Siciliana', 'Weiss', 'Alta', '0.50L', 6.00),
('Lager Chiara', 'Lager', 'Media', '0.33L', 3.20),
('Pilsner Classica', 'Pilsner', 'Media', '0.33L', 2.80);

-- Canali di vendita
INSERT INTO canali_vendita (nome_canale, tipo_canale, categoria) VALUES
-- Export
('Enoteche Europa', 'Export', 'Enoteca'),
('Enoteche USA', 'Export', 'Enoteca'),
('Enoteche Asia', 'Export', 'Enoteca'),
('Ristoranti Stellati Europa', 'Export', 'Ristorante'),
('Ristoranti Stellati USA', 'Export', 'Ristorante'),
('GDO Europa', 'Export', 'Supermercato'),
('GDO USA', 'Export', 'Supermercato'),
-- Italia
('Enoteche Nord Italia', 'Italia', 'Enoteca'),
('Enoteche Centro Italia', 'Italia', 'Enoteca'),
('Enoteche Sud Italia', 'Italia', 'Enoteca'),
('Ristoranti Stellati Italia', 'Italia', 'Ristorante'),
('Ristoranti Italia', 'Italia', 'Ristorante'),
('Supermercati Nazionali', 'Italia', 'Supermercato'),
('Supermercati Regionali', 'Italia', 'Supermercato'),
('Bar e Pub Italia', 'Italia', 'Ristorante'),
-- Diretto
('Wine Resort', 'Diretto', 'Wine Resort'),
('E-commerce Aziendale', 'Diretto', 'Online');

-- Note: I dati di produzione e vendite per il triennio 2023-2025 
-- verranno generati tramite script Python per garantire coerenza e realismo