CALL AggiornamentoTracking (9, 10, 6, 001, current_timestamp());
CALL AggiornamentoTracking (4, 5, 6, 002, current_timestamp());
CALL AggiornamentoTracking (5, 6, 6, 003, current_timestamp());

CALL InserimentoRecensione('aaa1', 'aaa2', 'In Orario e simpatico', 0 , 0, 0, 0, 0);

CALL InserimentoTragittoCarPooling (1, 2, 3, 4);
CALL InserimentoTragittoCarPooling (1, 4, 5, 6);
CALL InserimentoTragittoCarPooling (1, 5, 6, 6);
CALL InserimentoTragittoCarPooling (1, 6, 7, 6);
CALL InserimentoTragittoCarPooling (1, 7, 8, 6);

INSERT INTO PrenotazioneCarPooling (CodiceFiscale, IDPool, SalitaX, SalitaY, SalitaZ, ScesaX, ScesaY, ScesaZ)
VALUES('aaa1', 1, 4, 5, 6, 7, 8, 6);

CALL InserimentoTragittoVariazione (1, 8,9,6);
CALL InserimentoTragittoVariazione (1, 9,10,6);

CALL RicercaRideSharing ('aaa2', 1, 3, 4);

CALL InserimentoTragittoRideSharing (1, 4, 5, 6);
