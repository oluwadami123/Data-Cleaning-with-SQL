---Inspecting the Table 
Select *
From NashvilleData


--Converting the SaleDate to a Date Column

Alter Table NashvilleData
Add SaleDateConverted Date

Update NashvilleData
Set SaleDateConverted = CONVERT(Date,SaleDate)

-- Filling the Null Values in the PropertyAddress Column 
--- Joined both tables together On ParceID and Different UniqueID
--- Filling the Null Values in the NashvilleDate Table with the Values in Table b using ISNULL 
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, B.PropertyAddress)
From NashvilleData a
Join NashvilleData b
 On a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 --Where PropertyAddress is Null

 --Update the PropertyAddress column
Update a
Set PropertyAddress =  ISNULL(a.PropertyAddress, B.PropertyAddress)
From NashvilleData a
Join NashvilleData b
 On a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
--Where PropertyAddress is Null

---Breaking Dwon the PropertyAddress into(Address, City)
Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City

From NashvilleData


Alter Table NashvilleData
Add Address nvarChar(255)

Update NashvilleData
Set Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) 

Alter Table NashvilleData
Add City nvarChar(255) 

Update NashvilleData
Set City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

--- Spliting the owner address into (Address, City, State) Using ParseName
Select 
ParseName(Replace(OwnerAddress,',','.'), 3), 
ParseName(Replace(OwnerAddress,',','.'), 2), 
ParseName(Replace(OwnerAddress,',','.'), 1) 
From NashvilleData

Alter Table NashvilleData
Add OwnerSplitAddress Nvarchar(255)

Update NashvilleData
Set OwnerSplitAddress = ParseName(Replace(OwnerAddress,',','.'), 3)


Alter Table NashvilleData
Add OwnerSplitCity Nvarchar(255)

Update NashvilleData
Set OwnerSplitCity = ParseName(Replace(OwnerAddress,',','.'), 2)


Alter Table NashvilleData
Add OwnerSplitState Nvarchar(255)

Update NashvilleData
Set OwnerSplitState = ParseName(Replace(OwnerAddress,',','.'), 1)


--- Changing the 'Y' to 'Yes'and 'N' to 'No' in The SoldAsVacant Column 

---Inspecting the Columns to get the Distinct Count
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleData
Group by SoldAsVacant
Order By 2

Select SoldAsVacant,
 Case When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No' 
	  Else SoldAsVacant
	  End
From NashvilleData

Update NashvilleData
Set SoldAsVacant =  Case When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No' 
	  Else SoldAsVacant
	  End
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleData
Group By SoldAsVacant
Order By 2

Select*
From NashvilleData
----Removing Duplicates

With ROWNUM_CTE as(
Select *,
       ROW_NUMBER() Over(
	   Partition By 
	        ParcelID,
			PropertyAddress,
			SaleDate,
			SalePrice,
			LegalReference
			Order By UniqueID )as RowNum
From NashvilleData
)
Select *
From ROWNUM_CTE
Where RowNum > 1

--- Deleting Duplicates
With ROWNUM_CTE as(
Select *,
       ROW_NUMBER() Over(
	   Partition By 
	        ParcelID,
			PropertyAddress,
			SaleDate,
			SalePrice,
			LegalReference
			Order By UniqueID )as RowNum
From NashvilleData
)
Delete
From ROWNUM_CTE
Where RowNum > 1


---Deleting Unused Column 
Alter Table NashvilleData
Drop column SaleDate, OwnerAddress, PropertyAddress

---Inspecting the Table 
Select*
From NashvilleData