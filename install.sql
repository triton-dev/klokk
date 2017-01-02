\c template1

drop database if exists klokk;

create database klokk;

\c klokk

create domain d_ktghely as varchar(8);
create domain d_kartyaszam as varchar(10);
create domain d_dolgozonev as varchar(50);
create domain d_ktghelynev as varchar(50);
create domain d_torzsszam as varchar(5);
create domain d_fajl as varchar(255);



create table ktghely (
	ktghely d_ktghely primary key,
	ktghelynev d_ktghelynev not null
) with oids;

create table dolgozo (
	torzsszam d_torzsszam primary key,
	nev d_dolgozonev not null,
	ktghely d_ktghely references ktghely(ktghely) 
		on delete restrict on update cascade,
	fenykep d_fajl
) with oids;








