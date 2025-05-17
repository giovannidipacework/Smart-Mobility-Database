DROP TRIGGER IF EXISTS ControllaNumeroPosti;
DELIMITER $$
CREATE TRIGGER ControllaNumeroPosti BEFORE INSERT ON PrenotazioneCarPooling FOR EACH ROW
BEGIN

SET @PostiMacchina = (
SELECT	M.NumeroPosti
    	FROM	Pool P NATURAL JOIN Autovettura A INNER JOIN Modello M ON (A.Modello = M.CodiceModello)
    	WHERE	P.IDPool = NEW.IDPool
    );
    
IF @PostiMacchina <= (
	SELECT	COUNT(*)
  	FROM 	PrenotazioneCarPooling
	WHERE IDPool = NEW.IDPool)	THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Numero di posti nell`autovettura insufficiente';
END IF;    

END $$
DELIMITER ;


DROP TRIGGER IF EXISTS ControlloCreazionePool;
DELIMITER $$
CREATE TRIGGER ControlloCreazionePool BEFORE INSERT ON Pool FOR EACH ROW
BEGIN

Set @Trovato = (
    SELECT	COUNT(*)
    FROM	Pool
    WHERE	CodiceFiscale = NEW.CodiceFiscale
		AND
		GiornoPartenza = NEW.GiornoPartenza
            		AND
            		OraPartenza = NEW.OraPartenza);
            
IF @Trovato > 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Impossibile creare il Pool: il proponente ne ha già creato un altro per la stessa data e la stessa ora';
END IF;

END $$
DELIMITER ;


DROP TRIGGER IF EXISTS ControlloIscrizione;
DELIMITER $$
CREATE TRIGGER ControlloIscrizione 
BEFORE INSERT ON Utente
FOR EACH ROW
BEGIN


IF (
	NEW.RuoloCarSharing <> NULL 
	AND NEW.RuoloCarSharing <> 'Fruitore' 
    	AND NEW.RuoloCarSharing <> 'Proponente'
	AND NEW.RuoloCarSharing <> 'Entrambi'
    ) 
    OR
    (
	NEW.RuoloCarPooling <> NULL 
	AND NEW.RuoloCarPooling <> 'Fruitore' 
    	AND NEW.RuoloCarPooling <> 'Proponente'
	AND NEW.RuoloCarPooling <> 'Entrambi'
    ) 
    OR
    (
	NEW.RuoloRideSharing <> NULL 
	AND NEW.RuoloRideSharing <> 'Fruitore' 
    	AND NEW.RuoloRideSharing <> 'Proponente'
	AND NEW.RuoloRideSharing <> 'Entrambi'
    ) 
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'L`iscrizione al servizio non è valida';
END IF;

END $$
DELIMITER ;


DROP TRIGGER IF EXISTS ControlloInsertDocumento;
DELIMITER $$
CREATE TRIGGER ControlloInsertDocumento 
BEFORE INSERT ON Documento
FOR EACH ROW
BEGIN

IF NEW.Validita <= current_date()
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Il documento non è valido';
END IF;

END $$
DELIMITER ;

DROP TRIGGER IF EXISTS ControlloUpdateDocumento;
DELIMITER $$
CREATE TRIGGER ControlloUpdateDocumento 
BEFORE UPDATE ON Documento
FOR EACH ROW
BEGIN

IF NEW.Validita <= current_date()
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Il documento non è valido';
END IF;

END $$
DELIMITER ;


DROP TRIGGER IF EXISTS ControlloInsertSerbatoio;
DELIMITER $$
CREATE TRIGGER ControlloInsertSerbatoio
BEFORE INSERT ON Stato
FOR EACH ROW
BEGIN

IF NEW.Serbatoio NOT BETWEEN 0 AND 100
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Precentuale di riempimento del serbatoio non valida';
END IF;

END $$
DELIMITER ;

DROP TRIGGER IF EXISTS ControlloUpdateSerbatoio;
DELIMITER $$
CREATE TRIGGER ControlloUpdateSerbatoio
BEFORE UPDATE ON Stato
FOR EACH ROW
BEGIN

IF NEW.Serbatoio NOT BETWEEN 0 AND 100
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Precentuale di riempimento del serbatoio non valida';
END IF;

END $$
DELIMITER ;

DROP TRIGGER IF EXISTS ControlloCarburante;
DELIMITER $$
CREATE TRIGGER ControlloCarburante BEFORE UPDATE ON Stato FOR EACH ROW
BEGIN

IF new.Serbatoio <> Serbatoio THEN

