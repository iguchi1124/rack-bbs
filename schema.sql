create database bbs;

create table bbs.comments (
  id int not null auto_increment,
  content varchar(255),
  primary key(id)
);
