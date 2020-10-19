-- 做测试，最最常见的查询，所以你必须学好查询

简单查询
完整语法：
select [distinct] field_name
from table_name
[where condition]
[group by field_name]
[having condition]
[order by ....]


1、select
	1、查询一个字段
		select ename from emp;
	2、查询多个字段
		select ename,sal,comm,job from emp;
	3、查询所有字段
		select * from emp;
	4、运算&别名
		运算：
		select sal*12 from emp;
		【注意】：运算时有一个天坑
			select sal,comm,sal+comm from emp;-- 在做运算时，由于运算的列有空值，运算结果就会是空值
			select sal,comm,sal+ifnull(comm,0) from emp;-- 采用ifnull函数来解决运算为空
		
		别名：alias--->as ，取名时：见名知意  目的：让用户一下子就能看懂这个字段是什么意思
			select sal,comm,sal+ifnull(comm,0) as 月薪,(sal+ifnull(comm,0))*12 as 年薪 from emp;
			-- 如果你按照上面这样写，你的同事会 :)
			select sal,comm,sal+ifnull(comm,0) monthly_pay,(sal+ifnull(comm,0))*12 year_sal from emp;
		5、拼接		
			select concat(empno,'_',ename) from emp;
		6、去除重复
			select distinct job from emp;
			【注意】
				select distinct job,ename from emp; -- job和ename是联合起来看然后去重复

2、from
		1、别名:写字段方便，不想记忆且直接写还容易错
			select e.ename from emp e;
		
3、where（重点）
		1、数字
			1、> < = >= <= <>
				select ename from emp where sal>2000;
			2、between...and... [x,y]
				select * from emp where sal BETWEEN 2000 and 3000;

		2、字符串
			1、= (完全匹配)
				select * from emp where job='SALESMAN';
			2、like (模糊匹配)
				%:匹配0个或多个
				_:匹配1个
				select * from emp where ename like '%A%';
					如果幺蛾子用法可以忘记：（不常见）
						A% __A___ __A___% %__A___ %__A___%

			3、空值 is null  null和0是2个概念
					select * from emp where comm is null;

			4、取一堆值(某字段中的一堆) in  
					select * from emp where job in ('MANAGER','CLERK','ANALYST');

			5、取反 not
					in									not in
					is null							is not null
					like								not like
					BETWEEN...AND...		not BETWEEN...AND...

			select ename from emp where comm is not null;

			6、and&or  （工作中，几乎全部是and） 
				and是交集,随着and的增加，数据会越来越少
				and是并集,随着or的增加，数据会越来越多
			select * from emp where sal>2000;
			select * from emp where deptno in (10,30);


			select * from emp where sal>2000 and deptno in (10,30);
			select * from emp where sal>2000 and deptno in (10,30) and job='MANAGER';

			select * from emp where sal>3000 or sal<2000 or ename='FORD';

			最糟心的一种
				and的优先级高于or
				当我们看到and和or混编时，建议采用括号括一下更容易理解
			select ....
			from ....
			where (....and ...)
			or ....
			or (....and ....)
			or (....and ...and ...and ...)
			or ....
			

		题目：
		1. 选择部门 30 中的雇员
		select ename from emp where deptno=30;

		2. 列出所有办事员的姓名、编号和部门
		select ename,empno,deptno from emp where job='CLERK';


		3. 找出佣金高于薪金的雇员
		select ename from emp where comm>sal;


		4. 找出佣金高于薪金 60%的雇员
		select ename from emp where comm>sal*0.6;

		5. 找出部门 10 中所有经理和部门 20 中的所有办事员的详细资料
		select * from emp  where (deptno=10 and job='MANAGER') or (deptno=20 and job='CLERK');


		6. 找出部门 10 中所有经理、部门 20 中所有办事员，既不是经理又不是办事员但其薪金>=2000 的所有雇员的详细资料
		select * from emp  
		where (deptno=10 and job='MANAGER') 
		or (deptno=20 and job='CLERK') 
		or (job not in ('MANAGER','CLERK') and sal>=2000);


		7. 找出收取佣金的雇员的不同工作

		select distinct job from emp where comm is not null;

		8. 找出不收取佣金或收取的佣金低于 100 的雇员

		select ename from emp where comm is null or comm<100;

