insert

语法：
insert into 表(字段) values (值);

insert into goods(good_name) values ('相机');-- 上班常用

[注意]
如下你可以不用管，不用会或后面慢慢学都可以，上班就只需要懂一句话就行
1、如果你要对这个表都处理，就不用写(字段)部分 (用的不多，放弃都可以)

insert into goods values ('cc2','cc@cc.com',7788);
insert into goods values (8,'cc2','男','cc@cc.com',7788);


2、运维喜欢用的写法，我们在填补数据时常使用

insert into goods(good_name,eid)
select ename,empno
from emp
where deptno=10;

3、如果面试官问，如何批量插入大量数据
	datafactory



update

语法：
update 表
set 字段=值
where 条件


update goods 
set sex='女'
where id in (11,12,8);


[注意]
1、面试官特别喜欢问update
2、我的同事，我的学生因为没注意update，导致被辞退


delete

语法；
delete from 表 where 条件
delete from goods where id not in (11,12,8);


[注意]
1、delete也挺危险的，看清楚了做
2、还可以用清空（截断 truncate ）的操作
truncate table goods;

