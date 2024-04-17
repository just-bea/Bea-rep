CREATE DATABASE PortfolioProject


SELECT LOCATION, DATE, TOTAL_CASES, NEW_CASES, POPULATION, TOTAL_DEATHS
from coviddeaths
ORDER BY 1, 2
select *
from coviddeaths

## Total cases v/s total deaths
SELECT LOCATION, total_cases, total_deaths, (total_deaths/total_cases )* 100 as Percentage
FROM COVIDDEATHS
WHERE LOCATION LIKE '%STATES'
ORDER BY 1,2

SELECT LOCATION, total_cases, total_deaths, (total_deaths/total_cases )* 100 as Percentage
FROM COVIDDEATHS
WHERE LOCATION LIKE '%CUB%'
ORDER BY 1,2

-- TOTAL CASES VS POPULATION
SELECT total_cases, population, location, (total_cases/population)*100 as cases_per_population
from Coviddeaths

-- Looking as the maximum total cases per location
SELECT MAX(total_cases), population, location, continent, MAX((total_cases/population))*100 as mAX_CASES
from Coviddeaths
Group by location, population, continent
order BY MAX_CASES

-- MAXIMUM DEATHS PER COUNTRY
SELECT MAX(Total_deaths) as Max_deaths, location
from Coviddeaths
WHERE continent is not null
Group by location
order BY Max_deaths DESC

-- GLOBAL NUMBERS

SELECT date, SUM(New_cases) as total_cases, SUM(NEW_DEATHS) as total_deaths, SUM(new_cases)/SUM(new_deaths) * 100 as percentage
from coviddeaths
WHERE continent is not null
Group by date
ORDER BY 1,2


-- Vaccinations by location


SELECT d.continent, d.location , d.date, d.population, v.new_vaccinations,
SUM(v.new_vaccinations) OVER (Partition by d.location Order by d.location, d.date) Rolling_people_vaccinated
FROM COVIDDEATHS AS D
JOIN COVIDVACCINATIONS AS V
ON D.DATE= V.DATE
AND D.LOCATION = V.LOCATION
WHERE d.continent is not null
order by  2,3

-- USE CTE

WITH PopvsVac ( Continent , location, date, population, new_vaccinations, Rolling_people_vaccinated)
as
(
SELECT d.continent, d.location , d.date, d.population, v.new_vaccinations,
SUM(v.new_vaccinations) OVER (Partition by d.location Order by d.location, d.date) as Rolling_people_vaccinated
FROM COVIDDEATHS AS D
JOIN COVIDVACCINATIONS AS V
ON D.DATE= V.DATE
AND D.LOCATION = V.LOCATION
WHERE d.continent is not null
)

Select *, (Rolling_people_vaccinated/population)*100
from PosvsVac



-- temp table


DROP TABLE IF EXISTS
CREATE TABLE #PercentPopulationVaccinated
(continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_people_vaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT d.continent, d.location , d.date, d.population, v.new_vaccinations,
SUM(v.new_vaccinations) OVER (Partition by d.location Order by d.location, d.date) as Rolling_people_vaccinated
FROM COVIDDEATHS AS D
JOIN COVIDVACCINATIONS AS V
ON D.DATE= V.DATE
AND D.LOCATION = V.LOCATION
WHERE d.continent is not null

Select *, (Rolling_people_vaccinated/population)*100
from #PercentPopulationVaccinated

-- Creating view for later use in visualization

Create View PercentPopulationVaccinated as
SELECT d.continent, d.location , d.date, d.population, v.new_vaccinations,
SUM(v.new_vaccinations) OVER (Partition by d.location Order by d.location, d.date) as Rolling_people_vaccinated
FROM COVIDDEATHS AS D
JOIN COVIDVACCINATIONS AS V
ON D.DATE= V.DATE
AND D.LOCATION = V.LOCATION
WHERE d.continent is not null