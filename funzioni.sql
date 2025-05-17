/*Questa funzione serve per calcolare la spesa che un fruitore deve affrontare quando decide di partecipare a un Pool*/

DROP TRIGGER IF EXISTS CalcoloSpesaPool;
DELIMITER $$
CREATE TRIGGER CalcoloSpesaPool BEFORE INSERT ON PrenotazioneCarPooling FOR EACH ROW
BEGIN


DECLARE spesaPedaggio FLOAT DEFAULT 0;
DECLARE spesaMacchina FLOAT DEFAULT 0;
DECLARE numeroCoordinate FLOAT DEFAULT 0;

(
/* Calcolo quanta distanza percorre il fruitore */
	SELECT	count(*) INTO numeroCoordinate
	FROM	PercorrePool PP
			Inner join
			Indicano I
			On(PP.CoordinataX=I.CoordinataX and PP.CoordinataY=I.CoordinataY and PP.CoordinataZ=I.CoordinataZ)
	WHERE	PP.IDPool  = New.IDPool
			And
			PP.Indice >= (
				SELECT	PP1.indice
				FROM	PercorrePool PP1
				WHERE (PP1.CoordinataX = New.SalitaX and PP1.CoordinataY = New.SalitaY and PP1.CoordinataZ = New.SalitaZ)
					And
					PP1.IDPool = New.IDPool
			)
			And
			PP.Indice <= (
				SELECT	PP1.indice
				FROM	PercorrePool PP1
				WHERE (PP1.CoordinataX = New.ScesaX and PP1.CoordinataY = New.ScesaY and PP1.CoordinataZ = New.ScesaZ)
					And
					PP1.IDPool = New.IDPool
			)
)
;

/* Calcolo la spesa dovuta ai pedaggi delle autostrade */
(
SELECT	 if(count(*)>0, SUM(PA.Pedaggio),0) INTO spesaPedaggio
FROM
(
	SELECT	I.Codice, I.NumeroKm, PP.IDPool
	FROM	PercorrePool PP
			Inner join
			Indicano I
			On(PP.CoordinataX=I.CoordinataX and PP.CoordinataY=I.CoordinataY and PP.CoordinataZ=I.CoordinataZ)
	WHERE	PP.IDPool  = New.IDPool
			And
			PP.Indice >= (
				SELECT	PP1.indice
				FROM	PercorrePool PP1
				WHERE (PP1.CoordinataX = New.SalitaX and PP1.CoordinataY = New.SalitaY and PP1.CoordinataZ = New.SalitaZ)
					And
					PP1.IDPool = New.IDPool
			)
			And
			PP.Indice <= (
				SELECT	PP1.indice
				FROM	PercorrePool PP1
				WHERE (PP1.CoordinataX = New.ScesaX and PP1.CoordinataY = New.ScesaY and PP1.CoordinataZ = New.ScesaZ)
					And
					PP1.IDPool = New.IDPool
			)
) as K
inner join
PedaggioAutostrade PA
On (K.Codice = PA.Codice and K.NumeroKm between PA.NumeroKmIniziale and PA.NumeroKmFinale)
)
;

/* Calcolo la spesa derivante dal costo operativo e dal costo di usura della macchina */
(
	SELECT	@numeroCoordinate * (AV.CostoOperativo + AV.CostoUsura) INTO spesaMacchina
    FROM	Pool P 
			inner join Autovettura AV 
            on(P.Targa = AV.Targa)
            inner join Modello M
            on(AV.Modello = M.CodiceModello)
    WHERE	IDPool = new.IDPool
)
;


SET New.Spesa = spesaMacchina + spesaPedaggio;




END $$
DELIMITER ;

/* AggiornaSpesaPool aggiorna la spesa che un fruitore deve sostenere aggiungendo la spesa derivante dalle variazioni richieste */
DROP TRIGGER IF EXISTS AggiornaSpesaPool;
DELIMITER $$
CREATE TRIGGER AggiornaSpesaPool BEFORE UPDATE ON PrenotazioneCarPooling FOR EACH ROW
BEGIN
IF New.TotaleKmVariazione <> Old.TotaleKmVariazione THEN 
SET @ss = (
	SELECT	New.TotaleKmVariazione * (A.CostoOperativo + A.CostoUsura)
	FROM	Pool P natural join Autovettura A
	WHERE	P.IDPool = New.IDPool
);

SET New.Spesa = New.Spesa + @ss;

END IF;	

END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS AggiornamentoTracking;
Delimiter $$
CREATE PROCEDURE AggiornamentoTracking (in CoordinataX int,
in CoordinataY int,
in CoordinataZ int,
in Targa int,
in Tempo timestamp
)
Begin

	Insert Into Tracking
	Values(Targa, Tempo, CoordinataX, CoordinataY, CoordinataZ)
;

End $$
Delimiter ;


