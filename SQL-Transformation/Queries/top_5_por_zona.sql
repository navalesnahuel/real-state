CREATE TABLE top_5_por_zona AS (
    with precios_x_zona as (
        select ubicacion, zona, round(avg(precio)) as precio_promedio,
        ROW_NUMBER() OVER (PARTITION BY zona ORDER BY AVG(precio) DESC) as num_fila
        from propiedades
        where precio is not null and precio < 30000000 and ubicacion is not null
        group by ubicacion, zona
        order by avg(precio) desc
    ),
    average as (
        select ubicacion, zona, round(avg(precio)) as precio_promedio 
        from propiedades p
        where exists (
            select ubicacion, zona from precios_x_zona pxz 
            WHERE p.ubicacion = pxz.ubicacion
            and num_fila <= 5
        )
        group by ubicacion, zona
        order by avg(precio) desc
    )
    select * from average
);