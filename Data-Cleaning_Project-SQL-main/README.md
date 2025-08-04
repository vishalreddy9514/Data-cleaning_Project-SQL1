# Nashville Housing Data Cleaning in SQL

This project focuses on cleaning raw housing data using Microsoft SQL Server. The dataset is taken from a Nashville housing market and underwent several transformations to prepare it for analysis.

## 📌 Key Tasks Performed

- Standardized date formats.
- Filled in missing `PropertyAddress` using `ParcelID`.
- Split addresses into individual fields (Address, City, State).
- Cleaned up categorical data such as `SoldAsVacant`.
- Removed duplicate records using window functions.
- Dropped unused columns to streamline the dataset.

## 🛠 Tools Used

- Microsoft SQL Server
- T-SQL
- SSMS

## 📂 File

- `NashvilleHousing_Cleaning.sql` — full SQL script with comments explaining each step.

