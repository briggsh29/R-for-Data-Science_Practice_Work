# Ch 13 Numbers - Transform 

library(tidyverse)
library(nycflights13)

# 13.2 Making Numbers 

# 13.3 Counts

flights |>  count(dest)
# look at most common values 
flights |> count(dest, sort = TRUE)

# argument of 'n'
flights |> 
  group_by(dest) |> 
  summarize(
    n = n(),
    delay = mean(arr_delay, na.rm = TRUE)
  )
# n --- special summary function
#      does not take arguments 
#      it accessess info about 'current' group

# n_distinct(x) counts number distinct (unique value)
flights |> 
  group_by(dest) |> 
  summarize(carriers = n_distinct(carrier)) |> 
  arrange(desc(carriers))

# weighted count is a sum
flights |> 
  group_by(tailnum) |> 
  summarize(miles = sum(distance))

# weighted count() has wt argument to do this
flights |> 
  count(tailnum, wt = distance)

# count missing values by combine sum and is.na
flights |> 
  group_by(dest) |> 
  summarize(n_cancelled = sum(is.na(dep_time)))

# 13.4 Numeric Transformations

# 13.5 General Transformations
x <- c(1, 5, 5, 17, 22, NA)
min_rank(x)

# variants -- row_number, dense_rank, percent_rank, cume_dist
df <- tibble(x = x)
df |> 
  mutate(
    row_number = row_number(x),
    dense_rank = dense_rank(x),
    percent_rank = percent_rank(x),
    cume_dist = cume_dist(x)
  )