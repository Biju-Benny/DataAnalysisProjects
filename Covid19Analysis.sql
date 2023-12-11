select * from Covid_deaths order by 3,4

--select * from Covid_vaccinations

select [Location],[date], total_cases,new_cases,total_deaths,[population] from  dbo.Covid_deaths order by 1,2

-- looking at Total cases vs total deaths

select [Location],[date], total_cases,total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage 
from  dbo.Covid_deaths where [Location] like '%india%' and total_deaths IS NOT NULL order by 5 desc

-- looking at Total cases vs population

select [Location],[date], total_cases,[population], (cast(total_cases as float)/cast([population] as float))*100 as CasePercentage 
from  dbo.Covid_deaths 
--where [Location] like '%india%' 
order by 2

-- looking at countries with highest infection rate compared to population


select [Location], [population],max (total_cases) as HighestInfectionCount , MAX(cast(total_cases as float)/cast([population] as float))*100 as PercentPopulationInfected 
from  dbo.Covid_deaths 
--where [Location] like '%india%' 
group by [Location], [population]	
order by 4 desc

--showing countries with highest deathcount per population

select [Location], sum (cast(total_deaths as int)) as TotalDeathCount 
from  dbo.Covid_deaths 
where continent is not null
group by [Location]
order by 2 desc

--death count by continent
--showing continents with highest death rate per population

select continent, sum (cast(total_deaths as int)) as TotalDeathCount 
from  dbo.Covid_deaths 
where continent is not null
group by continent
order by 2 desc

--showing continents with highest death rate per population
select continent, sum (cast(total_deaths as int)) as TotalDeathCount 
from  dbo.Covid_deaths 
where continent is not null
group by continent
order by 2 desc
-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as float)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid_deaths dea
Join Covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

with PopVsVac as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as float)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid_deaths dea
Join Covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
) 
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

--temp table
DROP Table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(Continent nvarchar(255),
[Location]  nvarchar(255),
[Date] datetime,
Population numeric,
NewVaccinations numeric,
RollingPeopleVaccinated Numeric
)

select * from #PercentPopulationVaccinated

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as float)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid_deaths dea
Join Covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as float)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid_deaths dea
Join Covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

