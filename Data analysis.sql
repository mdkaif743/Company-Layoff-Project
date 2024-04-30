-- Exploratory Data Analysis

Select *
from layoffs_staging2;

Select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

Select *
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised_millions desc;

Select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(`date`),max(`date`)
from layoffs_staging2;

Select country,sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

Select *
from layoffs_staging2;

Select YEAR(`date`),sum(total_laid_off)
from layoffs_staging2
group by Year(`date`)
order by 1 desc;

Select stage,sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

Select company,avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

With Rolling_total AS (
select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off,
sum(total_off) over (order by `month`) as rolling_total
from Rolling_total;

Select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

Select company,YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,Year(`date`)
order by 3 desc;

WITH company_year (company, years, total_laid_off) as(
Select company,YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,Year(`date`)
), Company_year_rank as 
(
Select *, dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from company_year
where years is not null)
Select *
From Company_year_rank
where ranking<= 5;
