Select *
From PortfolioProject..CovidDeaths
Order By 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order By 3,4

-- Selecting data That we are going to Use
Select Location , date , total_cases , new_cases , total_deaths , population
From PortfolioProject..CovidDeaths
order by 3,4


--Lookig At total cases VS Deaths
--LIKIELYHOOD OF DYING WITH COVID 
Select Location , date , total_cases , total_deaths ,(total_deaths/total_cases)*100 as PercentOfPopulationInfected
From PortfolioProject..CovidDeaths
wHERE location like ' % states % '
order by 1,2 

--Looking at Total Cases Vs population
--Percentage of population got covid
Select Location , date , total_cases , population ,CAST(((total_cases/population)*100) as decimal (10,2)) as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like ' % states % '
order by 1,2 

--Highest Infection of country by population
Select Location , Population , MAX( total_cases ) as HighestInfectionCount, Max((total_cases/population))*100 as
PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like ' % states % '
Group By Location , Population
order by PercentPopulationInfected desc

--Continent Based Data
--Countries wigh Highest Death Count Per Population

Select location,MAX(cast(Total_deaths as int))as TotalDeathCount
From PortfolioProject.. CovidDeaths
where continent is not null 
Group by location
order by TotalDeathCount desc


-- Showing continent with highest death rate and socio econmic status

Select location,MAX(cast(Total_deaths as int))as TotalDeathCount
From PortfolioProject.. CovidDeaths
where continent is null 
Group by location
order by TotalDeathCount desc







--Global Numbers
Select SUM ( new_cases ) as total_cases , SUM ( cast ( new_deaths as int ) ) as total_deaths , SUM ( cast
( new_deaths as int ) ) / SUM ( New_Cases ) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like ' % states % '
where continent is not null
--Group By date
order by 1,2



-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location ,dea.Date ) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

---Using CTE
With PopvsVac ( Continent , Location, Date, Population , New_Vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location ,dea.Date ) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select * , ( RollingPeopleVaccinated/Population )*100
From PopvsVac





--TEMP TABLE
DROP TABLE IF exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime ,
Population numeric ,
New_vaccinations numeric ,
RollingPeopleVaccinated numeric
)

 Insert into #PercentPopulationVaccinated
Select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
, SUM ( CONVERT ( bigint , vac.new_vaccinations ) ) OVER ( Partition by dea.Location Order by dea.location ,
dea . Date ) as RollingPeopleVaccinated
-- , ( Rolling PeopleVaccinated / population ) * 100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * , ( RollingPeopleVaccinated / Population ) * 100
From #PercentPopulationVaccinated



--creating a temp view for visualizations
Create View PercentPopulationVaccinated1 as
Select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations,
SUM ( CONVERT ( int , vac.new_vaccinations ) ) OVER ( Partition by dea.Location Order by dea.location ,
dea . Date ) as RollingPeopleVaccinated
-- , ( Rolling PeopleVaccinated / population ) * 100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3


