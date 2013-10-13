/* CS 186 Fall 2013, Homework 3 - Federal Government Shutdown Edition */
/* MJF 10/9/13 */

/*this first command creates and populates the table.*/
.read hw3populate.sql
.header OFF
.mode list 

/* For each of the queries below, put your SQL in the place indicated by the comment.  Be sure to have all the requested columns in your answer, in the order they are listed in the question - and be sure to sort things where the question requires them to be sorted, and eliminate duplicates where the question requires that.   We will grade the assignment by running the queries on a test database and eyeballing the SQL queries where necessary.  We won't grade on SQL style, but we also won't give partial credit for any individual question - so you should be confident that your query works. In particular, your output should match our example output*/

/* Q1 -  Return the statecode, county name and 2010 population of all counties who had a population of over 2,000,000 in 2010. Return the rows in descending order from most populated to least*/
select " ";
select "Q1";
select c.statecode, c.name, c.population_2010 from counties c where c.population_2010 > 2000000 order by c.population_2010 DESC;

/* Q2 -  Return a list of statecodes and the number of counties in that state, ordered from the least number of counties to the most
*/
select " ";
select "Q2";
select s.statecode, COUNT(*)
from states s join counties c
on s.statecode == c.statecode
group by s.statecode
order by COUNT(*);

/* Q3  - On average how many counties are there per state (return a single real number) */ 
select " ";
select "Q3";
select AVG(cnt) as countyNumAverage
from (select COUNT(*) as cnt
from states s join counties c
on s.statecode == c.statecode
group by s.statecode);


/* Put your SQL for Q3 below */

/* Q4 - return a count of how many states have more than the average number of counties TODO*/
select " ";
select "Q4";
select COUNT(*)
from states s1
where (select COUNT(*)
from states s2, counties c1
where s2.statecode == c1.statecode and s1.statecode == s2.statecode
) > (
select AVG(cnt)
from (select COUNT(*) as cnt
from states s join counties c
on s.statecode == c.statecode
group by s.statecode)
);

/* Q5 - Data Cleaning - return the statecodes of states whose 2010 population does not equal the sum of the 2010 populations of their counties*/
select " ";
select "Q5";
select s.statecode
from states s
where s.population_2010 != (
select sum(c.population_2010)
from counties c, states s2
where s.statecode == s2.statecode and c.statecode == s2.statecode
);

/* Q6 - How many states have at least one senator whose first name is John, Johnny, or Jon? Return a single integer*/
select " ";
select "Q6";
select COUNT(DISTINCT s.statecode)
from states s, senators se
where s.statecode == se.statecode
and (se.name LIKE "John %"
or se.name LIKE "Johnny %"
or se.name LIKE "Jon %");

/*Q7 - Find all the senators who were born in a year before the year their state was admitted to the union.   For each, output the statecode, year the state was admitted to the union, senator name, and year the senator was born.
Note: in SQLite you can extract the year as an integer using the following: "cast(strftime('%Y',admitted_to_union) as integer)"*/
select " ";
select "Q7";
select se.statecode, cast(strftime('%Y',s.admitted_to_union) as integer) as admitted, se.name, se.born
from senators se, states s
where se.statecode == s.statecode
and admitted > se.born;

/* Q8 - Find all the counties of West Virginia (statecode WV) whose population shrunk between 1950 and 2010, and for each, return the name of the county and the number of people who left during that time (as a positive number).*/
select " ";
select "Q8";
select c.name, c.population_1950 - c.population_2010
from counties c
where c.statecode == 'WV' and c.population_2010 < c.population_1950;

/*Q9 - Return the statecode of the state(s) that is (are) home to the most committee chairmen*/
select " ";
select "Q9";

select s1.statecode
from states s1, committees co1, senators se1
where co1.chairman == se1.name and se1.statecode == s1.statecode
group by s1.statecode
having COUNT(*) == (select COUNT(*) as num
    from states s, committees co, senators se
    where co.chairman == se.name and se.statecode == s.statecode
    group by s.statecode order by num desc limit 1);

/*Q10 - Return the statecode of the state(s) that are not the home of any committee chairmen */
select " ";
select "Q10";
select s.statecode
from states s
where not exists(
      select co.chairman
      from committees co, senators se
      where se.name == co.chairman and s.statecode == se.statecode
);

/*Q11 Find all subcommittes whose chairman is the same as the chairman of its parent committee.  For each, return
the id of the parent committee, the name of the parent committee's chairman, the id of the subcommittee, and name of that subcommittee's chairman*/

select " ";
select "Q11";
select co.parent_committee, pco.chairman, co.id, co.chairman
from committees co, committees pco
where co.parent_committee == pco.id and co.chairman == pco.chairman;

/*Q12 - For each subcommittee where the subcommittee’s chairman was born in an earlier year than the chairman of its parent committee,  Return the id of the parent committee,  its chairman, the year the chairman was born, the id of the submcommittee, it’s chairman and the year the subcommittee chairman was born.  */
select " ";
select "Q12";
select pco.id, pco.chairman, pc.born, co.id, co.chairman, c.born
from committees co, committees pco, senators c, senators pc
where co.parent_committee == pco.id and co.chairman == c.name
and pco.chairman == pc.name and c.born < pc.born;
