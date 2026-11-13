library(tidyverse)

# Options to read in data 
students <- read_csv("https://pos.it/r4ds-students-csv")

# Look at data and NA values 
# Tell R to code as missing when reading 

students <- read_csv("https://pos.it/r4ds-students-csv", 
                     na = c("N/A", ""))

# notice naming structure of Student ID and Full Name 

clean_students <- students |> 
  janitor::clean_names()

# Now consider variable types 
# Meal plan is a character variable but should be rep by categor/'factor'
# also fix the age column (one value is 'five')

clean_students |> 
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
    )
#function of if_else, logic statement - if 'yes' pass to second argu

#### Playing with read_csv

read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)
# tell R not to treat first row as col names 
read_csv(
  "a,b,c
  1,2,3
  4,5,6",
  col_names = FALSE
)

# could pass on col names 
read_csv(
  "a,b,c
  1,2,3
  4,5,6",
  col_names = c("X", "Y", "Z")
)


# 7.3 Controlling Column Types 

# 7.5 Writing a file 

write_csv(clean_students, "students.csv")

