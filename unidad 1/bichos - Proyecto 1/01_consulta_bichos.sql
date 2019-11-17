USE bichos
GO

--1) Bichos que cambian de tipo al evolucionar
SELECT e1.tipo1 AS 'Tipo anterior', e2.bicho, e2.id_especie, e2.tipo1 AS 'Tipo actual'
FROM especieEvolucion
	JOIN especie e1 ON e1.id_especie = especieEvolucion.id_especie_actual
	JOIN especie e2 ON e2.id_especie = especieEvolucion.id_especie_siguiente
WHERE e1.tipo1 <> e2.tipo1 OR e1.tipo2 <> e2.tipo2

--2) Seleccionar bichos que puedan sobrevivir al ataque físico más poderoso (Explosión)
SELECT especie.bicho, especie.defensa_normal_maxima
FROM especie
WHERE especie.defensa_normal_maxima > (SELECT max(ataque.potencia)
FROM ataque
WHERE ataque.categoria_ataque = 'f')

--3) Mostrar el ataque físico más poderoso posible considerando el ataque y quien realiza el ataque
SELECT especie.bicho, ataque.nombre_ataque, (especie.ataque_normal_maximo + ataque.potencia) AS 'Potencia'
FROM especie, ataque
WHERE (especie.ataque_normal_maximo + ataque.potencia) = (SELECT max(especie.ataque_normal_maximo + ataque.potencia)
FROM especie, ataque
WHERE ataque.categoria_ataque = 'f')

--4) Cantidad máxima de daño especial posible.
--Considere que el ataque empleado debe ser del mismo tipo que el atacante (considerando que el atacante puede tener dos tipos)
--Y cuan eficiente es contra el tipo del bicho atacado.
--Considerando, además, las estadísticas de los bichos y el ataque.
--Considerando el bicho atacante en su nivel máximo y el bicho atacado con estadísticas base

--El cálculo de daño se realiza con la siguiente formula:
--(((((2 x nivel atacante) / 5) + 2) * potencia de ataque * (poder del atacante / defensa del atacado)) / 50) + 2
SELECT e1.bicho AS 'Atacante', a1.nombre_ataque, e2.bicho AS 'Atacado', (((((42) * a1.potencia * e1.ataque_especial_maximo / e2.defensa_especial_base) / 50) + 2) * ea.eficacia) AS 'Daño inflingido'
FROM resitenciasTipo ea
	JOIN ataque a1 ON a1.id_tipo = ea.id_tipo_ataque
	JOIN especie e1 ON a1.id_tipo = e1.tipo1 OR a1.id_tipo = e1.tipo2
	JOIN especie e2 ON e2.tipo1 = ea.id_atacado OR e2.tipo2 = ea.id_atacado
WHERE a1.categoria_ataque = 'e' AND (((((42) * a1.potencia * e1.ataque_especial_maximo / e2.defensa_especial_base) / 50) + 2) * ea.eficacia) = (
SELECT max(((((42) * a1.potencia * e1.ataque_especial_maximo / e2.defensa_especial_base) / 50) + 2) * ea.eficacia)
	FROM resitenciasTipo ea
		JOIN ataque a1 ON a1.id_tipo = ea.id_tipo_ataque
		JOIN especie e1 ON a1.id_tipo = e1.tipo1 OR a1.id_tipo = e1.tipo2
		JOIN especie e2 ON e2.tipo1 = ea.id_atacado OR e2.tipo2 = ea.id_atacado
	WHERE
(e2.tipo1 = ea.id_atacado OR e2.tipo2 = ea.id_atacado) AND a1.id_tipo = ea.id_tipo_ataque AND
		(e1.tipo1 = a1.id_tipo OR e1.tipo2 = a1.id_tipo) AND ea.eficacia = 2 AND a1.categoria_ataque = 'e')

--5) Bicho más fuerte que ningún entrenador tiene
	SELECT especie.bicho
	FROM especie
	WHERE especie.ataque_especial_maximo = (SELECT max(especie.ataque_especial_maximo)
	FROM especie)
EXCEPT
	SELECT especie.bicho
	FROM especie INNER JOIN bicho ON bicho.id_especie = especie.id_especie
		INNER JOIN usuarioBicho ON usuarioBicho.id_bicho = bicho.id_bicho

--6) 