-- Data Cleaning

Select *
from layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any columns


CREATE TABLE layoffs_staging
LIKE layoffs;

Select *
From layoffs_staging;

Insert layoffs_staging
Select *
from layoffs;

Select *,
Row_number() over(Partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

WITH duplicate_cte AS
(
Select*,
Row_number() over(Partition by company, location,  industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
Select *
from duplicate_cte
where row_num> 1;

Select *
From layoffs_staging
where company = 'Casper';

WITH duplicate_cte AS
(
Select*,
Row_number() over(Partition by company, location,  industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
Delete
from duplicate_cte
where row_num> 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
from layoffs_staging2;

Insert into layoffs_staging2
Select*,
Row_number() over(Partition by company, location,  industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

select *
from layoffs_staging2;

delete
from layoffs_staging2
where row_num> 1;

select *
from layoffs_staging2;

-- Standardizing data

select company, (Trim(company))
from layoffs_staging2;

Update layoffs_staging2
set company = Trim(company);

select distinct location
from layoffs_staging2
order by 1;

UPDATE layoffs_staging2
set industry = 'Crypto'
where industry like 'crypto%';

select distinct country, trim(Trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(Trailing '.' from country)
where country like 'United States%';

select `date`
from layoffs_staging2;

update layoffs_staging2
set date = STR_TO_DATE(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` DATE;

select *
from layoffs_staging2;

-- Removing nulls/blanks

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

update layoffs_staging2
set industry = null
where industry='';


select *
from layoffs_staging2
where industry is null or industry ='';

select *
from layoffs_staging2
where company like 'Bally%';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company= t2.company
where (t1.industry is null or t1.industry ='')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company= t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;


select *
from layoffs_staging2;

delete 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


alter table layoffs_staging2
drop column row_num;
