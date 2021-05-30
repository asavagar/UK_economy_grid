UK_economy_grid
===============

#### Anthony Savagar, asavagar\@gmail.com

#### 30/05/2021

`create_rsy_grids.R` constructs region, sector, year (rsy) grids, *i.e.* panels,
for the UK economy.

Input
-----

`create_rsy_grids.R` uses SIC 2007 industries from SIC1-SIC5 stored in
`./input/bsd_structure.xlsx`, taken from:

https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=6697\#!/documentation.

Office for National Statistics SIC 2007 definitions are available here:

https://onsdigital.github.io/dp-classification-tools/standard-industrial-classification/ONS_SIC_hierarchy_view.html.

`create_rsy_grids.R` uses NUTS 2018 region files `./input/NUTS1_2018`,
`./input/NUTS2_2018`, `./input/NUTS3_2018`, taken from

https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(NAC_EUR).

Output
------

`create_rsy_grids.R` saves `.csv`, `.RDS` and `.Rdata` files of various grid
combinations to directory `./output/`. The R data formats are smaller than the
`.csv` formats.

The `.RDS` saves individual dataframes.

The `.Rdata` format contains all dataframes. You should load this file into `R`
if you want to access all grids.

Only one example output (`sy_grid_1d.csv` the smallest output) is pushed to the
remote repo.

`rsy_grid.csv` is the so-called *master grid*. It contains roughly 10 millon
rows (`100mb`) for all SIC, NUTS and year combinations at all levels of
diaggregation. There are 5 columns. It contains three variables, or columns,
corresponding to region code, sector code and year. It has two more or columns
which record the level of aggregation of the corresponding SIC code and NUTS
code.

`rsy_grid_named.csv` expands `rsy_grid.csv` by two columns to include the sector
name and region name in text. These correspond to the SIC code and NUTS code.
The file is much larger (approx. `800mb`) because the added columns include text
data.

`sy_grid_*d.csv` where `*` is the SIC level `1`, `2`, `3`, `4`, `5` outputs
contain smaller sector-year grids at each level of SIC disaggregation. For
example, `sy_grid_1d.csv` contains 504 rows which is 21 1-digit SIC sectors
across 24 years 1997-2020 and `sy_grid_5d.csv` contains 17,520 rows which is 730
5-digit SIC sectors across 24 years 1997-2020.

### Warning for viewing SIC codes in `.csv` in Excel

Opening the `.csv` outputs in Excel is misleading for SIC codes because Excel
hides leading zeroes.

If you open the `.csv` with any text editor, or RStudio, you will see that the
zeroes are present.
