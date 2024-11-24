-- 1A
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
 and prior t.owner = t.owner;

-- 1B
select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;

-- 1C
create table myst_major_cities(fips_cntry varchar2(2), city_name varchar2(40), stgeom st_point);

-- 1D
insert into myst_major_cities(fips_cntry, city_name, stgeom)
select mc.fips_cntry, mc.city_name, st_point(mc.geom)
from ztpd.major_cities mc;

-- 2
insert into myst_major_cities values ('PL', 'Szczyrk', st_point(19.036107, 49.718655, 8307));

-- 3A
create table myst_country_boundaries(fips_cntry VARCHAR2(2), cntry_name varchar2(40), stgeom st_multipolygon);

-- 3B
insert into myst_country_boundaries(fips_cntry, cntry_name, stgeom)
select cb.fips_cntry, cb.cntry_name, st_multipolygon(cb.geom) from country_boundaries cb;

-- 3C
select mcb.stgeom.st_geometrytype() as typ_obiektu, count(mcb.stgeom) as ile
from myst_country_boundaries mcb group by mcb.stgeom.st_geometrytype();

-- 3D
select mcb.stgeom.st_issimple() from myst_country_boundaries mcb;

-- 4A
select mcb.cntry_name, count(*) from myst_country_boundaries mcb, myst_major_cities mmc where mmc.stgeom.st_within(mcb.stgeom) = 1
group by mcb.cntry_name;

-- 4B
select a.cntry_name, b.cntry_name from myst_country_boundaries a, myst_country_boundaries b where a.stgeom.st_touches(b.stgeom) = 1
and lower(b.cntry_name) = 'czech republic';

-- 4C
select distinct b.cntry_name, r.name
from myst_country_boundaries b, rivers r
where lower(b.cntry_name) = 'czech republic'
and st_linestring(r.geom).st_intersects(b.stgeom) = 1

-- 4D
select treat(a.stgeom.st_union(b.stgeom) as st_polygon).st_area() powierzchnia
from myst_country_boundaries a, myst_country_boundaries b
where a.cntry_name = 'Czech Republic'
and b.cntry_name = 'Slovakia';

-- 4E
select b.stgeom.st_geometrytype() as obiekt, treat(b.stgeom.st_difference(st_geometry(w.geom)) as st_polygon).st_geometrytype() as wegry_bez
from myst_country_boundaries b, water_bodies w
where b.cntry_name like 'Hungary' and w.name like 'Balaton';

-- 5A
explain plan for
select b.cntry_name a_name, c.city_name
from myst_country_boundaries b, myst_major_cities c
where sdo_within_distance(c.stgeom, b.stgeom,
 'distance=100 unit=km') = 'TRUE'
and b.cntry_name = 'Poland'

-- 5B
insert into user_sdo_geom_metadata (
    select 'myst_major_cities', 'stgeom', diminfo,srid
    from all_sdo_geom_metadata
    where table_name = 'major_cities'
);

-- 5C
create index myst_major_cities_idx
on myst_major_cities(stgeom)
indextype is mdsys.spatial_index_v2;

-- 5D
explain plan for
select b.cntry_name, count(*)
from myst_major_cities c, myst_country_boundaries b
where sdo_within_distance(c.stgeom, b.stgeom, 'distance=100 unit=km') = 'TRUE'
and b.cntry_name = 'Poland'
group by b.cntry_name;

select plan_table_output from table(dbms_xplan.display());