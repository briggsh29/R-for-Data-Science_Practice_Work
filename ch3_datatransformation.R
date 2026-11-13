library(tidyverse)
library(dplyr)
library(nycflights13)

flights <- nycflights13::flights

#### Filter function -- keep rows based on values of columns

flights |> 
  filter(dep_delay > 120)

flights |> 
  filter(month == 1 & day == 1)

#flights from Jan OR Feb
flights |> 
  filter(month == 1 | month == 2)
# same thing - keep obs with one of the values on right
flights |> 
  filter(month %in% c(1,2))

##### Arrange function, changes order of rows based on columns

flights |> 
  arrange(year, month, day, dep_time)
# descending order
flights |> 
  arrange(desc(dep_delay))

#### Distinct function - finds all unique rows

flights |> 
  distinct()
#unique origin and destination pairs 
flights |> 
  distinct(origin, dest)
# keep all columns when filtering
flights |> 
  distinct(origin, dest, .keep_all = TRUE)
# sort order 
flights |> 
  count(origin, dest, sort = TRUE)


# 3.3 Columns (mutate, select, rename, relocate)

#### Mutate --- adding new columns calc from existing

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )
# default adds new columns to right side

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

# control what variables are kept with keep argument
# ex - keeping columns 'used' involved in mutate step

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .keep = "used"
  )

##### Select function - focus on select variables

flights |> 
  select(year, month, day)

# inclusive argument
flights |> 
  select(year:day)

# select character var
flights |> 
  select(where(is.character))

#starts with or ends with or contains or num_range
flights |> 
  select(starts_with("a"))

# can rename with select 
flights |> 
  select(tail_num = tailnum)

###### Rename --- want to keep existing but rename a few

flights |> 
  rename(tail_num = tailnum)
# janitor clean names option

flights |> 
  janitor::clean_names()


# 3.5 Groups ----- group by and summarize 


##### Group By -- divide dataset into meaningful groups
# does not change data but look at output
flights |> 
  group_by(month)
# changes behavior of subsequent verbs 

##### Ex Summarize 

#reduces data frame for each group
# BUT WAIT, missing values exist 
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay)
  )

flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  )

# useful argument n ---- returns number rows each group
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )

##### Slice Function   -- extract specific rows within group





