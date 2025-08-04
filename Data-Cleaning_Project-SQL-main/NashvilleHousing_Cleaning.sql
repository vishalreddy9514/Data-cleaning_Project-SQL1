/*
  Nashville Housing Data Cleaning Script
  Author: Your Name
  Description: A complete SQL data cleaning process including null handling, format standardization, and deduplication.
*/

-- View Raw Data
Select * From PortfolioProject.dbo.NashvilleHousing;

-- Standardize Date Format
ALTER TABLE NashvilleHousing Add SaleDateConverted Date;
Update NashvilleHousing SET SaleDateConverted = CONVERT(Date, SaleDate);

-- Populate Property Address Data
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;

-- Break out Address into Individual Columns
ALTER TABLE NashvilleHousing Add PropertySplitAddress Nvarchar(255);
Update NashvilleHousing SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE NashvilleHousing Add PropertySplitCity Nvarchar(255);
Update NashvilleHousing SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));

-- Break out Owner Address into Individual Columns
ALTER TABLE NashvilleHousing Add OwnerSplitAddress Nvarchar(255);
Update NashvilleHousing SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE NashvilleHousing Add OwnerSplitCity Nvarchar(255);
Update NashvilleHousing SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE NashvilleHousing Add OwnerSplitState Nvarchar(255);
Update NashvilleHousing SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

-- Standardize SoldAsVacant field
Update NashvilleHousing
SET SoldAsVacant = CASE 
    When SoldAsVacant = 'Y' THEN 'Yes'
    When SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;

-- Remove Duplicates
WITH RowNumCTE AS(
    Select *,
        ROW_NUMBER() OVER (
        PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
        ORDER BY UniqueID) row_num
    From PortfolioProject.dbo.NashvilleHousing
)
DELETE FROM RowNumCTE WHERE row_num > 1;

-- Drop Unused Columns
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