/* Attraverso questa funzione gli utenti possono immettere recensioni per i servizi offerti da altri utenti */ 
DROP PROCEDURE IF EXISTS InserimentoRecensione;
DELIMITER $$
CREATE PROCEDURE InserimentoRecensione (IN _CodFiscaleUtenteRecensore char(16),
IN _CodFiscaleUtenteRecensito char(16),
IN _Recensione varchar(255),
IN _Orario INT(1),
IN _Comportamento INT(1),
IN _Serieta INT(1),
IN _PiacereDiViaggio INT(1),
IN _Disponibilita INT(1)
)
BEGIN

INSERT INTO  Recensione(CodFiscaleUtenteRecensore, CodFiscaleUtenteRecensito, Recensione, InOrario, Comportamento, Serieta, PiacereDiViaggio, Disponibilita)
VALUES (_CodFiscaleUtenteRecensore, _CodFiscaleUtenteRecensito, _Recensione, _Orario, _Comportamento, _Serieta, _PiacereDiViaggio, _Disponibilita)
;
/* Attraverso questi due update vengono aggiornate le ridondanze */
UPDATE Utente
SET NumeroValutazioni = NumeroValutazioni + 1
WHERE	CodiceFiscale = _CodFiscaleUtenteRecensito
LIMIT 1
;

UPDATE 	utente
SET 	SommaValutazioni = SommaValutazioni + (_Orario + _Comportamento + _Serieta + _PiacereDiViaggio + _Disponibilita)
WHERE	CodiceFiscale = _CodFiscaleUtenteRecensito
LIMIT 1
;

END $$
DELIMITER ;



/* Questa funzione serve a registrare i tragitti percorsi dalle autovetture durante un servizio di Ride Sharing */
DROP PROCEDURE IF EXISTS InserimentoTragittoRideSharing;
DELIMITER $$
CREATE PROCEDURE InserimentoTragittoRideSharing (in _IDChiamata int,
							in _CoordinataX int,
							in _CoordinataY int,
							in _CoordinataZ int
							)
BEGIN

Insert Into PercorreRideSharing(IDChiamata, CoordinataX, CoordinataY, CoordinataZ)
Values (_IDChiamata, _CoordinataX, _CoordinataY, _CoordinataZ)
;

END $$
DELIMITER ;


/* Questa funzione permette a un utente proponente di inserire il tragitto che andrà a percorrere con il Pool */

DROP PROCEDURE IF EXISTS InserimentoTragittoCarPooling;
DELIMITER $$
CREATE PROCEDURE InserimentoTragittoCarPooling (in _IDPool int,
							in _CoordinataX int,
							in _CoordinataY int,
							in _CoordinataZ int
							)
BEGIN

INSERT INTO PercorrePool (IDPool, CoordinataX, CoordinataY, CoordinataZ)
VALUES (_IDPool, _CoordinataX, _CoordinataY, _CoordinataZ)
;

END $$
DELIMITER ;

/* InserimentoTragittoVariazione permette ai fruitori di inserire una variazione da richiedere al proponente */
DROP PROCEDURE IF EXISTS InserimentoTragittoVariazione;
DELIMITER $$
CREATE PROCEDURE InserimentoTragittoVariazione (in _IDPrenotazione int,
							in _CoordinataX int,
							in _CoordinataY int,
							in _CoordinataZ int
							)
BEGIN

INSERT INTO Propone(IDPrenotazione, CoordinataX, CoordinataY, CoordinataZ)
VALUES (_IDPrenotazione, _CoordinataX, _CoordinataY, _CoordinataZ)
;

UPDATE PrenotazioneCarPooling
SET TotaleKmVariazione = TotaleKmVariazione + 0.001
WHERE IDPrenotazione = _IDPrenotazione
;

END $$
DELIMITER ;

/* Questa funzione permette a un fruitore del servizio di Ride Sharing di effettuare una chiamata al miglior proponente disponibile */
DROP PROCEDURE IF EXISTS RicercaRideSharing;
DELIMITER $$
CREATE PROCEDURE RicercaRideSharing (in _CodiceFruitore char(16),
					in _PosX int,
					in _PosY int,
					in _PosZ int
					) 
BEGIN
/* Questa view seleziona tutti i proponenti disponibili */
CREATE OR REPLACE VIEW UtentiVicini as
SELECT		A.Proprietario, A.Targa, U.NumeroValutazioni, U.SommaValutazioni, D.CoordinataX, D.CoordinataY, D.CoordinataZ
FROM		Autovettura A 
		inner join 
		(
		SELECT	*
		FROM	Tracking T
		WHERE	T.Timestamps >= ALL(	
			SELECT	T1.Timestamps
			FROM	Tracking T1 
			)
		) as D
		On (A.Targa = D.Targa)
		Inner join
		Utente U
		On (A.Proprietario = U.CodiceFiscale)
