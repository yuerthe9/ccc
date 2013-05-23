create database yida;
use yida;
create table tb_open_meet_room(meetid varchar(32),userid varchar(50),createtime timestamp default current_timestamp,begintime datetime,endtime datetime,title varchar(500),comment varchar(5000));
create table tb_join_meet_room(meetid varchar(32),userid varchar(50),begintime timestamp default current_timestamp,endtime datetime);
insert into tb_open_meet_room(meetid,userid,begintime,endtime,title,comment) values('1','jyliang','2013-5-20 21:06','2013-5-20 22:06','关于netmeet','asdfasdfasdfasdfasdfdf哈哈哈');
insert into tb_join_meet_room(meetid,userid) values('1','fli');

