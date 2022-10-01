/*Analysing Covid in India*/

SELECT *
FROM covid_data;

SELECT * 
FROM covid_deaths
ORDER BY 3,4;

/* Creating Temporary Table to store only the required data for further calculation*/

CREATE TEMPORARY TABLE New_Table 
SELECT location,CAST(CONCAT(RIGHT(date,4),'-',MID(date,4,2),'-',LEFT(date,2)) AS DATE) as date,CAST(total_cases AS DOUBLE) as total_cases, CAST(total_deaths AS DOUBLE) as total_deaths, CAST(population AS DOUBLE) as population
FROM covid_data
WHERE NOT(location = 'World' OR location='Europe' OR location = 'International' OR location = 'Oceania' OR location = 'South America' OR location='Asia' OR location = 'North America' OR location='European Union' OR location='Africa')
ORDER BY 1,2;

DROP TABLE New_Table;

DESC New_Table;

SELECT * 
FROM New_Table;

/* Likelihood of dying of contracted Covid*/
SELECT location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
FROM New_Table
WHERE location = 'India'
ORDER BY date;

/* Total cases versus population */
SELECT location, date, population, total_cases, (total_cases/population)*100 as InfectedPerPopulation
FROM New_Table
WHERE location = 'India'
ORDER BY date;

/* Looking at countries with highest infection rate compared to population */
SELECT location, population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases)/population)*100 as InfectionPerPopulationHighest
FROM New_table
GROUP BY location
ORDER BY InfectionPerPopulationHighest desc;

/* Looking for countries with highest deaths per population*/
SELECT location, population, MAX(total_deaths) as HighestDeathCount, (MAX(total_deaths)/population)*100 as DeathsPerPopulationHighest
FROM New_table
GROUP BY location
ORDER BY DeathsPerPopulationHighest desc;

/* Looking at things continent wise */
CREATE TEMPORARY TABLE New_Table_Continent 
SELECT continent,CAST(CONCAT(RIGHT(date,4),'-',MID(date,4,2),'-',LEFT(date,2)) AS DATE) as date,CAST(total_cases AS DOUBLE) as total_cases, CAST(total_deaths AS DOUBLE) as total_deaths, CAST(population AS DOUBLE) as population
FROM covid_data
WHERE NOT (continent = '')
ORDER BY 1,2;

DROP TABLE New_Table_Continent;

SELECT *
FROM New_Table_Continent;

SELECT continent, population, MAX(total_deaths) as HighestDeaths, (MAX(total_deaths)/population) as DeathsPerPopulation
FROM New_Table_Continent
GROUP BY continent
ORDER BY DeathsperPopulation DESC;


/* Oberving as per the date */
SELECT CAST(CONCAT(RIGHT(date,4),'-',MID(date,4,2),'-',LEFT(date,2)) AS DATE) as date, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS Total_Deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercenatge
FROM covid_data
GROUP BY date
ORDER BY date;

/* Looking at Vaccinations */
CREATE TEMPORARY TABLE New_Table_Vaccine
SELECT continent,location,CAST(CONCAT(RIGHT(date,4),'-',MID(date,4,2),'-',LEFT(date,2)) AS DATE) as date, CAST(population AS DOUBLE) as population , CAST(new_vaccinations AS DOUBLE) AS new_vaccinations
FROM covid_data
ORDER BY 1,2,3;

DROP TABLE New_Table_Vaccine;

SELECT *
FROM New_Table_Vaccine;

SELECT continent, location, date, new_vaccinations, SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY date)AS Total_vaccinations_tilldate, (new_vaccinations/population)*100 AS VaccinationPercentage
FROM New_Table_Vaccine
WHERE NOT(continent='')
GROUP BY 1,2,3



