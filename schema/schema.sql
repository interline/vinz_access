drop table if exists vinz_access_group_member;
drop table if exists vinz_access_group;
drop table if exists vinz_access_user;
drop table if exists vinz_access_right;
drop table if exists vinz_access_filter;

create table vinz_access_user (
  id serial primary key,
  username varchar(80) not null,
  first_name varchar(40),
  last_name varchar(80),
  password_hash bytea,
    unique (username)
);

create table vinz_access_group (
  id serial primary key,
  name varchar(100) not null,
  comment text,
    unique (name)
);

create table vinz_access_group_member (
  id serial,
  vinz_access_group_id integer,
  vinz_access_user_id integer,
    foreign key (vinz_access_group_id) references vinz_access_group(id),
    foreign key (vinz_access_user_id) references vinz_access_user(id),
    unique (vinz_access_group_id, vinz_access_user_id)
);

create table vinz_access_right (
  id serial primary key,
  name varchar(100) not null,
  resource varchar(100) not null,
  global boolean default true,
  vinz_access_group_id integer,
  can_read boolean,
  can_create boolean,
  can_update boolean,
  can_delete boolean,
    unique (name)
);

create table vinz_access_filter (
  id serial primary key,
  name varchar(100) not null,
  resource varchar(100) not null,
  global boolean default true,
  vinz_access_group_id integer,
  domain text,
  can_read boolean,
  can_create boolean,
  can_update boolean,
  can_delete boolean,
    unique(name)
);
