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
create domain d_sarzs as varchar(25) default null;

-- Költséghelyek táblája
create table ktghely (
	ktghely d_ktghely primary key,
	ktghelynev d_ktghelynev not null
) with oids;

-- Dolgozók táblája
create table dolgozo (
	torzsszam d_torzsszam primary key,
	nev d_dolgozonev not null,
	ktghely d_ktghely references ktghely(ktghely) 
		on delete restrict on update cascade,
	fenykep d_fajl
) with oids;

-- Belépőkártyák táblája
create table kartya (
	kartyaszam d_kartyaszam primary key,
	torzsszam d_torzsszam references dolgozo(torzsszam)
		on delete restrict on update cascade,
	allandokartya d_allandokartya
) with oids;

-- Rendelések táblája
create table rendeles (
	rendelesszam d_rendelesszam primary key,
	cikkszam d_cikkszam,
	megnevezes d_megnevezes not null,
	mennyiseg d_mennyiseg,
	sarzs d_sarzs,
	szekvenciaszam d_szekvenciaszam default null,
	nyitott d_nyitott
) with oids;

-- Melyik dolgozóhoz milyen rendelést kapcsolt a művezető és meddig.
create table osszerendeles (
	rendelesszam d_rendelesszam references rendeles(rendelesszam)
		on update cascade on delete restrict,
	torzsszam d_torzsszam references dolgozo (torzsszam)
		on update cascade on delete restrict,
	mettol date not null default current_date,
	meddig date not null default current_date + 7,
		primary key(rendelesszam, torzsszam)
) with oids;


-- Kinek mi a feladata nézet tábla
create view kimitcsinal as
	select * from osszerendeles 
		join dolgozo using(torzsszam) 
		join rendeles using(rendelesszam) 
		where nyitott
		order by 1,2;
  

-- Visszajelentések rögzítése  
create table rogzit (
	rendelesszam d_rendelesszam,
	torzsszam d_torzsszam,
	kezd	timestamp without time zone default current_timestamp,
	vegez	timestamp without time zone default null,
	foreign key (rendelesszam, torzsszam) 
		references osszerendeles(rendelesszam, torzsszam)
		on update cascade on delete restrict
) with oids;


-- Ez itt nem jó...
-- create or replace rule visszajelent as on insert to rogzit 
	-- where (new.rendelesszam = new.rendelesszam and new.torzsszam=new.torzsszam
		-- and kezd is not null and vegez is null)
	-- do instead
	-- update rogzit set vegez=current_timestamp where rendelesszam=new.rendelesszam and torzsszam=new.torzsszam;

-- Betöltések
\i ktghely.sql
\i dolgozok.sql
\i rendelesek.sql


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
		ct := ct-1; raise notice '%, %', o,ct;
		for i in 0..ct loop
			update kartya set kartyaszam=i where oid::int - i = o;
		end loop;
	end;
$$
;

\i tesztkartya.sql

-- Olyan rendelések lezárása, melyek szekvenciaszáma 0 (nulla).
update rendeles set nyitott='f' where szekvenciaszam is null;

-- osszerendeles tábla feltöltése
insert into osszerendeles(torzsszam, rendelesszam) 
  select torzsszam,rendelesszam from dolgozo,rendeles 
	where ktghely ilike'%425%' and rendelesszam ilike '71%' and nyitott order by 1;
	
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


-- Kártyaszám ö-0 karakterek cseréjér
-- A kártyaolvasó angol nyelvű billentyűzetet emulál...
create or replace function kartyaszamcsere(text) returns text as $$
declare
begin
	return left(replace($1,'ö','0'),10);
end;
$$
language 'plpgsql';

