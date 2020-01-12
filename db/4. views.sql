USE whatnotbench;

CREATE OR REPLACE VIEW v_cpus_fullname AS
    SELECT CONCAT(IF(mobile_prefix, 'Mobile ', ''),
                  IF(manufacturer_prefix,
                     CONCAT((SELECT name
                               FROM chip_manufacturers
                              WHERE ID = chip_manufacturer_id), ' '),
                     ''),
                  name) fullname,
           c.*
      FROM cpus c;



CREATE OR REPLACE VIEW cpu_grades AS
    SELECT id, NTILE(4) OVER (ORDER BY rating DESC) grade
      FROM cpus_fullname;

CREATE OR REPLACE VIEW v_cpus_highend AS
    SELECT cf.* FROM cpus_fullname cf JOIN cpu_grades cg ON cf.id = cg.id AND cg.grade = 1;

CREATE OR REPLACE VIEW v_cpus_mid_range AS
    SELECT cf.* FROM cpus_fullname cf JOIN cpu_grades cg ON cf.id = cg.id AND cg.grade = 2;

CREATE OR REPLACE VIEW v_cpus_midlow_range AS
    SELECT cf.* FROM cpus_fullname cf JOIN cpu_grades cg ON cf.id = cg.id AND cg.grade = 3;

CREATE OR REPLACE VIEW v_cpus_low_end AS
    SELECT cf.* FROM cpus_fullname cf JOIN cpu_grades cg ON cf.id = cg.id AND cg.grade = 4;




CREATE OR REPLACE VIEW videocard_grades AS
    SELECT id, NTILE(4) OVER (ORDER BY rating DESC) grade
      FROM videocards;
     
CREATE OR REPLACE VIEW v_videocards_highend AS
    SELECT V.* FROM videocards v JOIN videocard_grades vg ON v.id = vg.id AND vg.grade = 1;

CREATE OR REPLACE VIEW v_videocards_mid_range AS
    SELECT V.* FROM videocards v JOIN videocard_grades vg ON v.id = vg.id AND vg.grade = 2;

CREATE OR REPLACE VIEW v_videocards_midlow_range AS
    SELECT V.* FROM videocards v JOIN videocard_grades vg ON v.id = vg.id AND vg.grade = 3;

CREATE OR REPLACE VIEW v_videocards_low_end AS
    SELECT V.* FROM videocards v JOIN videocard_grades vg ON v.id = vg.id AND vg.grade = 4;
