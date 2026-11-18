# 12 Transform - Logical Vectors 

library(tidyverse)
library(nycflights13)

# making up dummy data
x <- c(1, 2, 3, 5, 7, 11, 13)
x * 2

# any manipulation you do to a vector, 
#    you can do to variable inside df with mutate etc

df <- tibble(x)
df
df |> 
  mutate(y = x * 2)

# 12.2 Comparisons

# common way to create logical vector, num comparison
flights |> 
  filter(dep_time > 600 & dep_time < 2000 & abs(arr_delay) < 20)

# do the same thing, longer but more explicit with mutate
flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time < 2000,
    approx_ontime = abs(arr_delay) < 20,
    .keep = "used"
  )

# missing values - contagious in operations 
flights |> 
  filter(is.na(dep_time))

# 12.3 Boolean algebra 

### Order of Operations 
#### finding flights either in November or December
flights |> 
  filter(month == 11 | month == 12)
# what if you tried to write it like this
flights |> 
  filter(month == 11 | 12)

# avoid with %in%
##### this returns a logical vector same length as 'x' that is true
# whenever value of 'x' is anywhere in 'y'

1:12 %in% c(1, 5, 11)
# relate to flight info Nov and Dec
flights |> 
  filter(month %in% c(11, 12))

# also obeys different rules for NA
c(1, 2, NA) %in% NA

flights |> 
  filter(dep_time %in% c(NA, 0800))

# 12.4 Summaries 
##### tech for summarizing logical vectors 

#    any()     all()

flights |> 
  group_by(year, month, day) |> 
  summarize(
    all_delayed = all(dep_delay <= 60, na.rm = TRUE),
    any_long_delay = any(arr_delay >= 300, na.rm = TRUE),
    .groups = "drop"
  )

# numerical summaries of logical vectors 
flights |> 
  group_by(year, month, day) |> 
  summarize(
    proportion_delayed = mean(dep_delay <= 60, na.rm = TRUE),
    count_long_delay = sum(arr_delay >= 300, na.rm = TRUE),
    .groups = "drop"
  )

# logical subsetting
flights |> 
  filter(arr_delay > 0) |> 
  group_by(year, month, day) |> 
  summarize(
    behind = mean(arr_delay),
    n = n(),
    .groups = "drop"
  )

# 12.5 Conditional transformations

#### if_else

# first argument condition, 
#        output when condition true, 
#        output if condition false
x <- c(-3:3, NA)
if_else(x > 0, "+ve", "-ve")

#### case_when

# condition ~ output 
#  condition must be logical vector 
x <- c(-3:3, NA)
case_when(
  x == 0   ~ "0",
  x < 0    ~ "-ve", 
  x > 0    ~ "+ve",
  is.na(x) ~ "???"
)

###  can use variables on both sides of the ~
# example - use to provide readable labels for arrival delay
flights |> 
  mutate(
    status = case_when(
      is.na(arr_delay)      ~ "cancelled",
      arr_delay < -30       ~ "very early",
      arr_delay < -15       ~ "early",
      abs(arr_delay) <= 15  ~ "on time",
      arr_delay < 60        ~ "late",
      arr_delay < Inf       ~ "very late",
    ),
    .keep = "used"
  )

### compatible types, otherwise error
#    numeric and logical compatible 
#    strings and factors compatible 
#    dates and times compatible 
