# create_rsy_grids.R
#
# Anthony Savagar, asavagar@gmail.com
#
# Date 16/05/2021
#
# Code creates region, sector, year (rsy) grids (panels) for the UK economy.
# The most granular grid, or master grid, is approx 10m rows.
# The master grid includes all industry (SIC1-SIC5), all regions (NUTS0-NUTS3),
# and all year combinations.

library(readxl)
library(tidyverse)

# Load Data ---------------------------------------------------------------

sic_base <- read_excel("./input/bsd_structure.xlsx")
nuts1_2 <- read_csv("./input/NUTS2_2018.csv")
nuts3 <- read_csv("./input/NUTS3_2018.csv")

# Create Year Variable ----------------------------------------------------

year <- seq(1997, 2020)

# Tidy Region Data --------------------------------------------------------

nuts0 <- data.frame(nuts_code = c("UK"), nuts_name = c("United Kingdom"))
nuts0 <- nuts0 %>% add_column(nuts_level = "0")
nuts1 <- nuts1_2 %>% select(NUTS118CD, NUTS118NM)
nuts1 <- nuts1[!duplicated(nuts1), ]
nuts1 <- rename(nuts1, nuts_code = NUTS118CD, nuts_name = NUTS118NM)
nuts1 <- nuts1 %>% add_column(nuts_level = "1")
nuts2 <- nuts1_2 %>% select(NUTS218CD, NUTS218NM)
nuts2 <- rename(nuts2, nuts_code = NUTS218CD, nuts_name = NUTS218NM)
nuts2 <- nuts2 %>% add_column(nuts_level = "2")
nuts3 <- rename(nuts3, nuts_code = NUTS318CD, nuts_name = NUTS318NM) %>%
  select(!"FID")
nuts3 <- nuts3 %>% add_column(nuts_level = "3")
nuts_all <- bind_rows(nuts0, nuts1, nuts2, nuts3)

# Create Sector Year (sy) Grids -------------------------------------------

sic_5d <- sic_base %>% select("sic07_5digit", "sic07_5digit_name")
sic_5d <- sic_5d[!duplicated(sic_5d), ]
sic_5d <- rename(sic_5d, sic_code = sic07_5digit, sic_name = sic07_5digit_name)
sic_5d <- sic_5d %>% add_column(sic_level = "5")

sic_4d <- sic_base %>% select("sic07_4digit", "sic07_4digit_name")
sic_4d <- sic_4d[!duplicated(sic_4d), ]
sic_4d <- rename(sic_4d, sic_code = sic07_4digit, sic_name = sic07_4digit_name)
sic_4d <- sic_4d %>% add_column(sic_level = "4")

sic_3d <- sic_base %>% select("sic07_3digit", "sic07_3digit_name")
sic_3d <- sic_3d[!duplicated(sic_3d), ]
sic_3d <- rename(sic_3d, sic_code = sic07_3digit, sic_name = sic07_3digit_name)
sic_3d <- sic_3d %>% add_column(sic_level = "3")

sic_2d <- sic_base %>% select("sic07_2digit", "sic07_2digit_name")
sic_2d <- sic_2d[!duplicated(sic_2d), ]
sic_2d <- rename(sic_2d, sic_code = sic07_2digit, sic_name = sic07_2digit_name)
sic_2d <- sic_2d %>% add_column(sic_level = "2")

sic_1d <- sic_base %>% select("sic07_sl", "sic07_sl_name")
sic_1d <- sic_1d[!duplicated(sic_1d), ]
sic_1d <- rename(sic_1d, sic_code = sic07_sl, sic_name = sic07_sl_name)
sic_1d <- sic_1d %>% add_column(sic_level = "1")

sic_all <- bind_rows(sic_1d, sic_2d, sic_3d, sic_4d, sic_5d)

# Create Sector Year Grids ------------------------------------------------

sy_grid_5d <- sic_5d %>% expand(sic_code, year)
write_csv(sy_grid_5d, "./output/sy_grid_5d.csv")

sy_grid_4d <- sic_4d %>% expand(sic_code, year)
write_csv(sy_grid_4d, "./output/sy_grid_4d.csv")

sy_grid_3d <- sic_3d %>% expand(sic_code, year)
write_csv(sy_grid_3d, "./output/sy_grid_3d.csv")

sy_grid_2d <- sic_2d %>% expand(sic_code, year)
write_csv(sy_grid_2d, "./output/sy_grid_2d.csv")

sy_grid_1d <- sic_1d %>% expand(sic_code, year)
write_csv(sy_grid_1d, "./output/sy_grid_1d.csv")

# Create Full Region Sector Year Grid (Master Grid) ----------------------

sic_all_y <- sic_all %>% expand(sic_code, year) %>% inner_join(sic_all)
sic_all_r <- sic_all %>% expand(sic_code, nuts_all) %>% inner_join(sic_all)
rsy_grid_named <- sic_all_y %>% right_join(sic_all_r)
rsy_grid_named <- rsy_grid_named[, c(5, 6, 7, 1, 3, 4, 2)]

write_csv(rsy_grid_named, "./output/rsy_grid_named.csv")

rsy_grid <- rsy_grid_named %>%
  select("nuts_code", "sic_code", "year", "nuts_level", "sic_level")

write_csv(rsy_grid, "./output/rsy_grid.csv")