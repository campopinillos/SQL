--MySQL

SELECT CONVERT(L.Fecha_hora, getdate()) AS Fecha, U.Nombre, COUNT(L.Fecha) AS catidad_logins
FROM Logins_al_Sistema AS L LEFT JOIN Usuarios AS U
ON L.idUsuario = U.idUsuario
WHERE Fecha BETWEEN '20150101' AND '20151201'


SELECT CAST(L.Fecha_hora as Fecha), U.Nombre, COUNT(L.Fecha) AS catidad_logins
FROM Logins_al_Sistema AS L LEFT JOIN Usuarios AS U
ON L.idUsuario = U.idUsuario
WHERE L.Fecha BETWEEN '20150101' AND '20151201'
WHERE  BETWEEN '20121211' and '20121213'