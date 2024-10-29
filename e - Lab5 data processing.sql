-- 1A
insert into user_sdo_geom_metadata
values(
        'figury',
        'ksztalt',
        mdsys.sdo_dim_array(
            mdsys.sdo_dim_element('x', 0, 10, 0.01),
            mdsys.sdo_dim_element('y', 0, 10, 0.01)
        ),
        null
    );
    
-- 1B
select sdo_tune.estimate_rtree_index_size(3000000, 8192, 10, 2, 0)
from dual;

-- 1C
create index figury_ksztalt_idx on figury(ksztalt) indextype is mdsys.spatial_index_v2;

-- 1D
select id
from figury
where sdo_filter(
        ksztalt,
        sdo_geometry(
            2001,
            null,
            sdo_point_type(3, 3, null),
            null,
            null
        )
    ) = 'true'; -- fałsz, bierze pod uwagę tylko pierwszą część zapytania - przybliżenie indeksem

-- 1E
select id
from figury
where sdo_relate(
        ksztalt,
        sdo_geometry(
            2001,
            null,
            sdo_point_type(3, 3, null),
            null,
            null
        ),
        'mask=anyinteract'
    ) = 'true'; -- prawda, obie części zapytania są sprawdzane

-- 2A
select city_name,
    sdo_nn_distance(1) as distance
from major_cities
where sdo_nn(
        geom,
        (
            select geom
            from major_cities
            where lower(city_name) like 'warsaw'
        ),
        'sdo_num_res=10 unit=km',
        1
    ) = 'true'
    and lower(city_name) not like 'warsaw';

-- 2B
select city_name,
    sdo_within_distance(
        geom,
        (
            select geom
            from major_cities
            where lower(city_name) like 'warsaw'
        ),
        'distance=100 unit=km'
    ) = 'TRUE';

-- 2C
select a.cntry_name,
    b.city_name
from country_boundaries a,
    major_cities b
where sdo_relate(b.geom, a.geom, 'mask=INSIDE') = 'TRUE'
    and a.cntry_name = 'Slovakia';

-- 2D
select cb2.cntry_name as panstwo,
    sdo_geom.sdo_distance(cb1.geom, cb2.geom, 1, 'unit=km') odl
from country_boundaries cb1,
    country_boundaries cb2
where sdo_relate(cb1.geom, cb2.geom, 'mask=ANYINTERACT') <> 'TRUE'
    and cb1.cntry_name like 'Poland';

-- 3A
select cb1.cntry_name,
    sdo_geom.sdo_length(
        sdo_geom.sdo_intersection(cb1.geom, cb2.geom, 1),
        1,
        'unit=km'
    ) odleglosc
from country_boundaries cb1,
    country_boundaries cb2
where sdo_relate(cb1.geom, cb2.geom, 'mask=TOUCH') = 'TRUE'
    and cb2.cntry_name = 'Poland';

-- 3B
select cb.cntry_name
from country_boundaries cb
where sdo_geom.sdo_area(cb.geom) = (
        select max(sdo_geom.sdo_area(geom))
        from country_boundaries
    );

-- 3C
select sdo_geom.sdo_area(
        sdo_geom.sdo_mbr(
            sdo_geom.sdo_union(a.geom, b.geom, 0.01)
        ),
        1,
        'unit=SQ_KM'
    ) sq_km
from major_cities a,
    major_cities b
where a.city_name = 'Warsaw'
    and b.city_name = 'Lodz';

-- 3D
select sdo_geom.sdo_union(a.geom, b.geom, 0.01).sdo_gtype geom_type
from major_cities a,
    country_boundaries b
where a.city_name = 'Prague'
    and b.cntry_name = 'Poland';

-- 3E
with distanceCTE as (
    select a.city_name,
        b.cntry_name,
        sdo_geom.sdo_distance(
            sdo_geom.sdo_centroid(b.geom, 1),
            a.geom,
            1,
            'unit=km'
        ) as distance
    from major_cities a,
        country_boundaries b
)
select city_name,
    cntry_name
from distanceCTE
where distance = (
        select min(distance)
        from distanceCTE
    );

-- 3F
with lengthCTE as (
    select a.name,
        sdo_geom.sdo_length(
            sdo_geom.sdo_intersection(b.geom, a.geom, 1),
            1,
            'unit=km'
        ) as len
    from rivers a,
        country_boundaries b
    where b.cntry_name = 'Poland'
        and sdo_relate(
            a.geom,
            b.geom,
            'mask=ANYINTERACT'
        ) = 'TRUE'
)
select c.name,
    sum(c.len) as sum_len
from lengthCTE c
group by c.name;