Select * 
From PortfolioProject..CovidDeaths
Order By 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order By 1,2

--Total cases vs total deaths

Select Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as Ratio
From PortfolioProject..CovidDeaths
Where Location = 'India'
Order By 1,2

--Total number of population being infected
Select Location, date, population, total_cases, (total_cases/population)*100 as Ratio
From PortfolioProject..CovidDeaths
Where Location = 'India'
Order By 1,2

--Max cases
Select Location, population, max(total_cases) as max_cases, max((total_cases/population))*100 as Ratio
From PortfolioProject..CovidDeaths
--Where Location = 'India'
Group By Location, Population
Order By Ratio Desc

--Highest Death
Select Location, population, max(total_cases) as max_cases, max(cast(total_deaths as int)) as max_deaths, max((total_deaths/population)*100)as Ratio
From PortfolioProject..CovidDeaths
Group By Location, Population
Order By Ratio Desc

Select Location, max(cast(total_deaths as int)) as max_deaths
From PortfolioProject..CovidDeaths
Where continent is not null
Group By Location
Order By max_deaths Desc

--Highest Death by continent

Select Continent, max(cast(total_deaths as int)) as max_death
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by max_death desc

Select Location, max(Cast(Total_deaths as int)) as max_death
From PortfolioProject..CovidDeaths
where continent is null
Group by location
Order by max_death desc

-- Global numbers

Select Date, Sum(New_Cases) as total_cases, Sum(Cast(new_deaths as int)) as total_deaths, Sum(Cast(new_deaths as int)) / Sum(new_cases) *100 as percentage
From CovidDeaths
Where continent is not null
Group by date
Order by percentage desc

-- Join Tables

Select * 
From CovidDeaths as dea
Join CovidVaccinations as vac
On dea.location = vac.location
and dea.date = vac.date

-- Population vs vaccination

Select dea.location, dea.continent, dea.date, Population, Cast(total_vaccinations as int) As total_vac--, population/total_vaccinations * 100 as percentage
From CovidDeaths as dea
join CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--Group by dea.location, population, total_vaccinations
Order by total_vac desc

-- Partition by 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location), dea.Date as total--, (total/population)*100
From CovidDeaths dea
Join CovidVaccinations as vac
On dea. location = vac.location
and dea.date= vac.date
where dea. continent is not null
order by 2,3

-- With CTE

With Popvsvac (continent, location, date, population, new_vaccinations, total)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location ,dea.Date) as total--, (total/population)*100 as percent
From CovidDeaths as dea
Join CovidVaccinations as vac
On dea. location = vac.location
and dea.date= vac.date
where dea. continent is not null
--order by 2,3
)

Select * , (total/population)*100 as final
From Popvsvac

--Create view for later visualisation

Create View total_vac
as
Select dea.location, dea.continent, dea.date, Population, Cast(total_vaccinations as int) As total_vac--, population/total_vaccinations * 100 as percentage
From CovidDeaths as dea
join CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--Group by dea.location, population, total_vaccinations
--Order by total_vac desc

Select * 
From total_vac



