USE whatnotbench;

SELECT cm.name, SUM(samples), CONCAT((SUM(samples) / (SELECT SUM(samples) FROM cpus)) * 100, '%')
  FROM cpus c, chip_manufacturers cm
 WHERE c.chip_manufacturer_id = cm.id
 GROUP BY cm.name;


SELECT c.hyper_threading, SUM(c.samples)
  FROM cpus c
  JOIN chip_manufacturers cm ON c.chip_manufacturer_id = cm.id
 WHERE cm.name = 'Intel'
 GROUP BY c.hyper_threading;


SELECT c.physical_cores, SUM(c.samples)
  FROM cpus c
  JOIN chip_manufacturers cm ON c.chip_manufacturer_id = cm.id
 WHERE cm.name = 'Intel'
   AND c.hyper_threading = 1
 GROUP BY LEAST(c.physical_cores, 6)
 ORDER BY SUM(c.samples) DESC;


WITH total AS (SELECT SUM(samples) n FROM videocards)
SELECT CONCAT('DirectX ', CONVERT(d3d_feature_lvl, UNSIGNED)) dx_support,
       CONCAT( ROUND( SUM(SUM(samples)) OVER (
                  ORDER BY CONVERT(d3d_feature_lvl, UNSIGNED) DESC
              ) / (SELECT n FROM total) * 100), '%') n
  FROM VIDEOCARDS
 WHERE d3d_feature_lvl != '80:08:04' -- ОШИБКА В БД/НА САЙТЕ
 GROUP BY dx_support
UNION ALL
SELECT '+', ''
UNION ALL
SELECT 'Unknown', CONCAT(ROUND(amount / (SELECT n FROM total) * 100), '%')
  FROM (
    SELECT SUM(samples) amount
      FROM VIDEOCARDS
     WHERE d3d_feature_lvl IS NULL
  ) t;
