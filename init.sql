create database if not exists employees;
USE employees;
drop table if exists users;
create table users
(
    id INT AUTO_INCREMENT PRIMARY KEY, 
    first_name VARCHAR(200) not null, 
    last_name VARCHAR(200) not null, 
    addr VARCHAR(200) not null
);

insert into users (first_name, last_name, addr) values('fana', 'lana', '123 park st');
insert into users (first_name, last_name, addr) values('Jane', 'Dot', '123 line st');
insert into users (first_name, last_name, addr) values('Pixel', 'Matrice', '123 main st');
insert into users (first_name, last_name, addr) values('Dottie', 'Brown', '123 7th ave');
