CREATE SCHEMA avdpool
;
COMMENT ON SCHEMA avdpool IS 'TEST Schema für GRetljob'
;
CREATE TABLE avdpool.bbav93dm01 (
	id serial NOT NULL,
	dm01 int4 NULL,
	av93 int4 NULL,
	CONSTRAINT bbav93dm01_pkey PRIMARY KEY (id)
);

CREATE TABLE avdpool.bdbed (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	art int4 NULL, -- Art der Bodenbedeckung:¶0: Gebäude¶1: Strasse¶2: Weg¶3: Trottoir¶4: Verkehrsinsel¶5: Bahn¶6: Flugplatz¶7: Wasserbecken¶8: Sportanlage befestigt¶9: Lagerplatz¶10: Böschungsbauwerk¶11: Gebäudeerschliessung¶12: Parkplatz befestigt¶13: übrige befestigte¶14: Acker, Wiese¶15: Weide¶16: Reben¶17: Obstkultur¶18: übrige Intensiv¶19: Gartenanlage¶20: Parkanlage humusiert¶21: Sportanlage humusiert¶22: Friedhof¶23: Hoch-, Flachmoor¶24: übrige Humusierte¶25: Stehendes Gewässer ¶26: Fliessendes Gewässer¶27: Schilfgürtel¶28: Geschlossener Wald¶29: Parkanlage bestockt¶30: Hecken¶31: übrige Bestockte¶32: Fels¶33: Geröll, Sand¶34: Steinbruch¶35: Kiesgrube¶36: Deponie¶37: übriger Abbau¶38: übrige Vegetationslose¶39: Wytweide dicht¶40: Wytweide offen¶41: Gletschter, Firn
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	los int2 NULL, -- Teilgebiet
	CONSTRAINT bdbed_pkey PRIMARY KEY (ogc_fid)

	)
WITH (
	OIDS=TRUE
);
CREATE INDEX bdbed_art_idx ON avdpool.bdbed USING btree (art) WHERE (archive = 0);
CREATE INDEX bdbed_gembfs_idx ON avdpool.bdbed USING btree (gem_bfs) WHERE (archive = 0);
CREATE INDEX bdbed_idx ON avdpool.bdbed USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX bdbed_oid_idx ON avdpool.bdbed USING btree (oid) WHERE (archive = 0);
COMMENT ON TABLE avdpool.bdbed IS 'aV93 - Bodenbedeckung';

-- Column comments

COMMENT ON COLUMN avdpool.bdbed.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.bdbed.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.bdbed.art IS 'Art der Bodenbedeckung:
0: Gebäude
1: Strasse
2: Weg
3: Trottoir
4: Verkehrsinsel
5: Bahn
6: Flugplatz
7: Wasserbecken
8: Sportanlage befestigt
9: Lagerplatz
10: Böschungsbauwerk
11: Gebäudeerschliessung
12: Parkplatz befestigt
13: übrige befestigte
14: Acker, Wiese
15: Weide
16: Reben
17: Obstkultur
18: übrige Intensiv
19: Gartenanlage
20: Parkanlage humusiert
21: Sportanlage humusiert
22: Friedhof
23: Hoch-, Flachmoor
24: übrige Humusierte
25: Stehendes Gewässer 
26: Fliessendes Gewässer
27: Schilfgürtel
28: Geschlossener Wald
29: Parkanlage bestockt
30: Hecken
31: übrige Bestockte
32: Fels
33: Geröll, Sand
34: Steinbruch
35: Kiesgrube
36: Deponie
37: übriger Abbau
38: übrige Vegetationslose
39: Wytweide dicht
40: Wytweide offen
41: Gletschter, Firn';
COMMENT ON COLUMN avdpool.bdbed.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.bdbed.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.bdbed.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.bdbed.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.bdbed.los IS 'Teilgebiet';

