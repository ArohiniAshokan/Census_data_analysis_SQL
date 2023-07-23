--loading both datasets
Select * from Projects.dbo.Data1;
Select * from Projects.dbo.Data2;

--total rows in data1
select COUNT(*) from Projects.dbo.Data1;

--total rows in data2
select COUNT(*) from Projects.dbo.Data2;

--collect all the data from Data1 of Jharkhand and Bihar
select * from Projects.dbo.Data1 where State='Jharkhand' or State='Bihar';
-- or
select * from Projects.dbo.Data1 where State in('Jharkhand','Bihar');

--Total population of India
select SUM(Population) as TotalPopulation from Projects.dbo.Data2;

--Average population of India and rounding it to 3 decimal
select ROUND(AVG(Population),3) as AvgPopulation from Projects.dbo.Data2;

--Average growth of India and express it in percentage
select AVG(Growth)*100 as AvgGrowth from Projects.dbo.Data1;

--Average Growth of each state
select State,ROUND(AVG(Growth),2) from Projects.dbo.Data1 group by State;

--Average sex ratio of each state and arrange it in desc order
select State,ROUND(AVG(Sex_Ratio),0) as avg from Projects.dbo.Data1 group by State order by avg desc;

--Average Literacy rate of state with avg literacy rate greater than 90 and order literacy descending
select State,ROUND(AVG(Literacy),0) as avg from Projects.dbo.Data1 group by State having ROUND(AVG(Literacy),0)>90 order by avg desc;

--top 3 states with highest avg growth rate
select top 3 State,ROUND(AVG(Growth),2) as avg from Projects.dbo.Data1 group by State order by avg desc;

--bottom 3 states with lowest avg sex ratio
select top 3 State,ROUND(AVG(Sex_Ratio),0) as avg from Projects.dbo.Data1 group by State order by avg asc;

--Top and bottom 3 states with avg literacy rate
select * from(select top 3 State,ROUND(AVG(Literacy),0) as avg from Projects.dbo.Data1 group by State order by avg desc)a
union
select * from (select top 3 State,ROUND(AVG(Literacy),0) as av from Projects.dbo.Data1 group by State order by av asc)b;

--States starting with letter 'a' and ending with 'h'
select distinct State from Projects.dbo.Data1 where State like 'a%' and State like'%h';

--Find district wise total no of males and females 
select c.District,c.State,ROUND(c.Population/(1+c.Sex_Ratio),0) Males,ROUND((c.Population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) Females from
(select a.District,a.State,a.Sex_Ratio/1000 Sex_Ratio,b.Population from Projects.dbo.Data1 a inner join Projects.dbo.Data2 b on a.District=b.District)c;

--Find State wise total no of males and females
select d.State,SUM(d.Males) Total_Males,SUM(d.Females) Total_Females from 
(select c.District,c.State,ROUND(c.Population/(1+c.Sex_Ratio),0) Males,ROUND((c.Population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) Females from
(select a.District,a.State,a.Sex_Ratio/1000 Sex_Ratio,b.Population from Projects.dbo.Data1 a inner join Projects.dbo.Data2 b on a.District=b.District)c)d 
group by d.State;

--State wise total no of literate and illiterate people
select d.State,SUM(d.Literate) Literate_people,SUM(d.Illiterate) Illiterate_people from
(select c.District,c.State,ROUND((c.Literate_ratio*c.Population),0) Literate,ROUND((1-c.Literate_ratio)*c.Population,0) Illiterate from
(Select a.District,a.State,a.Literacy/100 Literate_ratio,b.Population from Projects.dbo.Data1 a inner join Projects.dbo.Data2 b on a.District=b.District)c)d 
group by d.State;

--state wise top 3 districts with highest literacy rate
select a.* from
(select District,State,Literacy,RANK() over(Partition by State order by Literacy) rnk from Projects.dbo.Data1)a
where a.rnk in(1,2,3);