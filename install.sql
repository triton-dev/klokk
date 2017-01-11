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
create domain d_cikkszam as varchar(12) default null;
create domain d_megnevezes as varchar(100);
create domain d_mennyiseg as integer check(value > 0);
create domain d_nyitott as boolean not null default true;
create domain d_szekvenciaszam as varchar(25) default null;

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
	cikkszam d_cikkszam,
	megnevezes d_megnevezes not null,
	mennyiseg d_mennyiseg,
	szekvenciaszam d_szekvenciaszam default null,
	nyitott d_nyitott
) with oids;

create table osszerendeles (
  rendelesszam d_rendelesszam references rendeles(rendelesszam)
    on update cascade on delete restrict,
  torzsszam d_torzsszam references dolgozo (torzsszam)
    on update cascade on delete restrict,
  mettol date not null default current_date,
  meddig date not null default current_date + 7,
  primary key(rendelesszam, torzsszam)
) with oids;

create view kimitcsinal as
select * from osszerendeles 
  join dolgozo using(torzsszam) 
  join rendeles using(rendelesszam) order by 1,2;

-- Betöltések
\i ktghely.sql
\i dolgozok.sql
\i rendelesek.sql
\i tesztkartya.sql

-- kartya tábla feltöltése
insert into kartya(kartyaszam,torzsszam) select torzsszam, torzsszam from
dolgozo order by 1;

-- Betöltés után kártyaszámok igazítása
do
$$
	declare
		o int;
		ct int;
	begin
		select min(oid) into o from kartya;
		select count(*) into ct from kartya;
		ct := ct-1;
		for i in 0..ct loop
			update kartya set kartyaszam=i where oid::int - i = o;
		end loop;
	end;
$$
;

-- osszerendeles tábla feltöltése
insert into osszerendeles(torzsszam, rendelesszam) 
  select torzsszam,rendelesszam from dolgozo,rendeles 
    where ktghely ilike'%425%' and rendelesszam ilike '71%' order by 1;
    
-- fényképek igazítása...
do
$$
	begin
		for i in 0..9 loop
		update dolgozo set fenykep='d'||i||'.png' where torzsszam::int %10 = i;
		end loop;
	end;
$$
;



