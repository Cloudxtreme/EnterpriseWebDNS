create database DNS;


use DNS;

#create user 'www'@'localhost' identified by 'www';
CREATE user 'www'@'localhost' identified by 'www';
GRANT ALL PRIVILEGES ON DNS.* to www@'localhost'; 

create table TEAMS
(
 team		char(255) not null,
 teampassword	char(255) not null,
 displayname	char(255) not null
);

create table USERS
(
 username	varchar(20) not null,
 password	varchar(20) not null,
 fullname	varchar(40) not null,
 emailaddress	varchar(254) not null
);

create table MEMBERS
(
 username	varchar(20) not null,
 memberofteam	varchar(40) not null
);


create table TEAMMEMBERS
(
 username	varchar(20) not null,
 password	varchar(25) not null,
 fullname	varchar(40) not null,
 emailaddress	varchar(40) not null,
 memberof	varchar(40) not null
);

create table DOMAINNAME
(
 id		int  not null auto_increment,
 domainsuffix	char(255) not null,
 primary key (id)
);

create table FORWARDZONE
(
 hostname	varchar(255) not null,
 domainsuffix	varchar(255) not null,
 description	varchar(255) not null,
 username	varchar(20) not null,
 team		varchar(255) not null,
 modified	timestamp(14),
 recorddata	varchar(40) not null,
 recordclass	varchar(2) not null default 'IN',
 recordtype	varchar(5) not null default 'A',
 primary key (hostname)	
);

create table ZONEINFO
(
 domainsuffix	varchar(255) not null,
 primarymaster	varchar(20) not null,
 respperson	varchar(20) not null,
 serial		int not null,
 refresh	varchar(6) not null,
 retry		varchar(5) not null,
 expire		varchar(7) not null,
 minimttl	varchar(6) not null,
 ns1		varchar(20) not null,
 ns2		varchar(20) null,
 ns3		varchar(20) null,
 ns4		varchar(20) null,
 primary key (domainsuffix)
);

create table DELETEDFORWARDZONE
(
 hostname       varchar(255) not null,
 domainsuffix   varchar(255) not null,
 description    varchar(255) not null,
 username       varchar(20) not null,
 team           varchar(255) not null,
 modified       timestamp(14),
 recorddata     varchar(40) not null,
 recordclass    varchar(2) not null default 'IN',
 recordtype     varchar(5) not null default 'A',
 primary key (hostname)
);

