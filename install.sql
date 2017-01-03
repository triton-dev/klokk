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
create domain d_allandokartya as boolean not null default true;
create domain d_rendelesszam as varchar(8);
create domain d_cikkszam as varchar(12);
create domain d_megnevezes as varchar(100);
create domain d_mennyiseg as integer check(value > 0);
create domain d_nyitott as boolean not null default true;

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

create table kartya (
	kartyaszam d_kartyaszam primary key,
	torzsszam d_torzsszam references dolgozo(torzsszam)
		on delete restrict on update cascade,
	allandokartya d_allandokartya
) with oids;

create table rendeles (
	rendelesszam d_rendelesszam primary key,
	cikkszam d_cikkszam default null,
	megnevezes d_megnevezes not null,
	mennyiseg d_mennyiseg,
	nyitott d_nyitott
) with oids;

-- Betöltések
\i ktghely.sql
\i dolgozok.sql
\i rendelesek.sql









