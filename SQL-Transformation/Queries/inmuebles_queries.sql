1) Mostrar el precio promedio de las propiedades por Zona

SELECT zona,  ROUND(AVG(precio)) as precio_promedio from propiedades
where precio < 30000000 and zona is not null
group by zona 
order by precio_promedio desc;

2) Mostrar precio promedio de las 10 ubicaciones con mas publicaciones de venta

select ubicacion, round(avg(precio)) as precio_promedio_de_inmueble from propiedades
where ubicacion in (select ubicacion from
		(select ubicacion, count(ubicacion),
		rank() over(order by count(ubicacion) desc) as ranking
		from propiedades
		where precio < 30000000
		group by ubicacion) a
					where ranking <= 10) 
group by ubicacion
order by avg(precio) desc;


3) Mostrar 5 barrios mas caros de cada zona

-- G.B.A. Zona Norte
select ubicacion as barrios_zona_norte, precio_promedio ||' $' as valor_promedio from top_5_por_zona 
where zona = 'G.B.A. Zona Norte'
order by precio_promedio desc;

-- G.B.A. Zona Sur
select ubicacion as barrios_zona_sur, precio_promedio ||' $' as valor_promedio from top_5_por_zona 
where zona = 'G.B.A. Zona Sur'
order by precio_promedio desc;

-- G.B.A. Zona Oeste
select ubicacion as barrios_zona_oeste, precio_promedio ||' $' as valor_promedio from top_5_por_zona 
where zona = 'G.B.A. Zona Oeste'
order by precio_promedio desc;

-- Costa Atlantica
select ubicacion as barrios_costa_atlantica, precio_promedio ||' $' as valor_promedio from top_5_por_zona 
where zona = 'Costa Atlantica'
order by precio_promedio desc;

-- Interior Buenos Aires
select ubicacion as barrios_interior_bsas, precio_promedio ||' $' as valor_promedio from top_5_por_zona 
where zona = 'Interior Buenos Aires'
order by precio_promedio desc;

4) Media de area cubierta de las propiedades.

select distinct zona,
round(avg(area_cubierta_m2) over(partition by zona)) ||'m2' as area_cubierta
from propiedades 
where area_cubierta_m2 is not null and zona is not null


5) Comparacion de precio por antiguedad

select round(avg(precio)) as precio_promedio,
case
    WHEN antiguedad < 11 THEN 'Menos de 10 años'
    WHEN antiguedad < 21 THEN 'Entre 10 y 20 años'
    WHEN antiguedad < 31 THEN 'Entre 20 y 30 años'
    WHEN antiguedad < 41 THEN 'Entre 30 y 40 años'
    WHEN antiguedad < 51 THEN 'Entre 40 y 50 años'
    WHEN antiguedad >= 51 THEN 'Más de 50 años'
end as prom_antiguedad
from propiedades
where antiguedad is not null
group by prom_antiguedad
order by precio_promedio desc

6) Precio promedio de las propiedades por cantidad de ambientes

select
round(avg(precio) over(partition by ambientes)) as promedio_por_ambiente,
round(avg(precio) over(partition by dormitorios)) as promedio_por_dormitorios,
round(avg(precio) over(partition by baños)) as promedio_por_baños,
round(avg(precio) over(partition by cocheras)) as promedio_por_cocheras,
precio
from propiedades a

