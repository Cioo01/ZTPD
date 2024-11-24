-- 1
create table moje_cytaty as
select * from ztpd.cytaty;

desc moje_cytaty;

-- 2
select * from moje_cytaty where lower(tekst) like '%optymista%' and lower(tekst) like '%pesymista%'; 

-- 3
create index idx_tekst on moje_cytaty(tekst) indextype is ctxsys.context;

-- 4
select * from moje_cytaty where contains(tekst, 'pesymista and optymista') > 0;

-- 5
select * from moje_cytaty where contains(tekst, 'pesymista not optymista') > 0;

-- 6
select * from moje_cytaty where contains(tekst, 'near((pesymista, optymista), 3)') > 0;

-- 7
select * from moje_cytaty where contains(tekst, 'near((pesymista, optymista), 10)') > 0;

-- 8
select * from moje_cytaty where contains(tekst, 'życi%')>0;

-- 9
select autor, tekst, score(1) from moje_cytaty where contains(tekst, 'życi%', 1)>0;

-- 10
select autor, tekst, score(1) from moje_cytaty where contains(tekst, 'życi%', 1)>0 order by score(1) desc fetch first 1 row only;

-- 11
select * from moje_cytaty where contains(tekst, 'fuzzy(probelm)')>0;

-- 12
insert into moje_cytaty values(39, 'Bertrand Russell', 'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.');
commit;

-- 13
select * from moje_cytaty where contains(tekst, 'głupcy') > 0;

-- 14
select token_text from dr$idx_tekst$i
where lower(token_text) = 'głupcy';

-- 15
alter index idx_tekst rebuild;

-- 16
select token_text from dr$idx_tekst$i
where lower(token_text) = 'głupcy';
select * from moje_cytaty where contains(tekst, 'głupcy') > 0;

-- 17
drop index idx_tekst;
drop table moje_cytaty;


-- ======================================================part 2===================================================================


-- 2.1
create table my_quotes as
select * from ztpd.quotes;

-- 2.2
create index idx_quotes on my_quotes(text) indextype is ctxsys.context;

-- 2.3
select * from my_quotes where contains(text, 'work') > 0;
select * from my_quotes where contains(text, '$work') > 0;
select * from my_quotes where contains(text, 'working') > 0;
select * from my_quotes where contains(text, '$working') > 0;

-- 2.4
select * from my_quotes where contains(text, 'it') > 0;

-- 2.5
select * from ctx_stoplists;

-- 2.6
select * from ctx_stopwords;

-- 2.7
drop index idx_quotes;

create index idx_quotes on my_quotes(text) indextype is ctxsys.context parameters('stoplist ctxsys.empty_stoplist');

-- 2.8
select * from my_quotes where contains(text, 'it') > 0;

-- 2.9
select * from my_quotes where contains(text, 'fool and humans') > 0;

-- 2.10
select * from my_quotes where contains(text, 'fool and computer') > 0;

-- 2.11
select * from my_quotes where contains(text, '(fool and humans) within sentence') > 0;

-- 2.12
drop index idx_quotes;

-- 2.13
begin
 ctx_ddl.create_section_group('nullgroup', 'null_section_group');
 ctx_ddl.add_special_section('nullgroup', 'sentence');
 ctx_ddl.add_special_section('nullgroup', 'paragraph');
end;

-- 2.14
create index idx_quotes on my_quotes(text) indextype is ctxsys.context parameters('stoplist ctxsys.empty_stoplist section group nullgroup');

-- 2.15
select * from my_quotes where contains(text, '(fool and computer) within sentence') > 0;

-- 2.16
select * from my_quotes where contains(text, 'humans') > 0;

-- 2.17
drop index idx_quotes;

begin
    ctx_ddl.create_preference('my_lexer', 'basic_lexer');
    ctx_ddl.set_attribute('my_lexer', 'printjoins', '-');
    ctx_ddl.set_attribute ('my_lexer', 'index_text', 'yes');
end;

create index idx_quotes on my_quotes(text) indextype is ctxsys.context parameters('stoplist ctxsys.empty_stoplist section group nullgroup lexer my_lexer');

-- 2.18
select * from my_quotes where contains(text, 'humans') > 0;

-- 2.19
select * from my_quotes where contains(text, 'non\-humans') > 0;

-- 2.20
begin
ctx_ddl.drop_section_group('nullgroup');
ctx_ddl.drop_preference('my_lexer');
end;

drop table my_quotes;