CREATE TABLE avdpool.bdbed_objnam (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	namori float8 NULL, -- Orientierung des Textes im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	namhali int4 NULL, -- horizontale Textausrichtung
	namvali int4 NULL, -- vertikale Textausrichtung
	namhoehe varchar NULL, -- Schriftgroesse: <br> 0: klein <br> 1: mittel <br> 2: gross
	"name" varchar NULL, -- Name des Objektnamens
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	typ int4 NULL, -- Typ des Objektnamens (Point of Interest):¶0: Allgemein¶100: Kindergarten¶101: Volksschule¶102: Berufsschule¶103: Gymnasium¶104: Hochschule¶105: Privatschule¶200: Poststelle¶201: Kinderkrippe¶202: Tagesstätte / VEBO¶203: Einkaufszentrum (z.B. Gäupark)¶204: Gewerbezentrum¶300: Heim (öffentl. und privat)¶301: Spital (öffentlich oder privat)¶401: Theater, Saalbau / Kino¶403: Kunsteisbahn¶404: Freibad¶405: Hallenbad¶406: Sportanlage (Tennis, Fussballplatz etc.)¶407: Turnhalle, Mehrzweckhalle¶409: offene Schiessanlage¶411: Gewässer (See, Weiher etc.)¶412: Freizeitgebäude¶413: Golfanlage¶414: Bibliothek¶415: Jugendhaus / Kulturzentrum¶500: kirchlicher Bau (Kloster, Kapelle etc.)¶501: Friedhof¶502: Krematorium / Aufbahrungshalle¶600: Hotel / Motel¶601: Restaurant / Tea Room / Café¶602: Sehenswürdigkeit (Denkmal etc.)¶603: Aussichtspunkt, -turm etc.¶604: Naturobjekt (erratischer Block, Höhle etc.)¶605: Schloss, Burg, Ruine, Turm¶606: Campingplatz¶607: Waldhütte¶608: Seilbahn, Skilift, Rodelbahn¶609: Rastplatz¶610: Parkanlage (Woldpark etc.)¶700: Bahnhof¶702: Flugplatz¶703: Parkhaus¶704: Bootshafen¶705: öffentl. Schifflände¶706: öffentl. Fähre¶800: Stadthaus, Rathaus¶801: Gemeindehaus / Gemeindeverwaltung¶802: Kantonsverwaltung¶803: Bundesverwaltung¶804: Zeughaus¶805: kirchliche Verwaltung (Pfarramt, Pfarrhaus etc.)¶806: Polizeiposten¶807: Zollamt¶900: öffentl. Werkhof / Mehrzweckgebäude¶901: öffentl. Feuerwehrgebäude¶902: Reservoir¶903: Kläranlage / ARA¶904: Kehrrichtverbrennung¶905: Kraftwerk¶906: Pumpwerk¶907: Zivilschutzanlage¶908: militärische Bauten¶909: Strafvollzug¶910: Kompostieranlage¶999: übriges¶400: Museum
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	txt_rot float8 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	los int2 NULL, -- Teilgebiet
	CONSTRAINT bdbed_objnam_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX bdbed_objnam_gem_bfs_idx ON avdpool.bdbed_objnam USING btree (gem_bfs);
CREATE INDEX bdbed_objnam_idx ON avdpool.bdbed_objnam USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX bdbed_objnam_oid_idx ON avdpool.bdbed_objnam USING btree (oid);
COMMENT ON TABLE avdpool.bdbed_objnam IS 'aV93 - Bodenbedeckung Objektnamen';

-- Column comments

COMMENT ON COLUMN avdpool.bdbed_objnam.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.bdbed_objnam.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.bdbed_objnam.namori IS 'Orientierung des Textes im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.bdbed_objnam.namhali IS 'horizontale Textausrichtung';
COMMENT ON COLUMN avdpool.bdbed_objnam.namvali IS 'vertikale Textausrichtung';
COMMENT ON COLUMN avdpool.bdbed_objnam.namhoehe IS 'Schriftgroesse: <br> 0: klein <br> 1: mittel <br> 2: gross';
COMMENT ON COLUMN avdpool.bdbed_objnam."name" IS 'Name des Objektnamens';
COMMENT ON COLUMN avdpool.bdbed_objnam.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.bdbed_objnam.typ IS 'Typ des Objektnamens (Point of Interest):
0: Allgemein
100: Kindergarten
101: Volksschule
102: Berufsschule
103: Gymnasium
104: Hochschule
105: Privatschule
200: Poststelle
201: Kinderkrippe
202: Tagesstätte / VEBO
203: Einkaufszentrum (z.B. Gäupark)
204: Gewerbezentrum
300: Heim (öffentl. und privat)
301: Spital (öffentlich oder privat)
401: Theater, Saalbau / Kino
403: Kunsteisbahn
404: Freibad
405: Hallenbad
406: Sportanlage (Tennis, Fussballplatz etc.)
407: Turnhalle, Mehrzweckhalle
409: offene Schiessanlage
411: Gewässer (See, Weiher etc.)
412: Freizeitgebäude
413: Golfanlage
414: Bibliothek
415: Jugendhaus / Kulturzentrum
500: kirchlicher Bau (Kloster, Kapelle etc.)
501: Friedhof
502: Krematorium / Aufbahrungshalle
600: Hotel / Motel
601: Restaurant / Tea Room / Café
602: Sehenswürdigkeit (Denkmal etc.)
603: Aussichtspunkt, -turm etc.
604: Naturobjekt (erratischer Block, Höhle etc.)
605: Schloss, Burg, Ruine, Turm
606: Campingplatz
607: Waldhütte
608: Seilbahn, Skilift, Rodelbahn
609: Rastplatz
610: Parkanlage (Woldpark etc.)
700: Bahnhof
702: Flugplatz
703: Parkhaus
704: Bootshafen
705: öffentl. Schifflände
706: öffentl. Fähre
800: Stadthaus, Rathaus
801: Gemeindehaus / Gemeindeverwaltung
802: Kantonsverwaltung
803: Bundesverwaltung
804: Zeughaus
805: kirchliche Verwaltung (Pfarramt, Pfarrhaus etc.)
806: Polizeiposten
807: Zollamt
900: öffentl. Werkhof / Mehrzweckgebäude
901: öffentl. Feuerwehrgebäude
902: Reservoir
903: Kläranlage / ARA
904: Kehrrichtverbrennung
905: Kraftwerk
906: Pumpwerk
907: Zivilschutzanlage
908: militärische Bauten
909: Strafvollzug
910: Kompostieranlage
999: übriges
400: Museum';
COMMENT ON COLUMN avdpool.bdbed_objnam.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.bdbed_objnam.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.bdbed_objnam.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.bdbed_objnam.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.bdbed_objnam.los IS 'Teilgebiet';

CREATE TABLE avdpool.bdbed_proj (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	art int4 NULL, -- Art der Bodenbedeckung:¶0: Gebäude¶1: Strasse¶2: Weg¶3: Trottoir¶4: Verkehrsinsel¶5: Bahn¶6: Flugplatz¶7: Wasserbecken¶8: Sportanlage befestigt¶9: Lagerplatz¶10: Böschungsbauwerk¶11: Gebäudeerschliessung¶12: Parkplatz befestigt¶13: übrige befestigte¶14: Acker, Wiese¶15: Weide¶16: Reben¶17: Obstkultur¶18: übrige Intensiv¶19: Gartenanlage¶20: Parkanlage humusiert¶21: Sportanlage humusiert¶22: Friedhof¶23: Hoch-, Flachmoor¶24: übrige Humusierte¶25: Stehendes Gewässer ¶26: Fliessendes Gewässer¶27: Schilfgürtel¶28: Geschlossener Wald¶29: Parkanlage bestockt¶30: Hecken¶31: übrige Bestockte¶32: Fels¶33: Geröll, Sand¶34: Steinbruch¶35: Kiesgrube¶36: Deponie¶37: übriger Abbau¶38: übrige Vegetationslose¶39: Wytweide dicht¶40: Wytweide offen¶41: Gletschter, Firn
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	los int2 NULL, -- Teilgebiet
		CONSTRAINT bdbed_proj_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX bdbed_proj_art_idx ON avdpool.bdbed_proj USING btree (art) WHERE (archive = 0);
CREATE INDEX bdbed_proj_gembfs_idx ON avdpool.bdbed_proj USING btree (gem_bfs) WHERE (archive = 0);
CREATE INDEX bdbed_proj_idx ON avdpool.bdbed_proj USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX bdbed_proj_oid_idx ON avdpool.bdbed_proj USING btree (oid) WHERE (archive = 0);
COMMENT ON TABLE avdpool.bdbed_proj IS 'aV93 - Bodenbedeckung projektierte Objekte';

-- Column comments

COMMENT ON COLUMN avdpool.bdbed_proj.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.bdbed_proj.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.bdbed_proj.art IS 'Art der Bodenbedeckung:
0: Gebäude
1: Strasse
2: Weg
3: Trottoir
4: Verkehrsinsel
5: Bahn
6: Flugplatz
7: Wasserbecken
8: Sportanlage befestigt
9: Lagerplatz
10: Böschungsbauwerk
11: Gebäudeerschliessung
12: Parkplatz befestigt
13: übrige befestigte
14: Acker, Wiese
15: Weide
16: Reben
17: Obstkultur
18: übrige Intensiv
19: Gartenanlage
20: Parkanlage humusiert
21: Sportanlage humusiert
22: Friedhof
23: Hoch-, Flachmoor
24: übrige Humusierte
25: Stehendes Gewässer 
26: Fliessendes Gewässer
27: Schilfgürtel
28: Geschlossener Wald
29: Parkanlage bestockt
30: Hecken
31: übrige Bestockte
32: Fels
33: Geröll, Sand
34: Steinbruch
35: Kiesgrube
36: Deponie
37: übriger Abbau
38: übrige Vegetationslose
39: Wytweide dicht
40: Wytweide offen
41: Gletschter, Firn';
COMMENT ON COLUMN avdpool.bdbed_proj.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.bdbed_proj.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.bdbed_proj.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.bdbed_proj.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.bdbed_proj.los IS 'Teilgebiet';

CREATE TABLE avdpool.bdbed_symbol (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int4 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	symbolori float4 NULL, -- Winkel des Objektes in Neugrad
	art int2 NULL, -- Art des Symbols:¶0: Fließrichtung¶1: Schilfgürtel¶2: Wasserbecken¶3: Moor¶4: Reben
	txt_rot float4 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	los int2 NULL, -- Teilgebiet
	CONSTRAINT bdbed_symbol_pkey PRIMARY KEY (ogc_fid)
	);
CREATE INDEX bdbed_symbol_idx ON avdpool.bdbed_symbol USING gist (wkb_geometry) WHERE (archive = 0);
COMMENT ON TABLE avdpool.bdbed_symbol IS 'Position zusätzlicher Symbole der Bodenbedeckung wie z.B. Fließrichtungen.';

-- Column comments

COMMENT ON COLUMN avdpool.bdbed_symbol.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.bdbed_symbol.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.bdbed_symbol.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.bdbed_symbol.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.bdbed_symbol.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.bdbed_symbol.symbolori IS 'Winkel des Objektes in Neugrad';
COMMENT ON COLUMN avdpool.bdbed_symbol.art IS 'Art des Symbols:
0: Fließrichtung
1: Schilfgürtel
2: Wasserbecken
3: Moor
4: Reben';
COMMENT ON COLUMN avdpool.bdbed_symbol.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.bdbed_symbol.los IS 'Teilgebiet';

CREATE TABLE avdpool.cvs_revisions (
	rev_id serial NOT NULL,
	file varchar NULL,
	revision int2 NULL DEFAULT 0,
	CONSTRAINT cvs_revisions_pkey PRIMARY KEY (rev_id)
);
COMMENT ON TABLE avdpool.cvs_revisions IS 'Hält die aktuelle Versionsnummer im CVS pro Operat vor.';

CREATE TABLE avdpool.eoav93dm01 (
	id serial NOT NULL,
	dm01 int4 NULL,
	av93 int4 NULL,
	CONSTRAINT eoav93dm01_pkey PRIMARY KEY (id)
);

CREATE TABLE avdpool.eoline (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	art int4 NULL, -- 0: Mauer¶2: übriger Gebäudeteil¶3: eingedoltes Gewässer¶4: Treppe¶23: Rinnsal¶24: schmaler Weg¶25: Hochspannungsleitung¶26: Druckleitung¶27: Bahngeleise¶28: Luftseilbahn¶29: Gondel-, Sesselbahn¶30: Materialseilbahn¶31: Skilift¶32: Fähre¶34: Achse¶44: Bahngeleise überdeckt
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	los int2 NULL, -- Teilgebiet
	CONSTRAINT eoline_pkey PRIMARY KEY (ogc_fid)

	)
WITH (
	OIDS=TRUE
);
CREATE INDEX eoline_gembfs_idx ON avdpool.eoline USING btree (gem_bfs);
CREATE INDEX eoline_idx ON avdpool.eoline USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX eoline_oid_idx ON avdpool.eoline USING btree (oid);
COMMENT ON TABLE avdpool.eoline IS 'aV93 - Einzelobjekte Linien';

-- Column comments

COMMENT ON COLUMN avdpool.eoline.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.eoline.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.eoline.art IS '0: Mauer
2: übriger Gebäudeteil
3: eingedoltes Gewässer
4: Treppe
23: Rinnsal
24: schmaler Weg
25: Hochspannungsleitung
26: Druckleitung
27: Bahngeleise
28: Luftseilbahn
29: Gondel-, Sesselbahn
30: Materialseilbahn
31: Skilift
32: Fähre
34: Achse
44: Bahngeleise überdeckt';
COMMENT ON COLUMN avdpool.eoline.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.eoline.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.eoline.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.eoline.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.eoline.los IS 'Teilgebiet';

CREATE TABLE avdpool.eopnt (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	symbolor float8 NULL, -- Winkelangabe für die Orientierung der Symbole in der kartographischen Darstellung. Die Winkel werden in GON angegeben. 0° entspricht Nord.
	art int4 NULL, -- 13: Denkmal¶14: Mast, Antenne¶21: einzelner Fels¶33: Grotte, Höhleneingang¶35: Einzelbaum¶36: Kruzifix, Bildstock¶37: Quelle¶38: Bezugspunkt¶41: Mast_Leitung
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	los int2 NULL, -- Teilgebiet
	CONSTRAINT eopnt_pkey PRIMARY KEY (ogc_fid)

	)
WITH (
	OIDS=TRUE
);
CREATE INDEX eopnt_gembfs_idx ON avdpool.eopnt USING btree (gem_bfs);
CREATE INDEX eopnt_idx ON avdpool.eopnt USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX eopnt_oid_idx ON avdpool.eopnt USING btree (oid);
COMMENT ON TABLE avdpool.eopnt IS 'aV93 - Einzelobjekte Punkte';

-- Column comments

COMMENT ON COLUMN avdpool.eopnt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.eopnt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.eopnt.symbolor IS 'Winkelangabe für die Orientierung der Symbole in der kartographischen Darstellung. Die Winkel werden in GON angegeben. 0° entspricht Nord.';
COMMENT ON COLUMN avdpool.eopnt.art IS '13: Denkmal
14: Mast, Antenne
21: einzelner Fels
33: Grotte, Höhleneingang
35: Einzelbaum
36: Kruzifix, Bildstock
37: Quelle
38: Bezugspunkt
41: Mast_Leitung';
COMMENT ON COLUMN avdpool.eopnt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.eopnt.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.eopnt.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.eopnt.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.eopnt.los IS 'Teilgebiet';

CREATE TABLE avdpool.eopoly (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	art int4 NULL, -- 0: Mauer¶1: unterirdisches Gebäude¶2: übriger Gebäudeteil¶3: eingedoltes Gewässer¶4: Treppe¶5: Tunnel, Unterführung¶6: Brücke, Passerelle¶7: Brunnen¶8: Reservoir¶9: Pfeiler¶10: Unterstand¶11: Silo, Turm, Gasometer¶12: Hochkamin¶14: Mast, Antenne¶15: Aussichtsturm¶16: Uferverbauung¶17: Schwelle¶18: Sockel¶19: Ruine¶20: Landungssteg¶22: bestockte Fläche¶24: schmaler Weg¶40: Bahnsteig¶43: Fahrspur
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	new_date timestamp NULL DEFAULT 'now'::text::date, -- Datum des Imports des Objektes
	los int2 NULL, -- Teilgebiet
	CONSTRAINT eopoly_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX eopoly_gembfs_idx ON avdpool.eopoly USING btree (gem_bfs);
CREATE INDEX eopoly_idx ON avdpool.eopoly USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX eopoly_oid_idx ON avdpool.eopoly USING btree (oid);
COMMENT ON TABLE avdpool.eopoly IS 'aV93 - Einzelobjekte Flächen';

-- Column comments

COMMENT ON COLUMN avdpool.eopoly.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.eopoly.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.eopoly.art IS '0: Mauer
1: unterirdisches Gebäude
2: übriger Gebäudeteil
3: eingedoltes Gewässer
4: Treppe
5: Tunnel, Unterführung
6: Brücke, Passerelle
7: Brunnen
8: Reservoir
9: Pfeiler
10: Unterstand
11: Silo, Turm, Gasometer
12: Hochkamin
14: Mast, Antenne
15: Aussichtsturm
16: Uferverbauung
17: Schwelle
18: Sockel
19: Ruine
20: Landungssteg
22: bestockte Fläche
24: schmaler Weg
40: Bahnsteig
43: Fahrspur';
COMMENT ON COLUMN avdpool.eopoly.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.eopoly.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.eopoly.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.eopoly.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.eopoly.los IS 'Teilgebiet';

CREATE TABLE avdpool.flurn (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	"name" varchar NULL, -- Flurname
	los int2 NULL, -- Teilgebiet
	CONSTRAINT flurn_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX flurn_gembfs_idx ON avdpool.flurn USING btree (gem_bfs);
CREATE INDEX flurn_idx ON avdpool.flurn USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX flurn_oid_idx ON avdpool.flurn USING btree (oid);
COMMENT ON TABLE avdpool.flurn IS 'aV93 - Nomenklatur Flurnamen';

-- Column comments

COMMENT ON COLUMN avdpool.flurn.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.flurn.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.flurn.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.flurn.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.flurn.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.flurn.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.flurn."name" IS 'Flurname';
COMMENT ON COLUMN avdpool.flurn.los IS 'Teilgebiet';

CREATE TABLE avdpool.flurn_pos (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	namori float8 NULL, -- Orientierung des Textes im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	namhali int4 NULL, -- horizontale Textausrichtung
	namvali int4 NULL, -- vertikale Textausrichtung
	namhoehe varchar NULL, -- Schriftgroesse: <br> 0: klein <br> 1: mittel <br> 2: gross
	"name" varchar NULL, -- Name des Flurnamens
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	txt_rot float8 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	los int2 NULL, -- Teilgebiet
	CONSTRAINT flurn_pos_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX flurn_pos_gembfs_idx ON avdpool.flurn_pos USING btree (gem_bfs);
CREATE INDEX flurn_pos_idx ON avdpool.flurn_pos USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX flurn_pos_oid_idx ON avdpool.flurn_pos USING btree (oid);
COMMENT ON TABLE avdpool.flurn_pos IS 'aV93 - Flurnamen Position';

-- Column comments

COMMENT ON COLUMN avdpool.flurn_pos.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.flurn_pos.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.flurn_pos.namori IS 'Orientierung des Textes im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.flurn_pos.namhali IS 'horizontale Textausrichtung';
COMMENT ON COLUMN avdpool.flurn_pos.namvali IS 'vertikale Textausrichtung';
COMMENT ON COLUMN avdpool.flurn_pos.namhoehe IS 'Schriftgroesse: <br> 0: klein <br> 1: mittel <br> 2: gross';
COMMENT ON COLUMN avdpool.flurn_pos."name" IS 'Name des Flurnamens';
COMMENT ON COLUMN avdpool.flurn_pos.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.flurn_pos.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.flurn_pos.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.flurn_pos.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.flurn_pos.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.flurn_pos.los IS 'Teilgebiet';

CREATE TABLE avdpool.gebadr (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	polizein varchar NULL, -- Hausnummer
	numori float8 NULL, -- Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	numhali int4 NULL, -- horizontale Ausrichtung der Nummer
	numvali int4 NULL, -- vertikale Ausrichtung der Nummer
	strasse1 varchar NULL, -- Strassenname
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	txt_rot float8 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	los int2 NULL, -- Teilgebiet
	CONSTRAINT gebadr_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX gebadr_gembfs_idx ON avdpool.gebadr USING btree (gem_bfs);
CREATE INDEX gebadr_idx ON avdpool.gebadr USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX gebadr_oid_idx ON avdpool.gebadr USING btree (oid);
COMMENT ON TABLE avdpool.gebadr IS 'Gebäudeadressen';

-- Column comments

COMMENT ON COLUMN avdpool.gebadr.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.gebadr.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.gebadr.polizein IS 'Hausnummer';
COMMENT ON COLUMN avdpool.gebadr.numori IS 'Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.gebadr.numhali IS 'horizontale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.gebadr.numvali IS 'vertikale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.gebadr.strasse1 IS 'Strassenname';
COMMENT ON COLUMN avdpool.gebadr.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.gebadr.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.gebadr.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.gebadr.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.gebadr.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.gebadr.los IS 'Teilgebiet';

CREATE TABLE avdpool.gebein (
	ogc_fid serial NOT NULL,
	strasse1 varchar NULL,
	polizein varchar NULL,
	egid int4 NULL,
	edid int2 NULL,
	status varchar NULL,
	gem_bfs int2 NULL,
	new_date timestamp NULL DEFAULT now(),
	archive_date timestamp NULL DEFAULT '9999-01-01 00:00:00'::timestamp without time zone,
	archive int2 NULL DEFAULT 0,
	wkb_geometry geometry NULL,
	los int2 NULL,
	CONSTRAINT gebein_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX gebein_idx ON avdpool.gebein USING gist (wkb_geometry) WHERE (archive = 0);

CREATE TABLE avdpool.gebnummer (
	ogc_fid serial NOT NULL,
	nummer varchar NULL,
	egid int4 NULL,
	geb_objid varchar NULL,
	gem_bfs int2 NULL,
	new_date timestamp NULL DEFAULT now(),
	archive_date timestamp NULL DEFAULT '9999-01-01 00:00:00'::timestamp without time zone,
	archive int2 NULL DEFAULT 0,
	wkb_geometry geometry NULL,
	los int2 NULL,
		CONSTRAINT gebnummer_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX gebnummer_idx ON avdpool.gebnummer USING gist (wkb_geometry);

CREATE TABLE avdpool.gelaendename (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int4 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	namori float4 NULL, -- Orientierung des Textes im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	namhali int2 NULL, -- horizontale Textausrichtung
	namvali int2 NULL, -- vertikale Textausrichtung
	"name" varchar NULL, -- Geländename
	txt_rot float4 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	gem_bfs int2 NULL, -- BfS-Nummer der Gemeinde
	namhoehe varchar NULL, -- Schriftgroesse: <br> 0: klein <br> 1: mittel <br> 2: gross
	los int2 NULL, -- Teilgebiet
	CONSTRAINT gelaendename_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX gelaendename_idx ON avdpool.gelaendename USING gist (wkb_geometry) WHERE (archive = 0);
COMMENT ON TABLE avdpool.gelaendename IS 'Position der Geländenamen in der Kartendarstellung';

-- Column comments

COMMENT ON COLUMN avdpool.gelaendename.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.gelaendename.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.gelaendename.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.gelaendename.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.gelaendename.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.gelaendename.namori IS 'Orientierung des Textes im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.gelaendename.namhali IS 'horizontale Textausrichtung';
COMMENT ON COLUMN avdpool.gelaendename.namvali IS 'vertikale Textausrichtung';
COMMENT ON COLUMN avdpool.gelaendename."name" IS 'Geländename';
COMMENT ON COLUMN avdpool.gelaendename.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.gelaendename.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.gelaendename.namhoehe IS 'Schriftgroesse: <br> 0: klein <br> 1: mittel <br> 2: gross';
COMMENT ON COLUMN avdpool.gelaendename.los IS 'Teilgebiet';

CREATE TABLE avdpool.gemgre (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	"name" varchar NULL, -- Name der Gemeinde
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	los int2 NULL, -- Teilgebiet
	CONSTRAINT gemgre_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX gemgre_idx ON avdpool.gemgre USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX gemgre_oid_idx ON avdpool.gemgre USING btree (oid);
COMMENT ON TABLE avdpool.gemgre IS 'aV93 - Gemeindegrenze';

-- Column comments

COMMENT ON COLUMN avdpool.gemgre.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.gemgre.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.gemgre."name" IS 'Name der Gemeinde';
COMMENT ON COLUMN avdpool.gemgre.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.gemgre.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.gemgre.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.gemgre.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.gemgre.los IS 'Teilgebiet';

CREATE TABLE avdpool.grenzpnt (
	lagegen float8 NULL, -- Lagegenauigkeit [cm]
	lagezuv int4 NULL, -- Lagezuverlässigkeit:¶0: ja¶1: nein
	punktzeich int4 NULL, -- Versicherungsart des Punktes:¶0: Stein / Kunststoffgrenzzeichen¶1: Bolzen / Rohr / Pfahl¶2: Kreuz¶3: unversichert
	symbolori float8 NULL, -- Orientierung des Symbols im Uhrzeigersinn [gon]:¶0: vertikal¶100: horizontal
	numori float8 NULL, -- Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	numhali int4 NULL, -- horizontale Ausrichtung der Nummer
	numvali int4 NULL, -- vertikale Ausrichtung der Nummer
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	gem_bfs int2 NULL, -- BfS-Nummer der Gemeinde
	txt_rot float8 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	new_date date NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date date NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	ogc_fid serial NOT NULL, -- OGC Feature ID
	los int2 NULL, -- Teilgebiet
	CONSTRAINT grenzpnt_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX grenzpnt_gembfs_idx ON avdpool.grenzpnt USING btree (gem_bfs);
CREATE INDEX grenzpnt_idx ON avdpool.grenzpnt USING gist (wkb_geometry) WHERE (archive = 0);
COMMENT ON TABLE avdpool.grenzpnt IS 'Grenzpunkte';

-- Column comments

COMMENT ON COLUMN avdpool.grenzpnt.lagegen IS 'Lagegenauigkeit [cm]';
COMMENT ON COLUMN avdpool.grenzpnt.lagezuv IS 'Lagezuverlässigkeit:
0: ja
1: nein';
COMMENT ON COLUMN avdpool.grenzpnt.punktzeich IS 'Versicherungsart des Punktes:
0: Stein / Kunststoffgrenzzeichen
1: Bolzen / Rohr / Pfahl
2: Kreuz
3: unversichert';
COMMENT ON COLUMN avdpool.grenzpnt.symbolori IS 'Orientierung des Symbols im Uhrzeigersinn [gon]:
0: vertikal
100: horizontal';
COMMENT ON COLUMN avdpool.grenzpnt.numori IS 'Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.grenzpnt.numhali IS 'horizontale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.grenzpnt.numvali IS 'vertikale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.grenzpnt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.grenzpnt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.grenzpnt.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.grenzpnt.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.grenzpnt.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.grenzpnt.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.grenzpnt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.grenzpnt.los IS 'Teilgebiet';

CREATE TABLE avdpool.hfp2 (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	nummer varchar NULL, -- Punktnummer
	hoehegeo float8 NULL, -- Höhe [m]
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	los int2 NULL, -- Teilgebiet
	CONSTRAINT hfp2_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX hfp2_gembfs_idx ON avdpool.hfp2 USING btree (gem_bfs);
CREATE INDEX hfp2_idx ON avdpool.hfp2 USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX hfp2_oid_idx ON avdpool.hfp2 USING btree (oid);
CREATE UNIQUE INDEX ogc_fid_hfp2_ukey ON avdpool.hfp2 USING btree (ogc_fid);
COMMENT ON TABLE avdpool.hfp2 IS 'aV93 - Lagefixpunkte hfp3';

-- Column comments

COMMENT ON COLUMN avdpool.hfp2.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.hfp2.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.hfp2.nummer IS 'Punktnummer';
COMMENT ON COLUMN avdpool.hfp2.hoehegeo IS 'Höhe [m]';
COMMENT ON COLUMN avdpool.hfp2.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.hfp2.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.hfp2.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.hfp2.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.hfp2.los IS 'Teilgebiet';

CREATE TABLE avdpool.hfp3 (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	nummer varchar NULL, -- Punktnummer
	numori float8 NULL, -- Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	numhali int4 NULL, -- horizontale Ausrichtung der Nummer
	numvali int4 NULL, -- vertikale Ausrichtung der Nummer
	hoehegeo float8 NULL, -- Höhe [m]
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	txt_rot float8 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	los int2 NULL, -- Teilgebiet
	CONSTRAINT hfp3_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX hfp3_gembfs_idx ON avdpool.hfp3 USING btree (gem_bfs);
CREATE INDEX hfp3_idx ON avdpool.hfp3 USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX hfp3_oid_idx ON avdpool.hfp3 USING btree (oid);
CREATE UNIQUE INDEX ogc_fid_hfp3_ukey ON avdpool.hfp3 USING btree (ogc_fid);
COMMENT ON TABLE avdpool.hfp3 IS 'aV93 - Lagefixpunkte hfp3';

-- Column comments

COMMENT ON COLUMN avdpool.hfp3.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.hfp3.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.hfp3.nummer IS 'Punktnummer';
COMMENT ON COLUMN avdpool.hfp3.numori IS 'Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.hfp3.numhali IS 'horizontale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.hfp3.numvali IS 'vertikale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.hfp3.hoehegeo IS 'Höhe [m]';
COMMENT ON COLUMN avdpool.hfp3.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.hfp3.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.hfp3.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.hfp3.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.hfp3.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.hfp3.los IS 'Teilgebiet';

CREATE TABLE avdpool.hgpkt (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int4 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	identifikator varchar NULL, -- Nummer des Grenzpunktes
	lagegen float4 NULL, -- Lagegenauigkeit in cm
	lagezuv int2 NULL, -- Ist die Lage zuverlässig:¶0: ja¶1: nein
	punktzeichen int2 NULL, -- Code der Vermarkungsart:¶0:¶
	symbolori float4 NULL, -- Orientierung des Symbols in der Karte in Neugrad
	numori float4 NULL, -- Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	numhali int2 NULL, -- horizontale Ausrichtung der Nummer
	numvali int2 NULL, -- vertikale Ausrichtung der Nummer
	txt_rot float4 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	gem_bfs int2 NULL, -- BfS-Nummer der Gemeinde
	los int2 NULL, -- Teilgebiet
	CONSTRAINT hgpkt_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX hgpkt_idx ON avdpool.hgpkt USING gist (wkb_geometry) WHERE (archive = 0);
COMMENT ON TABLE avdpool.hgpkt IS 'Hoheitsgrenzpunkte';

-- Column comments

COMMENT ON COLUMN avdpool.hgpkt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.hgpkt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.hgpkt.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.hgpkt.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.hgpkt.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.hgpkt.identifikator IS 'Nummer des Grenzpunktes';
COMMENT ON COLUMN avdpool.hgpkt.lagegen IS 'Lagegenauigkeit in cm';
COMMENT ON COLUMN avdpool.hgpkt.lagezuv IS 'Ist die Lage zuverlässig:
0: ja
1: nein';
COMMENT ON COLUMN avdpool.hgpkt.punktzeichen IS 'Code der Vermarkungsart:
0:
';
COMMENT ON COLUMN avdpool.hgpkt.symbolori IS 'Orientierung des Symbols in der Karte in Neugrad';
COMMENT ON COLUMN avdpool.hgpkt.numori IS 'Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.hgpkt.numhali IS 'horizontale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.hgpkt.numvali IS 'vertikale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.hgpkt.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.hgpkt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.hgpkt.los IS 'Teilgebiet';

CREATE TABLE avdpool.hohgre (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	art int2 NULL, -- Art der Hoheitsgrenze:¶0: Bezirksgrenze¶1: Kantonsgrenze¶2: Landesgrenze
	gem_bfs int2 NULL, -- BfS-Nummer der Gemeinde
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01 00:00:00'::timestamp without time zone, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	los int2 NULL, -- Teilgebiet
	CONSTRAINT hohgre_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX hohgre_idx ON avdpool.hohgre USING gist (wkb_geometry) WHERE (archive = 0);
COMMENT ON TABLE avdpool.hohgre IS 'Hoheitsgrenzen der Amtlichen vermessung';

-- Column comments

COMMENT ON COLUMN avdpool.hohgre.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.hohgre.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.hohgre.art IS 'Art der Hoheitsgrenze:
0: Bezirksgrenze
1: Kantonsgrenze
2: Landesgrenze';
COMMENT ON COLUMN avdpool.hohgre.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.hohgre.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.hohgre.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.hohgre.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.hohgre.los IS 'Teilgebiet';

CREATE TABLE avdpool.lfp3 (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	nummer varchar NULL, -- Punktnummer
	numori float8 NULL, -- Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	numhali int4 NULL, -- horizontale Ausrichtung der Nummer
	numvali int4 NULL, -- vertikale Ausrichtung der Nummer
	hoehegeo float8 NULL, -- Höhe [m]
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	txt_rot float8 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	new_date timestamp NULL DEFAULT 'now'::text::date, -- Datum des Imports des Objektes
	punktzeich int4 NULL, -- Versicherungsart
	los int2 NULL, -- Teilgebiet
	CONSTRAINT lfp3_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX lfp3_gembfs_idx ON avdpool.lfp3 USING btree (gem_bfs);
CREATE INDEX lfp3_idx ON avdpool.lfp3 USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX lfp3_oid_idx ON avdpool.lfp3 USING btree (oid);
CREATE UNIQUE INDEX ogc_fid_lfp3_ukey ON avdpool.lfp3 USING btree (ogc_fid);
COMMENT ON TABLE avdpool.lfp3 IS 'aV93 - Lagefixpunkte LFP3';

-- Column comments

COMMENT ON COLUMN avdpool.lfp3.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.lfp3.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.lfp3.nummer IS 'Punktnummer';
COMMENT ON COLUMN avdpool.lfp3.numori IS 'Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.lfp3.numhali IS 'horizontale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.lfp3.numvali IS 'vertikale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.lfp3.hoehegeo IS 'Höhe [m]';
COMMENT ON COLUMN avdpool.lfp3.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.lfp3.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.lfp3.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.lfp3.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.lfp3.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.lfp3.punktzeich IS 'Versicherungsart';
COMMENT ON COLUMN avdpool.lfp3.los IS 'Teilgebiet';

CREATE TABLE avdpool.lieferantenoperat (
	gde_nr int4 NULL, -- BFS Nummer der Operatsgemeinde
	id serial NOT NULL, -- Eindutiger Bezeichner
	nfgeometer_id int2 NULL,
	CONSTRAINT lieferanten_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE avdpool.lieferantenoperat IS 'Lieferanten in den DPOOL';

-- Column comments

COMMENT ON COLUMN avdpool.lieferantenoperat.gde_nr IS 'BFS Nummer der Operatsgemeinde';
COMMENT ON COLUMN avdpool.lieferantenoperat.id IS 'Eindutiger Bezeichner';

CREATE TABLE avdpool.lieferungen (
	lieferung_id bigserial NOT NULL, -- Eindeutiger Bezeichner
	filename varchar NOT NULL, -- Name der gelieferten Datei
	datum timestamp NOT NULL DEFAULT now(), -- Zeitstempel der Lieferung
	CONSTRAINT lieferung_id_pkey PRIMARY KEY (lieferung_id)
)
WITH (
	OIDS=TRUE
);
COMMENT ON TABLE avdpool.lieferungen IS 'Via DPOOL Import erfolgreich importierte AV Lieferungen';

-- Column comments

COMMENT ON COLUMN avdpool.lieferungen.lieferung_id IS 'Eindeutiger Bezeichner';
COMMENT ON COLUMN avdpool.lieferungen.filename IS 'Name der gelieferten Datei';
COMMENT ON COLUMN avdpool.lieferungen.datum IS 'Zeitstempel der Lieferung';

CREATE TABLE avdpool.liegen (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	flaechen int4 NULL, -- Flächeninhalt durch den Geometer geführt
	art int4 NULL, -- Art der Liegenschaft
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	nummer varchar NULL, -- Grundbuchnummer
	los int2 NULL, -- Teilgebiet
	CONSTRAINT liegen_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX bfs_nummer_idx ON avdpool.liegen USING btree (gem_bfs, nummer);
CREATE INDEX gem_bfs_idx ON avdpool.liegen USING btree (gem_bfs);
CREATE INDEX liegen_idx ON avdpool.liegen USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX nummer_idx ON avdpool.liegen USING btree (nummer);
CREATE INDEX oid_idx ON avdpool.liegen USING btree (oid);
COMMENT ON TABLE avdpool.liegen IS 'aV93 - Liegenschaften';

-- Column comments

COMMENT ON COLUMN avdpool.liegen.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.liegen.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.liegen.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.liegen.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.liegen.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.liegen.flaechen IS 'Flächeninhalt durch den Geometer geführt';
COMMENT ON COLUMN avdpool.liegen.art IS 'Art der Liegenschaft';
COMMENT ON COLUMN avdpool.liegen.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.liegen.nummer IS 'Grundbuchnummer';
COMMENT ON COLUMN avdpool.liegen.los IS 'Teilgebiet';

CREATE TABLE avdpool.liegen_pos (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	numori float8 NULL, -- Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	numhali int4 NULL, -- horizontale Ausrichtung der Nummer
	numvali int4 NULL, -- vertikale Ausrichtung der Nummer
	nummer varchar NULL, -- Grundbuchnummer der Liegenschaft
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	txt_rot float8 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	los int2 NULL, -- Teilgebiet
	CONSTRAINT liegen_pos_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX liegen_pos_gembfs_idx ON avdpool.liegen_pos USING btree (gem_bfs);
CREATE INDEX liegen_pos_idx ON avdpool.liegen_pos USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX liegen_pos_oid_idx ON avdpool.liegen_pos USING btree (oid);
COMMENT ON TABLE avdpool.liegen_pos IS 'aV93 - Liegenschaften Position Grundbuchnummer';

-- Column comments

COMMENT ON COLUMN avdpool.liegen_pos.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.liegen_pos.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.liegen_pos.numori IS 'Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.liegen_pos.numhali IS 'horizontale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.liegen_pos.numvali IS 'vertikale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.liegen_pos.nummer IS 'Grundbuchnummer der Liegenschaft';
COMMENT ON COLUMN avdpool.liegen_pos.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.liegen_pos.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.liegen_pos.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.liegen_pos.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.liegen_pos.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.liegen_pos.los IS 'Teilgebiet';

CREATE TABLE avdpool.nfgeometer (
	nf_geomete varchar NULL,
	unternehme varchar NULL,
	nfgeometer_id serial NOT NULL,
	email varchar NULL,
	strasse varchar NULL,
	hausnummer varchar NULL,
	plz varchar NULL,
	ort varchar NULL,
	telephon varchar NULL,
	weekly bool NULL DEFAULT true,
	CONSTRAINT nfgeometer_id_pkey PRIMARY KEY (nfgeometer_id)
);

CREATE TABLE avdpool.notification (
	notification_id serial NOT NULL,
	notification_type int2 NULL DEFAULT 1,
	e_mail varchar NULL,
	CONSTRAINT notification_id_pkey PRIMARY KEY (notification_id)
);
COMMENT ON TABLE avdpool.notification IS 'Tabelle zur Administration der Email Adressen AV';


CREATE TABLE avdpool.operate_verifiziert (
	id serial NOT NULL,
	gem_bfs int2 NOT NULL,
	modell varchar NOT NULL,
	CONSTRAINT operate_verifiziert_pkey PRIMARY KEY (gem_bfs, modell)
);
COMMENT ON TABLE avdpool.operate_verifiziert IS 'Tabelle der verifizierten Operate zur Prüfung im Importprozess';


CREATE TABLE avdpool.ortsnam (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	"name" varchar NULL, -- Ortsname
	los int2 NULL, -- Teilgebiet
	CONSTRAINT ortsnam_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX ortsnam_gembfs_idx ON avdpool.ortsnam USING btree (gem_bfs);
CREATE INDEX ortsnam_idx ON avdpool.ortsnam USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX ortsnam_oid_idx ON avdpool.ortsnam USING btree (oid);
COMMENT ON TABLE avdpool.ortsnam IS 'aV93 - Nomenklatur ortsnamamen';

-- Column comments

COMMENT ON COLUMN avdpool.ortsnam.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.ortsnam.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.ortsnam.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.ortsnam.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.ortsnam.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.ortsnam.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.ortsnam."name" IS 'Ortsname';
COMMENT ON COLUMN avdpool.ortsnam.los IS 'Teilgebiet';

CREATE TABLE avdpool.ortsnam_pos (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	namori float8 NULL, -- Orientierung des Textes im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	namhali int4 NULL, -- horizontale Textausrichtung
	namvali int4 NULL, -- vertikale Textausrichtung
	namhoehe int4 NULL, -- Schriftgroesse: <br> 0: klein <br> 1: mittel <br> 2: gross
	"name" varchar NULL, -- Ortsname
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	txt_rot float8 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	los int2 NULL, -- Teilgebiet
	CONSTRAINT ortsnam_pos_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX ortsnam_pos_gembfs_idx ON avdpool.ortsnam_pos USING btree (gem_bfs);
CREATE INDEX ortsnam_pos_idx ON avdpool.ortsnam_pos USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX ortsnam_pos_oid_idx ON avdpool.ortsnam_pos USING btree (oid);
COMMENT ON TABLE avdpool.ortsnam_pos IS 'aV93 - ortsnamamen Position';

-- Column comments

COMMENT ON COLUMN avdpool.ortsnam_pos.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.ortsnam_pos.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.ortsnam_pos.namori IS 'Orientierung des Textes im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.ortsnam_pos.namhali IS 'horizontale Textausrichtung';
COMMENT ON COLUMN avdpool.ortsnam_pos.namvali IS 'vertikale Textausrichtung';
COMMENT ON COLUMN avdpool.ortsnam_pos.namhoehe IS 'Schriftgroesse: <br> 0: klein <br> 1: mittel <br> 2: gross';
COMMENT ON COLUMN avdpool.ortsnam_pos."name" IS 'Ortsname';
COMMENT ON COLUMN avdpool.ortsnam_pos.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.ortsnam_pos.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.ortsnam_pos.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.ortsnam_pos.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.ortsnam_pos.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.ortsnam_pos.los IS 'Teilgebiet';

CREATE TABLE avdpool.planeinteilung (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int4 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	nummer varchar NULL, -- Plannummer
	gem_bfs int2 NULL, -- BfS-Nummer der Gemeinde
	los int2 NULL, -- Teilgebiet
		CONSTRAINT planeinteilung_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX planeinteilung_idx ON avdpool.planeinteilung USING gist (wkb_geometry) WHERE (archive = 0);
COMMENT ON TABLE avdpool.planeinteilung IS 'Planeinteilung des Grundbuchplanes';

-- Column comments

COMMENT ON COLUMN avdpool.planeinteilung.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.planeinteilung.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.planeinteilung.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.planeinteilung.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.planeinteilung.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.planeinteilung.nummer IS 'Plannummer';
COMMENT ON COLUMN avdpool.planeinteilung.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.planeinteilung.los IS 'Teilgebiet';

CREATE TABLE avdpool.poi_typ (
	poi_typ int2 NOT NULL,
	poi_typ_text varchar NULL,
	CONSTRAINT poi_typ_pkey PRIMARY KEY (poi_typ)
);


CREATE TABLE avdpool.proj_grund (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int4 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	art int2 NULL, -- Code zur Art der projektierten Grundstücke
	nummer varchar NULL, -- Nummer des projektierten Grundstückes
	gem_bfs int2 NULL, -- BfS-Nummer der Gemeinde
	los int2 NULL, -- Teilgebiet
	CONSTRAINT proj_grund_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX proj_grund_idx ON avdpool.proj_grund USING gist (wkb_geometry) WHERE (archive = 0);
COMMENT ON TABLE avdpool.proj_grund IS 'Projektierte Grundstücke';

-- Column comments

COMMENT ON COLUMN avdpool.proj_grund.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.proj_grund.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.proj_grund.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.proj_grund.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.proj_grund.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.proj_grund.art IS 'Code zur Art der projektierten Grundstücke';
COMMENT ON COLUMN avdpool.proj_grund.nummer IS 'Nummer des projektierten Grundstückes';
COMMENT ON COLUMN avdpool.proj_grund.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.proj_grund.los IS 'Teilgebiet';

CREATE TABLE avdpool.proj_grund_pos (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int4 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	numori float4 NULL, -- Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	numhali int2 NULL, -- horizontale Ausrichtung der Nummer
	numvali int2 NULL, -- vertikale Ausrichtung der Nummer
	nummer varchar NULL, -- Grundbuchnummer des projektierten Grundstückes
	gem_bfs int2 NULL, -- BfS-Nummer der Gemeinde
	txt_rot float4 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	los int2 NULL, -- Teilgebiet
	CONSTRAINT proj_grund_pos_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX proj_grund_pos_idx ON avdpool.proj_grund_pos USING gist (wkb_geometry) WHERE (archive = 0);

-- Column comments

COMMENT ON COLUMN avdpool.proj_grund_pos.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.proj_grund_pos.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.proj_grund_pos.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.proj_grund_pos.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.proj_grund_pos.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.proj_grund_pos.numori IS 'Orientierung der Nummer im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.proj_grund_pos.numhali IS 'horizontale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.proj_grund_pos.numvali IS 'vertikale Ausrichtung der Nummer';
COMMENT ON COLUMN avdpool.proj_grund_pos.nummer IS 'Grundbuchnummer des projektierten Grundstückes';
COMMENT ON COLUMN avdpool.proj_grund_pos.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.proj_grund_pos.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.proj_grund_pos.los IS 'Teilgebiet';

CREATE TABLE avdpool.rohrltg (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	art int2 NULL, -- Transportmedium der Rohrleitung:¶0: Öl¶1: Gas¶2: weitere
	gem_bfs int2 NULL, -- BfS-Nummer der Gemeinde
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int4 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	los int2 NULL, -- Teilgebiet
	CONSTRAINT rohrltg_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX rohrltg_idx ON avdpool.rohrltg USING gist (wkb_geometry) WHERE (archive = 0);
COMMENT ON TABLE avdpool.rohrltg IS 'Rohrleitungen';

-- Column comments

COMMENT ON COLUMN avdpool.rohrltg.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.rohrltg.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.rohrltg.art IS 'Transportmedium der Rohrleitung:
0: Öl
1: Gas
2: weitere';
COMMENT ON COLUMN avdpool.rohrltg.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.rohrltg.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.rohrltg.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.rohrltg.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.rohrltg.los IS 'Teilgebiet';

CREATE TABLE avdpool.selbstrecht (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int4 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	flaechen float4 NULL, -- Fläche des Grundstückes [m2]
	nummer varchar NULL, -- Nummer des Grundstückes
	art int2 NULL, -- Typ des selbständig dauerenden Rechtes:¶1: Baurecht¶2: Quellenrecht
	gem_bfs int2 NULL, -- BfS-Nummer der Gemeinde
	los int2 NULL, -- Teilgebiet
	CONSTRAINT selbstrecht_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX selbstrecht_idx ON avdpool.selbstrecht USING gist (wkb_geometry) WHERE (archive = 0);
COMMENT ON TABLE avdpool.selbstrecht IS 'Selbstrecht';

-- Column comments

COMMENT ON COLUMN avdpool.selbstrecht.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.selbstrecht.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.selbstrecht.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.selbstrecht.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.selbstrecht.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.selbstrecht.flaechen IS 'Fläche des Grundstückes [m2]';
COMMENT ON COLUMN avdpool.selbstrecht.nummer IS 'Nummer des Grundstückes';
COMMENT ON COLUMN avdpool.selbstrecht.art IS 'Typ des selbständig dauerenden Rechtes:
1: Baurecht
2: Quellenrecht';
COMMENT ON COLUMN avdpool.selbstrecht.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.selbstrecht.los IS 'Teilgebiet';

CREATE TABLE avdpool.strnam (
	ogc_fid bigserial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	namori float8 NULL, -- Orientierung des Textes im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal
	namhali int4 NULL, -- horizontale Textausrichtung
	namvali int4 NULL, -- vertikale Textausrichtung
	strasse1 varchar NULL, -- Strassenname
	gem_bfs int4 NULL, -- BfS-Nummer der Gemeinde
	txt_rot float8 NULL, -- Umrechung von namori/numori in MapServer-Einheiten
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	los int2 NULL, -- Teilgebiet
	CONSTRAINT strnam_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=TRUE
);
CREATE INDEX strnam_idx ON avdpool.strnam USING gist (wkb_geometry) WHERE (archive = 0);
CREATE INDEX strname_gembfs_idx ON avdpool.strnam USING btree (gem_bfs);
COMMENT ON TABLE avdpool.strnam IS 'Strassennamen';

-- Column comments

COMMENT ON COLUMN avdpool.strnam.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.strnam.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.strnam.namori IS 'Orientierung des Textes im Uhrzeigersinn [gon]: <br> 0: vertikal <br> 100: horizontal';
COMMENT ON COLUMN avdpool.strnam.namhali IS 'horizontale Textausrichtung';
COMMENT ON COLUMN avdpool.strnam.namvali IS 'vertikale Textausrichtung';
COMMENT ON COLUMN avdpool.strnam.strasse1 IS 'Strassenname';
COMMENT ON COLUMN avdpool.strnam.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.strnam.txt_rot IS 'Umrechung von namori/numori in MapServer-Einheiten';
COMMENT ON COLUMN avdpool.strnam.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.strnam.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.strnam.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.strnam.los IS 'Teilgebiet';

CREATE TABLE avdpool.strstueck (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	ordnung int2 NULL, -- Ordnung des Strassenstückes
	"text" varchar NULL, -- Strassenname
	gem_bfs int2 NULL, -- BfS-Nummer der Gemeinde
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01 00:00:00'::timestamp without time zone, -- Datum der Archivierung des Objektes
	archive int2 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	los int2 NULL, -- Teilgebiet
	CONSTRAINT strstueck_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX strstueck_idx ON avdpool.strstueck USING gist (wkb_geometry);

-- Column comments

COMMENT ON COLUMN avdpool.strstueck.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.strstueck.ordnung IS 'Ordnung des Strassenstückes';
COMMENT ON COLUMN avdpool.strstueck."text" IS 'Strassenname';
COMMENT ON COLUMN avdpool.strstueck.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.strstueck.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.strstueck.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.strstueck.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.strstueck.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.strstueck.los IS 'Teilgebiet';

CREATE TABLE avdpool.toleranzstufe (
	ogc_fid serial NOT NULL, -- OGC Feature ID
	wkb_geometry geometry NULL, -- OGC WKB Geometrie
	new_date timestamp NULL DEFAULT now(), -- Datum des Imports des Objektes
	archive_date timestamp NULL DEFAULT '9999-01-01'::date, -- Datum der Archivierung des Objektes
	archive int4 NULL DEFAULT 0, -- 0: aktiv, 1: archiviert
	art int2 NULL, -- Art der Toleranzstufe:¶0: TS1¶1: TS2¶2: TS3¶3: TS4¶4: TS5
	gem_bfs int2 NULL, -- BfS-Nummer der Gemeinde
	los int2 NULL, -- Teilgebiet
	CONSTRAINT toleranzstufe_pkey PRIMARY KEY (ogc_fid)
);
CREATE INDEX toleranzstufe_idx ON avdpool.toleranzstufe USING gist (wkb_geometry) WHERE (archive = 0);
COMMENT ON TABLE avdpool.toleranzstufe IS 'Toleranzstufen';

-- Column comments

COMMENT ON COLUMN avdpool.toleranzstufe.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN avdpool.toleranzstufe.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN avdpool.toleranzstufe.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN avdpool.toleranzstufe.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN avdpool.toleranzstufe.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN avdpool.toleranzstufe.art IS 'Art der Toleranzstufe:
0: TS1
1: TS2
2: TS3
3: TS4
4: TS5';
COMMENT ON COLUMN avdpool.toleranzstufe.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN avdpool.toleranzstufe.los IS 'Teilgebiet';

CREATE TABLE avdpool.vaav93dm01 (
	id serial NOT NULL,
	dm01 int4 NULL,
	av93 int4 NULL,
	CONSTRAINT vaav93dm01_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE avdpool.vaav93dm01 IS 'Tabelle zum Mappen der Versicherungsarten Grenzpunkte von AV93 und DM01';

GRANT USAGE ON SCHEMA avdpool TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA avdpool TO admin;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA avdpool TO admin;
