select * from dbo.[Nashville Housing Data Table]

---------------------------------------------------------------------------------------------------------------------------------------------------------
--Standardize date format	

select SaleDateConverted, CONVERT (DATE, SaleDate) from dbo.[Nashville Housing Data Table]

Alter table dbo.[Nashville Housing Data Table]
add SaleDateConverted Date;

update dbo.[Nashville Housing Data Table]
set SaleDateConverted =  CONVERT (DATE, SaleDate)





---------------------------------------------------------------------------------------------------------------------------------------------------------
--populate property address

select PropertyAddress
from dbo.[Nashville Housing Data Table]


select * from dbo.[Nashville Housing Data Table]
--where  PropertyAddress is null
order by ParcelID


select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from dbo.[Nashville Housing Data Table] a
    join dbo.[Nashville Housing Data Table] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from dbo.[Nashville Housing Data Table] a
    join dbo.[Nashville Housing Data Table] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


---------------------------------------------------------------------------------------------------------------------------------------------------------
-- breaking address into individual columns(Address, City,State)
select Propertyaddress from [Nashville Housing Data Table]

select
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress)) as City
from [Nashville Housing Data Table]



Alter table dbo.[Nashville Housing Data Table]
add PropertySplitAddress  Nvarchar(255);

update dbo.[Nashville Housing Data Table]
set PropertySplitAddress =  SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

Alter table dbo.[Nashville Housing Data Table]
add PropertySplitCity  Nvarchar(255);

update dbo.[Nashville Housing Data Table]
set PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress))

select PARSENAME(REPLACE(OwnerAddress,',','.'),1) ,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) ,
PARSENAME(REPLACE(OwnerAddress,',','.'),3) 
from [Nashville Housing Data Table]


Alter table dbo.[Nashville Housing Data Table]
add OwnerSplitAddress  Nvarchar(255);

update dbo.[Nashville Housing Data Table]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter table dbo.[Nashville Housing Data Table]
add OwnerSplitCity  Nvarchar(255);

update dbo.[Nashville Housing Data Table]
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter table dbo.[Nashville Housing Data Table]
add OwnerSplitState  Nvarchar(255);

update dbo.[Nashville Housing Data Table]
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select OwnerSplitAddress,OwnerSplitCity, OwnerSplitState from [Nashville Housing Data Table]


---------------------------------------------------------------------------------------------------------------------------------------------------------
--change Y and N to Yes and No in "Sold as Vacent" Field
select Distinct SoldAsVacant,COUNT(SoldAsVacant) as total 
from [Nashville Housing Data Table]
group by SoldAsVacant order by total

SELECT SoldAsVacant,
   case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from [Nashville Housing Data Table]


update [Nashville Housing Data Table]
set SoldAsVacant =    case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end


---------------------------------------------------------------------------------------------------------------------------------------------------------
--remove duplicates

WITH RawNumCte AS (
select *, ROW_NUMBER() over(
	partition by ParcelId,SaleDate,PropertyAddress,SalePrice,LegalReference
	order by UniqueId) as RowNumber
from [Nashville Housing Data Table]
)

SELECT * FROM RawNumCte 

--where RowNumber >1
order by RowNumber

---------------------------------------------------------------------------------------------------------------------------------------------------------
--delete unused columns
select * from [Nashville Housing Data Table]

alter table [Nashville Housing Data Table]
drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate


---------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------


