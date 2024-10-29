-- 1. 
create type samochod as object(
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10,2)
)

create table samochody of samochod


INSERT INTO samochody VALUES (
    samochod('FIAT', 'BRAVA', 60000, TO_DATE('30-11-1999', 'DD-MM-YYYY'), 25000)
);

INSERT INTO samochody VALUES (
    samochod('FORD', 'MONDEO', 80000, TO_DATE('10-05-1997', 'DD-MM-YYYY'), 45000)
);

INSERT INTO samochody VALUES (
    samochod('MAZDA', '323', 12000, TO_DATE('22-09-2000', 'DD-MM-YYYY'), 52000)
);


-- 2. 
create type wlasciciel as object(
    imie varchar2(100),
    nazwisko varchar2(100),
    auto samochod
)

create table wlasciciele of wlasciciel;

INSERT INTO wlasciciele VALUES (
    wlasciciel('JAN', 'KOWALSKI', samochod('FIAT', 'SEICENTO', 30000, TO_DATE('02-12-0010', 'DD-MM-YYYY'), 19500))
);

INSERT INTO wlasciciele VALUES (
    wlasciciel('ADAM', 'NOWAK', samochod('OPEL', 'ASTRA', 34000, TO_DATE('01-06-0009', 'DD-MM-YYYY'), 33700))
);

-- 3. 

alter type samochod replace as object (
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10,2),
    member function wartosc return number
);

create or replace type body samochod as
    member function wartosc return number is
    begin
        return cena * power(0.9, extract(year from current_date) - extract(year from data_produkcji));
    end wartosc;
end;

select s.marka, s.cena, s.wartosc() from samochody s;


-- 4. 

create or replace type body samochod as
    member function wartosc return number is
    begin
        return cena * power(0.9, extract(year from current_date) - extract(year from data_produkcji));
    end wartosc;
    
    map member function odwzoruj return number is
    begin
        return extract(year from current_date) - extract(year from data_produkcji) + (kilometry/10000);
    end odwzoruj;
end;


-- 5.

create type wlasciciel2 as object(
    imie varchar2(100),
    nazwisko varchar2(100)
)

create table wlasciciele2 of wlasciciel2;


INSERT INTO wlasciciele2 VALUES (
    new wlasciciel2('JAN', 'KOWALSKI')
);

INSERT INTO wlasciciele2 VALUES (
    new wlasciciel2('ADAM', 'NOWAK')
);


create type samochod2 as object(
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10,2),
    wlasciciel ref wlasciciel2
)

create table samochody2 of samochod2


INSERT INTO samochody2 VALUES (
    samochod2('FIAT', 'BRAVA', 60000, TO_DATE('30-11-1999', 'DD-MM-YYYY'), 25000, null)
);

INSERT INTO samochody2 VALUES (
    samochod2('FORD', 'MONDEO', 80000, TO_DATE('10-05-1997', 'DD-MM-YYYY'), 45000, null)
);

INSERT INTO samochody2 VALUES (
    samochod2('MAZDA', '323', 12000, TO_DATE('22-09-2000', 'DD-MM-YYYY'), 52000, null)
);

update samochody2 s
set s.wlasciciel = (select ref(w) from wlasciciele2 w where w.imie = 'ADAM');

select * from samochody2;

-- 6. 

DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 moje_przedmioty(9) := 9;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

-- 7.

DECLARE
 TYPE tytuly_ksiazek IS VARRAY(3) OF VARCHAR2(20);
 moje_ksiazki tytuly_ksiazek := tytuly_ksiazek('');
BEGIN
 moje_ksiazki(1) := 'What?';
 moje_ksiazki.EXTEND(2);
 FOR i IN 2..3 LOOP
 moje_ksiazki(i) := 'Tytul_' || i;
 END LOOP;
 FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
 END LOOP;
 moje_ksiazki.TRIM(1);
 FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
 moje_ksiazki.EXTEND();
 moje_ksiazki(2) := 'aaaa';
 DBMS_OUTPUT.PUT_LINE(moje_ksiazki(2));
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
 moje_ksiazki.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
END;

-- 8. 
DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

-- 9.
Declare
 Type t_miesiace is table of varchar2(12);
 miesiace t_miesiace := t_miesiace();
begin 
 miesiace.extend(2);
 miesiace(1) := 'Styczen';
 miesiace(2) := 'Luty';
 miesiace.extend(12);
for i in 3..12 loop
 miesiace(i) := 'Miesiac_' || i;
end loop;
miesiace.trim(2);
for i in miesiace.first()..miesiace.last() loop
 DBMS_OUTPUT.PUT_LINE(miesiace(i));
end loop;
miesiace.delete(3,5);
DBMS_OUTPUT.PUT_LINE('Limit: ' || miesiace.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || miesiace.COUNT());
for i in miesiace.first()..miesiace.last() loop
 if miesiace.exists(i) then
   DBMS_OUTPUT.PUT_LINE(miesiace(i));
 end if;
end loop;
miesiace(3) := 'Marzec';
miesiace(5) := 'Maj';
miesiace(8) := 'Sierpien';
miesiace(12) := 'Grudzien';
for i in miesiace.first()..miesiace.last() loop
 if miesiace.exists(i) then
   DBMS_OUTPUT.PUT_LINE(miesiace(i));
 end if;
end loop;
DBMS_OUTPUT.PUT_LINE('Limit: ' || miesiace.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || miesiace.COUNT());
end;

-- 10. 
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';


-- 11.
create type koszyk_produktow as table of varchar2(20);

create type zakup as object (
    firma varchar2(30),
    produkty koszyk_produktow
);
/

create table zakupy of zakup
nested table produkty store as tab_produktow;
/
insert into zakupy values(
    zakup('dell', koszyk_produktow('gtx1060', 'rtx2070', 'ryzen 7 5800x3d'))
);
insert into zakupy values(
    zakup('hp', koszyk_produktow('intel 13900k', 'gtx980', 'corsair abcd'))
);

select * from zakupy;

delete from zakupy z 
where firma in (select firma from zakupy z, table(z.produkty) p where p.column_value = 'intel 13900k');

select * from zakupy;

-- 12.

CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;

-- 13.

CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
DECLARE
 KrolLew lew := lew('LEW',4);
 InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

-- 14.

DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

-- 15.
CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;