WHERE		A.IscrittaRideSharing = 1
;
/* All’interno della view CinqueUtentiMigliori vengono selezionati i dati delle autovetture inserita la targa della macchina da chiamare selezionando prima le macchine in un raggio di 3 kilometri, poi i 5 utenti proprietari di quelle macchine con valutazione maggiore */
CREATE OR REPLACE VIEW CinqueUtentiMigliori as
SELECT	UV.Targa, UV.Proprietario, T.CoordinataX, T.CoordinataY, T.CoordinataZ
FROM	UtentiVicini UV
	Inner join
	Tracking T
	On (UV.Targa = T.Targa)
WHERE	SQRT( 
			(UV.CoordinataX - _PosX)*( UV.CoordinataX - _PosX) +
			(UV.CoordinataY - _PosY)*( UV.CoordinataY - _PosY) +
			(UV.CoordinataZ - _PosZ)*( UV.CoordinataZ - _PosZ)
			) <= 3000
			AND
			(
			SELECT	count(*)
			FROM	UtentiVicini UV1
			WHERE	(UV.SommaValutazioni / UV.NumeroValutazioni) > (UV1.SommaValutazioni / UV1.NumeroValutazioni)
			And
			SQRT( 
			(UV1.CoordinataX - _PosX)*( UV1.CoordinataX - _PosX) +
			(UV1.CoordinataY - _PosY)*( UV1.CoordinataY - _PosY) +
			(UV1.CoordinataZ - _PosZ)*( UV1.CoordinataZ - _PosZ)
			) <= 3000 )>5
;


SET @_UtenteMigliore = (
	SELECT	T.Proprietario
	FROM	CinqueUtentiMigliori AS T
	WHERE SQRT( 
	(T.CoordinataX - _PosX)*( T.CoordinataX - _PosX) +
	(T.CoordinataY - _PosY)*( T.CoordinataY - _PosY) +
	(T.CoordinataZ - _PosZ)*( T.CoordinataZ - _PosZ)
	) <= ALL(
			SELECT	SQRT( 
				(T1.CoordinataX - _PosX)*( T1.CoordinataX - _PosX) +
				(T1.CoordinataY - _PosY)*( T1.CoordinataY - _PosY) +
				(T1.CoordinataZ - _PosZ)*( T1.CoordinataZ - _PosZ)
				)
			FROM	CinqueUtentiMigliori AS T1
            )
)
;



INSERT INTO Chiamata (CodiceFiscaleFruitore, CodiceFiscaleProponente, Timestamps)
VALUES (_CodiceFruitore, @_UtenteMigliore, Current_Timestamp())
;
	
END $$
DELIMITER ;


SET GLOBAL event_scheduler = ON;
/* Questo event serve a segnalare le strade in cui c’è un problema di viabilità  */
DROP EVENT IF EXISTS AggiornamentoViabilita;
Delimiter $$
CREATE EVENT AggiornamentoViabilita 
ON SCHEDULE EVERY 60 SECOND Do
Begin

	TRUNCATE TABLE KmInAlert;
    
/* Selezioni gli ultimi tracking delle autovetture */
CREATE OR REPLACE VIEW Ultimi AS
Select  T.CoordinataX, T.CoordinataY, T.CoordinataZ, T.Timestamps, T.Targa, I.NumeroKm, I.Codice
From  Tracking T Natural Join Indicano I
Where  T.Timestamps >= ALL(
	Select T1.Timestamps
	From Tracking T1
  )
;
/* Seleziono i penultimi tracking delle autovetture */
CREATE OR REPLACE VIEW Penultimi AS
Select  T.CoordinataX, T.CoordinataY, T.CoordinataZ, T.Timestamps, T.Targa, I.NumeroKm, I.Codice
From  Tracking T Natural Join Indicano I
Where  T.Timestamps <= ALL(
	Select T1.Timestamps
	From Tracking T1
  )
;

/* Inserisco nella tabella KmInAlert i kilometri dove sono presenti autovetture che hanno una velocità inferiore alla metà del limite */ 
	Insert 	Into KmInAlert
	Select	distinct U.Codice, U.NumeroKm
	From 	Ultimi U Inner Join Penultimi P on (U.Targa = P.Targa and U.Codice=P.Codice and U.NumeroKm=P.NumeroKm)
	Where
				(
					SQRT( 
						(U.CoordinataX - P.CoordinataX)*(U.CoordinataX - P.CoordinataX) +
						(U.CoordinataY - P.CoordinataY)*(U.CoordinataY - P.CoordinataY) +
						(U.CoordinataZ - P.CoordinataZ)*(U.CoordinataZ - P.CoordinataZ)
					)
					/ timestampdiff(SECOND,P.Timestamps, U.Timestamps)
                )
				<=
				(	Select	C.LimiteKmh / 2
					From Caratteristiche C
					Where C.Codice = U.Codice
						and
                        U.NumeroKm between C.NumeroKmIniziale and C.NumeroKmFinale
				)
;


End $$
Delimiter ;


