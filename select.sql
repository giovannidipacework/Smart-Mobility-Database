select *
from pedaggioautostrade;

select *
from indicano;

select *
from coordinate;

select *
from autovettura;

select	*
from Utente;

select *
from pool;

select *
from percorrepool;

select *
from prenotazionecarpooling;

select *
from percorreridesharing;

select *
from chiamata;

select *
from stradaconid;

select T.targa, T.Timestamps, I.Codice, T.CoordinataX, T.CoordinataY, T.CoordinataZ, C.LimiteKmh
from tracking T inner join indicano I on(T.CoordinataX = I.CoordinataX and T.CoordinataY = I.CoordinataY and T.CoordinataZ = I.CoordinataZ)
	inner join caratteristiche C on (I.Codice = C.Codice and I.NumeroKm between C.NumeroKmIniziale and C.NumeroKmFinale);

select *
from KmInAlert;
