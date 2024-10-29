-- A

create table figury(id number(1) primary key, ksztalt mdsys.sdo_geometry);


-- B
insert into figury values
(1,
 mdsys.sdo_geometry(2003, null, null, mdsys.sdo_elem_info_array(1, 1003, 4), mdsys.sdo_ordinate_array(5,7, 7,5, 3,5)
));

insert into figury values(
2, mdsys.sdo_geometry(2003, null, null, mdsys.sdo_elem_info_array(1, 1003, 3), mdsys.sdo_ordinate_array(1,1, 5,5)));

insert into figury values(3, mdsys.sdo_geometry(2002, null, null, mdsys.sdo_elem_info_array(1,4,2, 1,2,1, 5,2,2),
mdsys.sdo_ordinate_array(3,2, 6,2, 7,3, 8,2, 7,1)));


-- C
insert into figury values(
4, mdsys.sdo_geometry(2003, null, null, mdsys.sdo_elem_info_array(1, 1003, 3), mdsys.sdo_ordinate_array(1,1)));

-- D
select id, sdo_geom.validate_geometry_with_context(ksztalt, 0.01) as val
from figury;

-- E
delete from figury
where sdo_geom.validate_geometry_with_context(ksztalt, 0.01) <> 'TRUE';

select * from figury;

commit;