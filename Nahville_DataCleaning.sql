
--UNIFYING DATE FORMAT

select * 
from PortfolioProject.dbo.NahvilleHousing


SELECT SaleDate, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NahvilleHousing

Update NahvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

--Populate Property Address

select *
from PortfolioProject.dbo.NahvilleHousing
Where PropertyAddress is null
order by ParcelID

select a.ParcelID , a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject.dbo.NahvilleHousing A
JOIN PortfolioProject.dbo.NahvilleHousing B
	ON A.ParcelID= B.ParcelID
	AND A.[UniqueID ]<> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
from PortfolioProject.dbo.NahvilleHousing A
JOIN PortfolioProject.dbo.NahvilleHousing B
	ON A.ParcelID= B.ParcelID
	AND A.[UniqueID ]<> B.[UniqueID ]



	-- Breaking address into individual columns

select PropertyAddress
from PortfolioProject.dbo.NahvilleHousing

Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS Address1

from PortfolioProject.dbo.NahvilleHousing


ALTER TABLE NahvilleHousing
Add PropertySplitAdress Nvarchar(255);

Update NahvilleHousing
SET PropertySplitAdress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NahvilleHousing
Add PropertySplitCity nvarchar(255) ;

Update NahvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))



select *
from PortfolioProject.dbo.NahvilleHousing






---Changing Owner Adress
select 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
from PortfolioProject.dbo.NahvilleHousing


ALTER TABLE NahvilleHousing
Add OwnerSplitAddress nvarchar(255) ;

Update NahvilleHousing
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE NahvilleHousing
Add OwnerSplitCity nvarchar(255) ;

Update NahvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NahvilleHousing
Add OwnerSplitState nvarchar(255) ;

Update NahvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)




-- Distiction if property is sold as vacant or not
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NahvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant,
CASE When SoldAsVacant= 'Y' THEN 'Yes'
	When SoldAsVacant= 'N' THEN 'NO'
	ELSE SoldAsVacant
	END
From PortfolioProject.dbo.NahvilleHousing


Update NahvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant =' Y ' THEN ' Yes '
When SoldAsVacant =' N ' THEN ' No '
ELSE SoldAsVacant
END

-- Removing Duplicates

WITH RowNumCTE AS(
select *,
ROW_NUMBER ( ) OVER (
PARTITION BY ParcelID ,
PropertyAddress ,
SalePrice ,
SaleDate ,
LegalReference
ORDER BY
UniqueID
) row_num
From PortfolioProject.dbo.NahvilleHousing
--order by ParcelID
)

--SELECT*
DELETE
FROM RowNumCTE
WHERE row_num>1
--order by PropertyAddress




--Delete unusued columns

select *
from PortfolioProject.dbo.NahvilleHousing

ALTER TABLE PortfolioProject.dbo.NahvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict,SaleDate