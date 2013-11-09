create table vinz_user (
  id serial primary key,
  username varchar(80),
  first_name varchar(40),
  last_name varchar(80),
  password_hash bytea
);

create table vinz_group (
  id serial primary key,
  name varchar(100),
  comment text
);

create table vinz_group_member (
  id serial,
  vinz_group_id integer,
  vinz_user_id integer,
    foreign key (vinz_group_id) references vinz_group(id),
    foreign key (vinz_user_id) references vinz_user(id),
    unique (vinz_group_id, vinz_user_id)
);

create table vinz_access_control (
  id serial primary key,
  name varchar(100),
  resource varchar(100),
  global boolean default true,
  vinz_group_id integer,
  can_read boolean,
  can_create boolean,
  can_update boolean,
  can_delete boolean
);

create table vinz_access_rule (
  id serial primary key,
  name varchar(100),
  resource varchar(100),
  global boolean default true,
  vinz_group_id integer,
  domain text,
  can_read boolean,
  can_create boolean,
  can_update boolean,
  can_delete boolean
);
