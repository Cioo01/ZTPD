-- 1.
create table dokumenty(
    id number(12) primary key,
    dokument clob
);
desc dokumenty;

-- 2.
declare
text varchar(20) := 'Oto tekst. ';
doc_text clob;
begin 
    for i in 1..10000
    loop
        doc_text := concat(doc_text, text);
    end loop;    
    
    insert into dokumenty
    values(1, doc_text);
end;

-- 3.
select * from dokumenty;
select upper(dokument) from dokumenty;
select length(dokument) from dokumenty;
select dbms_lob.length(dokument) from dokumenty;
select substr(dokument, 5, 1000) from dokumenty;

-- 4.
insert into dokumenty values (2, empty_clob());

-- 5.
insert into dokumenty values(3, null);

-- 6.
select * from dokumenty;
select upper(dokument) from dokumenty;
select length(dokument) from dokumenty;
select dbms_lob.getlength(dokument) from dokumenty;
select substr(dokument, 5, 1000) from dokumenty;
select dbms_lob.substr(dokument, 1000, 5) as doc_substr from dokumenty;

-- 7.
declare
    clb clob;
    txt_file bfile := bfilename('TPD_DIR', 'dokument.txt');
    dest_offset integer := 1;
    src_offset integer := 1;
    bfile_csid integer := 0;
    lang_context integer := 0;
    warning integer := null;
begin
    select dokument into clb where id = 2 for update;

    dbms_lob.fileopen(txt_file, dbms_lob.file_readonly);
    dbms_lob.loadclobfromfile(clb, txt_file, dbms_lob.lobmaxsize, dest_offset, src_offset, bfile_csid, lang_context, warning);
    dbms_lob.closefile(txt_file);

    commit;

    dbms_output.put_line(warning)

end;

-- 8.
update dokumenty
set dokument = to_clob(bfilename('TPD_DIR', 'dokument.txt'))
where id = 3;

-- 9.
select * from dokumenty;

-- 10.
select length(dokument) from dokumenty;

-- 11.
drop table dokumenty;

-- 12.
create or replace procedure clob_censor (
    text_to_replace varchar2,
    clb in out clob
)
is
    censored_text varchar2(256);
    position integer := 1;
begin
    censored_text := lpad('.', length(text_to_replace), '.');
    loop
        position := dbms_lob.instr(clob_object, text_to_replace, 1, 1);
        exit when position = 0;
        dbms_lob.write(clob_object, length(text_to_replace), position, censored_text);
    end loop;
end clob_censor;


-- 13.
create table biographies
as select * from ztpd.biographies;

select * from biographies;

-- 14.
declare
    clb clob;
begin
    select bio into clb from biographies where id = 1 for update;

    clob_censor(clb, 'Cimrman');
    
    commit;
end;

-- 15.
drop table biographies;