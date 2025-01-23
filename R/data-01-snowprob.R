# read in GMBA data Simon

library(dplyr)
library(readr)
library(tidyr)
library(magrittr)
library(stringr)
library(purrr)

# data all elev -----------------------------------------------------------

tbl_in <- read_csv("data-raw/snowProba_00009000_20002023.csv")

tbl_all <- tbl_in %>% 
  mutate(across(means:years, 
                \(x) x %>% 
                  str_remove(fixed("[")) %>% 
                  str_remove(fixed("]")) )) %>% 
  separate_longer_delim(means:years, ",") %>% 
  mutate(across(means:years, as.numeric))

tbl_clim_full <- tbl_in %>% select(GMBA_V2_ID, count, snowprob_clim = mean)

saveRDS(tbl_clim_full, "data/snowprob-01-clim-full.rds")

tbl_clim20 <- tbl_all %>% 
  filter(years %in% c(2001:2020)) %>% 
  group_by(GMBA_V2_ID) %>% 
  summarise(snowprob_clim20 = mean(means))

tbl_annual <- tbl_all %>% 
  left_join(tbl_clim20)


saveRDS(tbl_annual, "data/snowprob-02-clim20-annual.rds")



