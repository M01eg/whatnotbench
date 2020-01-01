DROP DATABASE IF EXISTS whatnotbench;
CREATE DATABASE whatnotbench;
USE whatnotbench;

DROP TABLE IF EXISTS chip_manufacturers;
CREATE TABLE chip_manufacturers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(10)
);

DROP TABLE IF EXISTS cpu_classes;
CREATE TABLE cpu_classes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(10)
);

DROP TABLE IF EXISTS videocard_classes;
CREATE TABLE videocard_classes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20)
);

DROP TABLE IF EXISTS cpu_sockets;
CREATE TABLE cpu_sockets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20)
);

DROP TABLE IF EXISTS operating_systems;
CREATE TABLE operating_systems (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120)
);

DROP TABLE IF EXISTS cpus;
CREATE TABLE cpus (
    id SERIAL PRIMARY KEY,
    chip_manufacturer_id BIGINT UNSIGNED,
    mobile_prefix BOOL,
    manufacturer_prefix BOOL,
    name VARCHAR(40),
    rating INT,
    single_thread_rating INT,
    samples INT,
    class_id  BIGINT UNSIGNED,
    socket_id BIGINT UNSIGNED,
    frequency DECIMAL(3,1),
    physical_cores INT,
    hyper_threading BOOL,
    amd_shared_fpus BOOL,
    tdp DECIMAL(5,2),
    first_benchmarked VARCHAR(7),

    FOREIGN KEY (chip_manufacturer_id) REFERENCES chip_manufacturers(id),
    FOREIGN KEY (class_id)  REFERENCES cpu_classes(id),
    FOREIGN KEY (socket_id) REFERENCES cpu_sockets(id)
);

DROP TABLE IF EXISTS videocards;
CREATE TABLE videocards (
    id SERIAL PRIMARY KEY,
    chip_manufacturer_id BIGINT UNSIGNED,
    name VARCHAR(50),
    rating INT,
    samples INT,
    class_id BIGINT UNSIGNED,
    d3d_feature_lvl VARCHAR(20),
    ogl_feature_lvl DECIMAL(4,2),
    max_tdp INT,
    first_benchmarked DATE,

    FOREIGN KEY (chip_manufacturer_id) REFERENCES chip_manufacturers(id),
    FOREIGN KEY (class_id)  REFERENCES videocard_classes(id)
);

DROP TABLE IF EXISTS baselines;
CREATE TABLE baselines (
    id SERIAL PRIMARY KEY,
    performancetest_version VARCHAR(10),
    operating_system_id BIGINT UNSIGNED,
    submission_date DATE,

    passmark_rating INT,
    cpu_mark INT,
    2d_graphics_mark INT,
    3d_graphics_mark INT,
    memory_mark INT,
    disk_mark INT,

    cpu_id BIGINT UNSIGNED,
    cpu_measured_speed DECIMAL(6,2),
    cpu_measured_speed_ghz_or_mhz ENUM('GHz', 'MHz'),
    cpu_measured_speed_turbo VARCHAR(100), -- turbospeed is always in GHz
    motherboard  VARCHAR(100),
    memory_size  INT,
    memory_size_gb_or_mb ENUM('GB', 'MB'),
    memory_model VARCHAR(100),
    videocard_id BIGINT UNSIGNED,
    hdd_size     INT,
    hdd_size_tb_or_gb ENUM('TB', 'GB'),
    hdd_model    VARCHAR(100),

    FOREIGN KEY (operating_system_id) REFERENCES operating_systems(id),
    FOREIGN KEY (cpu_id) REFERENCES cpus(id),
    FOREIGN KEY (videocard_id) REFERENCES videocards(id)
);
