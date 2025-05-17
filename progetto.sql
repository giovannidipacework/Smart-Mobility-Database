SET NAMES latin1;
DROP database IF EXISTS Progetto2018;
BEGIN;
CREATE DATABASE Progetto2018;
COMMIT;

USE `Progetto2018`;


DROP TABLE IF EXISTS Strada;
CREATE TABLE Strada (
	Codice char(15) NOT NULL,
	Lunghezza INT NOT NULL,
	Classificazione char(5),
	PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
BEGIN;
INSERT INTO Strada
VALUES('aa1',1, null), ('aa2', 10, null);
COMMIT;

DROP TABLE IF EXISTS Utente;
CREATE TABLE Utente (
	CodiceFiscale char(16) NOT NULL,
	NomeUtente varchar(50) NOT NULL,
	PasswordUtente varchar(50) NOT NULL,
	DomandaDiRiserva varchar(255) NOT NULL,
	Risposta varchar(255) NOT NULL,
	RuoloCarSharing varchar(11),
	RuoloCarPooling varchar(11),
	RuoloRideSharing varchar(11),
	NumeroDocumento char(10) NOT NULL,
	DataIscrizione date NOT NULL,
	NumeroCivico INT(10) NOT NULL,
	CodiceStrada varchar(50) NOT NULL,
	NumeroValutazioni INT default 0,
	SommaValutazioni INT default 0,
	PRIMARY KEY (`NomeUtente`),
	UNIQUE (`NumeroDocumento`),
    UNIQUE (`CodiceFiscale`),
	CONSTRAINT FK_CodiceStarda FOREIGN KEY (CodiceStrada) 
	REFERENCES strada (Codice) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

BEGIN;
INSERT INTO Utente
VALUES ('aaa1', 'aaa1', 'abcd', 'Nome del tuo primo animale domestico', 'Fuffi', 'Proponente', 'Fruitore', 'Entrambi', 'aaa1', '2013-02-03', '11', 'aa1', 0, 0), ('aaa2', 'aaa2', '1234', 'Colore preferito', 'Rosso', 'Entrambi', 'Proponente', 'Fruitore', 'aaa2', '2013-03-03','12', 'aa1', 0, 0), ('aaa3', 'aaa3', 'asd', 'Quanti anni avevi nel 2011', '15', 'Entrambi', 'Entrambi', 'Entrambi','aaa3', '2013-04-03', '12', 'aa1', 0, 0);
COMMIT;

DROP TABLE IF EXISTS Documento;
CREATE TABLE Documento (
	NumeroDocumento char(10) NOT NULL,
	TipoDocumento varchar(50) NOT NULL,
	Validita TINYINT(1) NOT NULL,
	EnteRilascio varchar(50) NOT NULL,
	LuogoRilascio varchar(50) NOT NULL,
	Scadenza date NOT NULL,
	PRIMARY KEY (`NumeroDocumento`),
	CONSTRAINT FK_Documento FOREIGN KEY (NumeroDocumento) 
	REFERENCES Utente (NumeroDocumento) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

BEGIN;
INSERT INTO Documento
VALUES ('aaa1', 'Patente', 1, 'Comune', 'Roma', '2020-05-16'), ('aaa2', 'Passaporto', 1, 'Comune', 'Torino', '2022-11-06'), ('aaa3','Patente', 1, 'Comune','Roma',current_date() );
COMMIT;

DROP TABLE IF EXISTS DatiAnagrafici;
CREATE TABLE DatiAnagrafici (
	CodiceFiscale char(16) NOT NULL,
	Nome varchar(50) NOT NULL,
	Cognome varchar(50) NOT NULL,
	Telefono INT(15),
	PRIMARY KEY (`CodiceFiscale`),
	CONSTRAINT FK_CodiceFiscale FOREIGN KEY (CodiceFiscale) 
	REFERENCES Utente (CodiceFiscale) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

BEGIN;
INSERT INTO DatiAnagrafici
VALUES ('aaa1', 'Marco', 'Polo', 15384656), ('aaa2',  'Mario', 'Rossi', 98283),('aaa3', 'Andrea', 'Giovani' , 272722);
COMMIT;

DROP TABLE IF EXISTS Sinistri;
CREATE TABLE Sinistri (
	CodiceFiscale char(16) NOT NULL,
	Targa char(15) NOT NULL,
	Orario datetime NOT NULL,
	CoordinataX INT NOT NULL,
	CoordinataY INT NOT NULL,
	CoordinataZ INT NOT NULL,
	CasaAutomobilistica varchar(50) NOT NULL,
	Dinamica varchar(255) NOT NULL,
	Modello varchar(50) NOT NULL,
	PRIMARY KEY (`CodiceFiscale`, `Targa`, `Orario`),
	CONSTRAINT FK_Sinistri FOREIGN KEY (CodiceFiscale) 
	REFERENCES Utente(CodiceFiscale) 
	ON UPDATE CASCADE 
	ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

BEGIN;
INSERT INTO Sinistri
VALUES ('aaa1', 'kn985ng', '2017-09-01 15:14:13', '2', '3', '4', 'Toyota', 'Tamponamento', 'C4'), ('aaa1', 'gh836nk', '2017-08-01 15:14:13', '4', '5', '6', 'Fiat', 'Finito fuori strada', '500');
COMMIT;

DROP TABLE IF EXISTS Recensione;
CREATE TABLE Recensione (
	IDValutazione INT NOT NULL auto_increment,
	CodFiscaleUtenteRecensore char(16) NOT NULL,
	CodFiscaleUtenteRecensito char(16) NOT NULL,
	Recensione varchar(255) NOT NULL,
	InOrario INT(1) NOT NULL,
	Comportamento INT(1) NOT NULL,
	Serieta INT(1) NOT NULL,
	PiacereDiViaggio INT(1) NOT NULL,
	Disponibilita INT(1) NOT NULL,
	PRIMARY KEY (IDValutazione),
	CONSTRAINT FK_Recensione FOREIGN KEY (CodFiscaleUtenteRecensore) 
	REFERENCES Utente (CodiceFiscale) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

BEGIN;
INSERT INTO Recensione (CodFiscaleUtenteRecensore, CodFiscaleUtenteRecensito, Recensione, InOrario, Comportamento, Serieta, PiacereDiViaggio, Disponibilita)
VALUES ('aaa1', 'aaa2', 'Molto simpatico e cordiale', 5, 5, 4, 5, 4), ('aaa2', 'aaa1', 'Una persona a cui piace molto parlare', 4, 5, 3, 5, 4);
COMMIT;

DROP TABLE IF EXISTS Autovettura;
CREATE TABLE Autovettura (
	Modello varchar(50) NOT NULL,
	Proprietario char(16) NOT NULL,
	Targa char(15) NOT NULL,
	TipoAlimentazione varchar(50) NOT NULL,
	AnnoImmatricolazione INT NOT NULL,
	CostoOperativo INT NOT NULL,
	CostoUsura INT NOT NULL,
	CapacitaSerbatoio INT NOT NULL,
	Consumo INT NOT NULL,
	Comfort INT NOT NULL,
	IscrittaRideSharing TINYINT(1) NOT NULL,
	PRIMARY KEY (`Targa`),
	UNIQUE (`Modello`, `Targa`),
	CONSTRAINT FK_AutovetturaProprietario FOREIGN KEY (Proprietario) 
	REFERENCES Utente (CodiceFiscale) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

BEGIN;
INSERT INTO Autovettura
VALUES ('500', 'aaa1', 001, 'Diesel', 2010, 1, 2, 40, 4, 4, 1), ('C4', 'aaa2', 002, 'Metano', 2011, 200, 100, 50, 3, 4, 0),('500', 'aaa3', 003, 'Benzina', '2010', 1, 2, 30, 3, 2, 1);
COMMIT;

DROP TABLE IF EXISTS Stato;
CREATE TABLE Stato (
	Targa char(15) NOT NULL,
	Serbatoio INT NOT NULL,
	KmTotali INT NOT NULL,
	Disponibile TINYINT(1) NOT NULL,
	PRIMARY KEY (`Targa`),
	CONSTRAINT FK_Stato FOREIGN KEY (Targa) 
	REFERENCES Autovettura (Targa) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

BEGIN;
INSERT INTO Stato
VALUES (001, 60,  100000, 1), (002, 30, 50000, 1), (003, 90, 7000, 1);
COMMIT;

DROP TABLE IF EXISTS Modello;
CREATE TABLE Modello (
	CodiceModello varchar(50) NOT NULL,
	CasaProduttrice varchar(50) NOT NULL,
	Categoria varchar(50) NOT NULL,
	NumeroPosti INT NOT NULL,
	Cilindrata INT NOT NULL,
	VelocitaMassima INT NOT NULL,
	PRIMARY KEY (`CodiceModello`),
	CONSTRAINT FK_Modello FOREIGN KEY (CodiceModello) 
	REFERENCES Autovettura (Modello) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

BEGIN;
INSERT INTO Modello
VALUES ('C4', 'Toyota',  'Monovolume', 5, 700, 160), (500, 'Fiat', 'Utilitaria', 4, 500, 130);
COMMIT;

DROP TABLE IF EXISTS Optional;
CREATE TABLE Optional (
	NomeOptional varchar(50),
	PRIMARY KEY (`NomeOptional`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

BEGIN;
INSERT INTO Optional
VALUES ('Climatizzatore'), ('Radio');
COMMIT;

DROP TABLE IF EXISTS Accessoriata;
CREATE TABLE Accessoriata (
	Targa char(15) NOT NULL,
	NomeOptional varchar(50) NOT NULL,
	PRIMARY KEY (`Targa`, `NomeOptional`),
	CONSTRAINT FK_AccessoriataTarga FOREIGN KEY (Targa) 
	REFERENCES Autovettura (Targa) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT FK_AccessoriataNomeOptional FOREIGN KEY (NomeOptional) 
	REFERENCES Optional (NomeOptional) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 

BEGIN;
INSERT INTO Accessoriata
VALUES (001,'Radio'),(002, 'Climatizzatore'), (003, 'Climatizzatore'), (003, 'Radio');
COMMIT;

DROP TABLE IF EXISTS Fruibilita;
CREATE TABLE Fruibilita (
	Targa char(15) NOT NULL,
	OraInizio time NOT NULL,
	Giorno INT NOT NULL,
	OraFine time NOT NULL,
	GuadagnoAlKm INT DEFAULT 0,
	PRIMARY KEY (`Targa`, `OraInizio`, `Giorno`),
	CONSTRAINT FK_Fruibilita FOREIGN KEY (Targa) 
	REFERENCES Autovettura (Targa) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 
BEGIN;
INSERT INTO Fruibilita
VALUES(001, '16:00:00', 1, '17:00:00', 1);
COMMIT;

DROP TABLE IF EXISTS Coordinate;
CREATE TABLE Coordinate (
	CoordinataX INT NOT NULL,
	CoordinataY INT NOT NULL,
	CoordinataZ INT NOT NULL,
	PRIMARY KEY (`CoordinataX`, `CoordinataY`, `CoordinataZ`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 
BEGIN;
INSERT INTO Coordinate
VALUES(2,3,4),(4,5,6),(5,6,6),(6,7,6),(7,8,6),(8,9,6), (9,10,6);
COMMIT;

DROP TABLE IF EXISTS Tracking;
CREATE TABLE Tracking (
	Targa char(15) NOT NULL,
	Timestamps datetime NOT NULL,
	CoordinataX INT NOT NULL,
	CoordinataY INT NOT NULL,
	CoordinataZ INT NOT NULL,
	PRIMARY KEY (`Targa`, `Timestamps`),
	CONSTRAINT FK_TrackingTarga FOREIGN KEY (Targa) 
	REFERENCES Autovettura (Targa) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT FK_TrackingCoordinate FOREIGN KEY (CoordinataX, CoordinataY, CoordinataZ) 
	REFERENCES Coordinate (CoordinataX, CoordinataY, CoordinataZ) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 
BEGIN;
INSERT INTO Tracking
VALUES(001, current_timestamp() - interval 1 year,2,3,4),(002, current_timestamp() - interval 1 year,4,5,6), (003, current_timestamp() - interval 1 year,6,7,6);
COMMIT;


DROP TABLE IF EXISTS PrenotazioneCarSharing;
CREATE TABLE PrenotazioneCarSharing (
	Targa char(15) NOT NULL,
	CodiceFiscale char(16) NOT NULL,
	DataInizio datetime NOT NULL,
	DataFine datetime NOT NULL,
	Accettata TINYINT(1) DEFAULT NULL,
	DataRestituzione datetime DEFAULT NULL,
	Spesa float NOT NULL,
	IDPrenotazione INT NOT NULL auto_increment,
	PRIMARY KEY (`IDPrenotazione`),
	CONSTRAINT FK_PrenotazioneCarSharingTarga FOREIGN KEY (Targa) 
	REFERENCES Autovettura (Targa) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT FK_PrenotazioneCarSharingCodiceFiscale FOREIGN KEY (CodiceFiscale) 
	REFERENCES Utente (CodiceFiscale) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 
BEGIN;
INSERT INTO PrenotazioneCarSharing (Targa, CodiceFiscale, DataInizio, DataFine, Spesa)
VALUES(001,'aaa2',current_date(), current_date()+INTERVAL 1 DAY, 100);
COMMIT;

DROP TABLE IF EXISTS Pool;
CREATE TABLE Pool (
	CodiceFiscale char(16) NOT NULL,
	Targa char(15) NOT NULL,
	Flessibilita INT NOT NULL,
	GiornoArrivo date DEFAULT NULL,
	GiornoPartenza date NOT NULL,
	OraPartenza time NOT NULL,
	ApertoFinoA time NOT NULL,
	InOrario TINYINT(1), 
	IDPool INT NOT NULL auto_increment,
	PRIMARY KEY (`IDPool`),
	CONSTRAINT FK_PoolCodiceFiscale FOREIGN KEY (CodiceFiscale) 
	REFERENCES Utente (CodiceFiscale) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT FK_PoolTarga FOREIGN KEY (Targa) 
	REFERENCES Autovettura (Targa) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
BEGIN;
INSERT INTO Pool (CodiceFiscale, Targa,	Flessibilita, GiornoPartenza , OraPartenza, ApertoFinoA,	InOrario)
VALUES('aaa2', 002, 2, current_date(), '16:00:00', '14:00:00', 1);
COMMIT;

DROP TABLE IF EXISTS PrenotazioneCarPooling;
CREATE TABLE PrenotazioneCarPooling (
	CodiceFiscale char(16) NOT NULL,
	IDPool INT NOT NULL,
	StatoGuidatore TINYINT(1),
	StatoFruitore TINYINT(1),
	Spesa float DEFAULT 0,
	TotaleKmVariazione float default 0,
	SalitaX INT NOT NULL,
	SalitaY INT NOT NULL,
	SalitaZ INT NOT NULL,
	ScesaX INT NOT NULL,
	ScesaY INT NOT NULL,
	ScesaZ INT NOT NULL,
	IDPrenotazione INT NOT NULL auto_increment,
	PRIMARY KEY (`IDPrenotazione`),
	CONSTRAINT FK_PrenotazioneCarPoolingCodiceFiscale FOREIGN KEY (CodiceFiscale) 
	REFERENCES Utente (CodiceFiscale) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT FK_PrenotazioneCarPoolingIDPool FOREIGN KEY (IDPool) 
	REFERENCES Pool (IDPool) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS Propone;
CREATE TABLE Propone (
	IDPrenotazione INT NOT NULL,
	CoordinataX INT NOT NULL,
	CoordinataY INT NOT NULL,
	CoordinataZ INT NOT NULL,
	Indice INT auto_increment NOT NULL,
	PRIMARY KEY (`Indice`, `IDPrenotazione`),
	CONSTRAINT FK_ProponeIDPrenotazione FOREIGN KEY (IDPrenotazione) 
	REFERENCES PrenotazioneCarPooling (IDPrenotazione) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT FK_ProponeCoordinate FOREIGN KEY (CoordinataX, CoordinataY, CoordinataZ) 
	REFERENCES Coordinate (CoordinataX, CoordinataY, CoordinataZ) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
BEGIN;


DROP TABLE IF EXISTS PercorrePool;
CREATE TABLE PercorrePool (
	IDPool INT NOT NULL,
	CoordinataX INT NOT NULL,
	CoordinataY INT NOT NULL,
	CoordinataZ INT NOT NULL,
	Indice INT auto_increment,
	PRIMARY KEY (`Indice`, `IDPool`),
	CONSTRAINT FK_PercorrePoolIDPool FOREIGN KEY (IDPool) 
	REFERENCES Pool (IDPool) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT FK_PercorrePoolCoordinate FOREIGN KEY (CoordinataX, CoordinataY, CoordinataZ) 
	REFERENCES Coordinate (CoordinataX, CoordinataY, CoordinataZ) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
BEGIN;

DROP TABLE IF EXISTS Chiamata;
CREATE TABLE Chiamata (
	CodiceFiscaleFruitore char(16) NOT NULL,
	CodiceFiscaleProponente char(16) NOT NULL,
	Timestamps timestamp NOT NULL,
	OrarioDipartenza time DEFAULT NULL,
	TimestampFineCorsa timestamp,
	Stato TINYINT(1), 
	TimestampRisposta timestamp,
	IDChiamata INT NOT NULL auto_increment,
	PRIMARY KEY (`IDChiamata`),
	CONSTRAINT FK_ChiamataCodiceFiscaleFruitore FOREIGN KEY (CodiceFiscaleFruitore) 
	REFERENCES Utente (CodiceFiscale) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT FK_ChiamataCodiceFiscaleProponente FOREIGN KEY (CodiceFiscaleProponente) 
	REFERENCES Utente (CodiceFiscale) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
BEGIN;

DROP TABLE IF EXISTS PercorreRideSharing;
CREATE TABLE PercorreRideSharing (
	IDChiamata INT NOT NULL,
	CoordinataX INT NOT NULL,
	CoordinataY INT NOT NULL,
	CoordinataZ INT NOT NULL,
	Indice INT NOT NULL auto_increment,
	PRIMARY KEY (`Indice`, `IDChiamata`), 
	CONSTRAINT FK_PercorreRideSharingCoordinate FOREIGN KEY (CoordinataX, CoordinataY, CoordinataZ) 
	REFERENCES Coordinate (CoordinataX, CoordinataY, CoordinataZ) 
	ON UPDATE CASCADE
	ON DELETE CASCADE, 
	CONSTRAINT FK_PercorreRideSharingChiamata FOREIGN KEY (IDChiamata) 
	REFERENCES Chiamata (IDChiamata) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
BEGIN;



DROP TABLE IF EXISTS Indicano;
CREATE TABLE Indicano (
	Codice char(15) NOT NULL,
	NumeroKm INT NOT NULL,
	CoordinataX INT NOT NULL,
	CoordinataY INT NOT NULL,
	CoordinataZ INT NOT NULL,
	PRIMARY KEY (`Codice`, `CoordinataX`, `CoordinataY`, `CoordinataZ`), 
	CONSTRAINT FK_IndicanoCoordinate FOREIGN KEY (CoordinataX, CoordinataY, CoordinataZ) 
	REFERENCES Coordinate (CoordinataX, CoordinataY, CoordinataZ) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT FK_IndicanoStrada FOREIGN KEY (Codice) 
	REFERENCES Strada (Codice) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

BEGIN;
INSERT INTO Indicano
VALUES('aa1', 0, 2,3,4),('aa2', 0, 2,3,4) ,('aa2', 0, 4,5,6), ('aa2', 0, 5,6,6),('aa2', 0, 6,7,6) ,('aa2', 0, 7,8,6) ,('aa2', 0, 8,9,6) ,('aa2', 0, 9,10,6);
COMMIT;

DROP TABLE IF EXISTS Incroci;
CREATE TABLE Incroci (
	Strada1 char(15) NOT NULL,
	Strada2 char(15) NOT NULL,
	CoordinataX INT NOT NULL,
	CoordinataY INT NOT NULL,
	CoordinataZ INT NOT NULL,
	IDIncrocio INT NOT NULL auto_increment,
	PRIMARY KEY (`IDIncrocio`), 
	CONSTRAINT FK_IncrociCoordinate FOREIGN KEY (CoordinataX, CoordinataY, CoordinataZ) 
	REFERENCES Coordinate (CoordinataX, CoordinataY, CoordinataZ) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT FK_Strada1 FOREIGN KEY(Strada1) 
	REFERENCES Strada (Codice) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	CONSTRAINT FK_Strada2 FOREIGN KEY (Strada2)
	REFERENCES Strada (Codice) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
BEGIN;
INSERT INTO Incroci (Strada1, Strada2, CoordinataX, CoordinataY, CoordinataZ)
VALUES('aa1', 'aa2', 2,3,4);
COMMIT;

	
DROP TABLE IF EXISTS StradaConID;
CREATE TABLE StradaConID (
	Codice char(15) NOT NULL,
	Tipologia char(15) NOT NULL,
	Numero INT NOT NULL,
	Nome char(15),
	Categoria char(50),
	PRIMARY KEY (`Codice`),
	CONSTRAINT FK_StradaConID FOREIGN KEY (Codice)
	REFERENCES Strada (Codice) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
BEGIN;
INSERT INTO StradaConID
VALUES('aa1', 'SS', 1,  'Aurelia', null);
COMMIT;


DROP TABLE IF EXISTS StradaConNome;
CREATE TABLE StradaConNome (
	Codice char(15) NOT NULL,
	Nome char(15),
	Comune char(15),
	PRIMARY KEY (`Codice`),
	CONSTRAINT FK_StradaConNome FOREIGN KEY (Codice)
	REFERENCES Strada (Codice) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
BEGIN;
INSERT INTO StradaConNome
VALUES('aa2', 'Garibaldi G', 'Roma');
COMMIT;

DROP TABLE IF EXISTS Caratteristiche;
CREATE TABLE Caratteristiche (
	Codice char(15) NOT NULL, 
	NumeroKmIniziale INT NOT NULL,
	NumeroKmFinale INT NOT NULL,
	NumeroCareggiata INT NOT NULL,
	NumeroSensiDiMarcia INT NOT NULL,
	LimiteKmh INT NOT NULL,
	NumeroCorsie INT NOT NULL,
	PRIMARY KEY (`Codice`),
	CONSTRAINT FK_Caratteristiche FOREIGN KEY (Codice)
	REFERENCES Strada (Codice) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 
BEGIN;
INSERT INTO Caratteristiche
VALUES('aa1', 0, 5, 1, 6, 100, 7),('aa2', 0, 2, 1, 2, 50, 4);
COMMIT;

DROP TABLE IF EXISTS PedaggioAutostrade;
CREATE TABLE PedaggioAutostrade (
	Codice char(15) NOT NULL, 
	NumeroKmIniziale INT NOT NULL, 
	NumeroKmFinale INT NOT NULL,
	Pedaggio FLOAT NOT NULL,
	PRIMARY KEY (`Codice`),
	CONSTRAINT FK_Pedaggio FOREIGN KEY (Codice) 
	REFERENCES Strada (Codice) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
BEGIN;
INSERT INTO PedaggioAutostrade
VALUES('aa1', 0, 10, 100);
COMMIT;

DROP TABLE IF EXISTS KmInAlert;
CREATE TABLE KmInAlert (
	Codice char(15) NOT NULL,
	NumeroKmFinale INT NOT NULL,
	PRIMARY KEY (`Codice`, `NumeroKmFinale`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