4、分组（难点，请认真理解）
	1、分组函数
		avg、sum、max、min、count
		
		select avg(sal) from emp;
		select avg(ename) from emp;

		【注意】可以做运算,但不能带表达式
		select avg(sal+ifnull(comm,0)) from emp;
		select avg(sal>1500) from emp;-- 错误
		select avg(sal) from emp where sal>1500;

		select max(hiredate) from emp;
		select max(ename) from emp;

		【注意】count不统计null值,一般用*来统计整表数据
		select count(comm) from emp;
		select count(ename) from emp;

		select count(*) from emp;
		
		【非常注意】分组函数不能直接作用在where子句中，得展开写
		select * from emp where sal>avg(sal);
		select * from emp where sal>(select avg(sal) from emp);
	
	2、混合（工作最最常见的）
		老蔡的经验：当我写完select后，我就马上看是否有组函数，如果有，想都不要想，马上group by
		分组规则为：除开组函数外的其他字段全部参与分组
		select job,min(sal) from emp; -- 错误原因是因为不能凑成一一对应的关系
		select job,min(sal) from emp group by job;
		select job,min(sal),ename from emp group by job; -- 错误
		select job,min(sal),ename from emp group by job,ename; -- 正确的，说的是job相同，ename也相同来分组
		select min(sal),ename from emp group by job,ename;-- 隐藏了啊
		select min(sal) from emp group by job,ename;-- 隐藏了啊
		select ename from emp group by job,ename;-- 隐藏了啊
		select sal from emp group by job,ename;-- 错误
		select sal from emp group by job,ename,sal;-- 正确
		select job,min(sal),max(hiredate),count(*) from emp group by job; -- 正确

		select deptno,sal,max(comm),count(hiredate),mgr
		from emp
		group by deptno,sal,mgr;

5、having（分组后过滤）
		select job,min(sal) from emp group by job having min(sal)>=3000;

		【注意】不要在having中使用别名,仅使用select中的字段去having,但不限制组函数（隐藏了啊）
					  面试时，蛮喜欢问having和where有什么区别？
							where可单独使用，having必须依附于group by
							where是先过滤后分组，having是分组后过滤
							where中不能使用组函数，having中随便使用
							where是一个表过滤行为，having是一个分组后的过滤行为

			select job,min(sal) newsal from emp group by job having newsal>=3000;
			select job,min(sal) newsal from emp group by job having ename in ('SCOTT','KING');
			select job,min(sal) newsal from emp group by job having count(*)>=3;
			select job,min(sal) newsal,count(*),avg(sal) from emp group by job having count(*)>=3;

6、排序 order by 
		数据都已经有了，我sql写完了，但是显示的前后顺序不是我想要的，于是排序
		select * from emp  
		where (deptno=10 and job='MANAGER') 
		or (deptno=20 and job='CLERK') 
		or (job not in ('MANAGER','CLERK') and sal>=2000);

		1、升序 asc 默认,一般我们不写asc
		select * from emp  
		where (deptno=10 and job='MANAGER') 
		or (deptno=20 and job='CLERK') 
		or (job not in ('MANAGER','CLERK') and sal>=2000)
		order by ename;		
		
		2、降序 desc
		select * from emp  
		where (deptno=10 and job='MANAGER') 
		or (deptno=20 and job='CLERK') 
		or (job not in ('MANAGER','CLERK') and sal>=2000)
		order by ename desc;		''

		3、别名
		select sal,comm,sal+ifnull(comm,0) monthly_pay,(sal+ifnull(comm,0))*12 year_sal from emp order by year_sal;
		
		4、位置(不常见)
		select sal,comm,sal+ifnull(comm,0) monthly_pay,(sal+ifnull(comm,0))*12 year_sal from emp order by 3;
		
		5、多字段排序（重点）
		select * from emp order by job,sal desc,comm desc,mgr,ename,empno,deptno desc;

		-- 如下2句sql的执行效果完全一样
		select * from emp order by empno;
		select * from emp order by empno,deptno desc,sal,comm;



子查询