SET @trovato = (
	SELECT 	count(*)
    FROM	PrenotazioneCarCharing PCC
    WHERE	PCC.DataRestituzione = current_timestamp()
			and
			PCC.Targa = Targa
)
;

IF (trovato > 0 AND new.Serbatoio < (Serbatoio-(Serbatoio*5/100) ) ) THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Tentata restituzione di un auto con carburante troppo basso';
END IF;

END IF;

END $$
DELIMITER ;


DROP TRIGGER IF EXISTS ControlloTipologia;
DELIMITER $$
CREATE TRIGGER ControlloTipologia BEFORE INSERT ON stradaconid FOR EACH ROW
BEGIN

IF new.Tipologia <> 'A' AND new.Tipologia <> 'SS' AND new.Tipologia <> 'SR' AND new.Tipologia <> 'SP' AND new.Tipologia <> 'SC' AND new.Tipologia <> 'SV' THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Tentato inserimento di strada con Tipologia sbagliata scegliere tra: A, SS, SR, SP, SC, SV';
END IF;

END $$
DELIMITER ;

DROP TRIGGER IF EXISTS ControlloCategoria;
DELIMITER $$
CREATE TRIGGER ControlloCategoria BEFORE INSERT ON stradaconid FOR EACH ROW
BEGIN


IF new.Categoria <> 'Dir' AND new.Categoria <> 'Var' AND new.Categoria <> 'Racc' AND new.Categoria <> 'Radd' AND new.Categoria <> 'Bis' AND new.Categoria <> 'Ter' AND new.Categoria <> 'Quater' THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Tentato inserimento di strada con Categoria sbagliata scegliere tra: Dir, Var, Racc, Radd, Bis, Ter, Quater';
END IF;

END $$
DELIMITER ;

DROP TRIGGER IF EXISTS ControlloClassificazione;
DELIMITER $$
CREATE TRIGGER ControlloClassificazione BEFORE INSERT ON strada FOR EACH ROW
BEGIN


IF new.Classificazione <> 'Urbana' AND new.Classificazione <> 'Extraurbana Principale' AND new.Classificazione <> 'Extraurbana Secondaria' AND new.Classificazione <> 'Autostrada' THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Tentato inserimento di strada con Classificazione sbagliata scegliere tra: Urbana, Extraurbana Principale, Extraurbana Secondaria, Autostrada';
END IF;

END $$
DELIMITER ;

DROP TRIGGER IF EXISTS ControlloVariazione;
DELIMITER $$
CREATE TRIGGER ControlloVariazione BEFORE INSERT ON pool FOR EACH ROW
BEGIN


IF new.Flessibilita <> '0' AND new.Flessibilita <> '1' AND new.Flessibilita <> '2' AND new.Flessibilita <> '3' THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Tentato inserimento di strada con Flessibilita sbagliata scegliere tra: 0, 1, 2, 3';
END IF;

END $$
DELIMITER ;

DROP TRIGGER IF EXISTS ControlloFelissibilita;
DELIMITER $$
CREATE TRIGGER ControlloFlessibilita
BEFORE INSERT ON Propone
FOR EACH ROW
BEGIN

SET @CheckFlessibilita = (
	SELECT	Flessibilita
    FROM 	PrenotazioneCarPooling NATURAL JOIN Pool
    WHERE 	IDPrenotazione = NEW.IDPrenotazione
	);
    
SET @CheckVariazioni = (
	SELECT	COUNT(*)
    FROM	Propone
    WHERE	IDPrenotazione = NEW.IDPrenotazione
    );
    
IF @CheckFlessibilita = 0 
THEN 
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Il periodo di apertura del Pool non è valido';
END IF;
IF @CheckFlessibilita = 1 AND @CheckVariazioni > 1000
THEN 
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Il periodo di apertura del Pool non è valido';
END IF;
IF @CheckFlessibilita = 2 AND @CheckVariazioni > 2500
THEN 
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Il periodo di apertura del Pool non è valido';
END IF;
IF @CheckFlessibilita = 3 AND @CheckVariazioni > 5000
THEN 
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Il periodo di apertura del Pool non è valido';
END IF;


END $$
DELIMITER ;

DROP TRIGGER IF EXISTS ControlloValiditaPool;
DELIMITER $$
CREATE TRIGGER ControlloValiditaPool
BEFORE INSERT ON  Pool
FOR EACH ROW
BEGIN

IF NEW.ApertoFinoA > current_timestamp() - INTERVAL 48 HOUR
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Il periodo di apertura del Pool non è valido';
END IF;

END $$
DELIMITER ;
