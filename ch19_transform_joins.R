# Ch 19 Joins 

# two types of joins
# mutating joins
#     add new variables to one data frame from matching obs in another
# filtering joins 
#     filter obs from one data frame based on whether they match obs in another

library(tidyverse)
library(nycflights13)

# 19.2 Keys

# primary key -- unique ID each obs 
# compound key -- more than one variable is needed 

# airlines data - two pieces of data
#    carrier code and full name 
#    make primary key
airlines

# airports data -- data on airport, 3 letter airport code
#    faa primary key
airports

# planes data -- tail number
#     tailnum primary key
planes

# weather data -- at origin airport
#    origin and time_hour compound key
weather

# foreign key -- a variable or set of that corresponds to primary key in another table

#     flights$tailnum foreign key, corresponds to primary key planes$tailnum
#     flights$carrier foreign key, corr to primary key airlines$carrier
#     flights$origin foreign key, corr to primary key airports$faa
#     flights$origin and flights$time_hour is compound foreign key
#         corr to compound primary key weather$origin and weather$time_hour

# checking primary keys
#    verify that they uniquely ID each obs 
#    that n does not equal greater than 1

# can use count primary keys, 
planes |> 
  count(tailnum) |> 
  filter(n > 1)

weather |> 
  count(time_hour, origin) |> 
  filter(n > 1)

# check missing values in primary keys
planes |> 
  filter(is.na(tailnum))

weather |> 
  filter(is.na(time_hour) | is.na(origin))

# 19.3 Basic Joins

# left, inner, right, full, semi, anti

# MUTATING JOINS 
#      combo var from 2 df
flights2 <- flights |> 
  select(year, time_hour, origin, dest, tailnum, carrier)
flights2

# LEFT JOIN -- same rows as x, add in additional metadata 
#    ex use left_join to add full airline name to flights2 data
flights2
airlines

flights2 |> 
  left_join(airlines)

#    add in temp and wind speed when plane departed 
flights2 |> 
  left_join(weather |> select(origin, time_hour, temp, wind_speed))

# if left join fails to match a row to x
#    fills in new var with missing NA

#  specify join key? 
#    auto - natural join, does not always work
# JOIN_BY
#    join_by(tailnum) short by joint_by(tailnum == tailnum)

flights2 |> 
  left_join(airports, join_by(dest == faa))

#    right_join --- keeps all rows in y
#    full_join --- all rows in either x or y
#    inner_join --- rows that occur in both x and y


# FILTERING JOINS

#   semi and anti joins 

# semi --- keep all rows in x that have match in y
#   ex use to filter airports data to show just origin airports
airports |> 
  semi_join(flights2, join_by(faa == origin))

# anti ---- return all rows in x that don't have match in y
#  useful for finding missing value that implicit in data 

#     ex find rows that are missing from airports, looking for flights
#        that don't have matching destination airport
flights2 |> 
  anti_join(airports, join_by(dest == faa)) |> 
  distinct(dest)

# 19.4 How do Joins Work
