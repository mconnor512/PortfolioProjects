

USE covid_info;

SELECT *
FROM CovidDeaths
ORDER BY 3,4;

SELECT *
FROM CovidVaccinations
ORDER BY 3,4;

-- Select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2;

-- Looking at Total Cases vs Total Deaths 
-- Shows the likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE location = 'United States'
ORDER BY 3;

-- Looking at the Total Cases vs Populaton

SELECT Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
FROM CovidDeaths
-- WHERE location = 'United States'
ORDER BY 2;

-- Came across issue with ordering by date. It is ordering by numerically by each number (1/1, 1/10, 1/11) instead of by oldest date to newest.
-- Problem came from imported data all created as longtext data type. Have to change numbers from longtext to int
-- I had to manually create a table with 26 rows with all sorts of different types of data types. I had to investigate and analyze the dataset in Excel to find the correct data types (INT, DECIMAL, VARCHAR). 
-- For example, I used used the LEN function to find out how long the numbers were for different columns ex: new_cases_smoothed has a max of 10 characters, with 3 after the decimal.
-- FINAL RESULT - Changed date format to YYYY-MM-DD, Formatted date cells as date in excel,
-- Saved as CSV, used CotEditor to Change UTF-8 with BOM to just UTF-8 Format and uploaded into MYSQL

DESC CovidDeaths;
DESC CovidVaccinations;

-- Looking at Countries with highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) as PercentPopulationInfected
FROM CovidDeaths
GROUP BY population, location 
ORDER BY PercentPopulationInfected DESC;

-- shows us percentage of population infected per country

-- This is showing countries with highest death count per population

SELECT location, MAX(CAST(total_deaths AS int) AS TotalDeathCount
FROM CovidDeaths
GROUP BY location 
ORDER BY TotalDeathCount DESC;

-- Lets break things down by continent/location

SELECT location, continent, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths
GROUP BY location, continent;

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is NULL
GROUP BY location
ORDER BY TotalDeathCount;
-- displays view of 9 continents + world and total deaths grouped with highest showing at top

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases), SUM(new_deaths), SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

-- Looking at total Population vs Vaccinations

-- USE CTE 
 
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaxxed)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaxxed
FROM coviddeaths dea
JOIN covidvaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL)
-- ORDER BY 2, 3);

SELECT *, (RollingPeopleVaxxed/population)*100
FROM PopvsVac

-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaxxed
FROM coviddeaths dea
JOIN covidvaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
-- ORDER BY 2, 3);

SELECT * FROM percentpopulationvaccinated 
;