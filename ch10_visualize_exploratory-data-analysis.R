# The iterative cycle of EDA
# generate questions about data
# search for answers - visualize, transform, model
# use what you learned to refine question/gen new question

library(tidyverse)

# 10.3 Variation

diamonds |> 
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.5)

# looking at the distribution of smaller diamonds 

smaller <- diamonds |> 
  filter(carat < 3)

smaller |> 
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.01)
# there are more diamonds at whole carats or common fractions of carats 
# ID clusters

### Unusual values - outliers 

diamonds |> 
  ggplot(aes(x = y)) + 
  geom_histogram(binwidth = 0.5)
# evidence of outliers is the unusually wide limits on the x-axis

# can zoom to small values with coord_cart
diamonds |> 
  ggplot(aes(x = y)) + 
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
# we can see three unusual - around 0, 30, 60

# pick them out 
unusual <- diamonds |> 
  filter(y < 3 | y > 20) |> 
  select(price, x, y, z) |> 
  arrange(y)
unusual

# What to do?
# drop?
# replace with missing?

diamonds2 <- diamonds |> 
  mutate(y = if_else(y < 3 | y > 20, NA, y))

# 10.5 Covariation --- behavior between variables 

# price of diamond varying with quality 

diamonds |> 
  ggplot(aes(x = price)) +
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth =  0.75)

# instead of count - density, area under frequ standardized to 1
diamonds |> 
  ggplot(aes(x = price, y = after_stat(density))) +
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)
# after stat? density is not a variable in df
# first need to calculate

# this plot would suggest higher price for lower quality diamonds?

# maybe a more simple plot?

diamonds |> 
  ggplot(aes(x = cut, y = price)) +
  geom_boxplot()
#this says better quality cheaper?
# why?


# Two Categorical Variables 
#     count number obs for each combo of categories 

diamonds |> 
  ggplot(aes(x = cut, y = color)) + 
  geom_count()

# Alt
diamonds |> 
  count(color, cut)
# then visualize with tile 
diamonds |> 
  count(color, cut) |> 
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n))


# 10.6 Patterns and Models 
#      could this pattern be random chance?
#      how strong is rx described by pattern?
#      what other variables affect the relationship?

# model that predicts price from carat, and computes residuals 
#     (the difference between predicted value and actual value)
#    log transform, then fit - exponentiate residuals to put back on scale


library(tidymodels)

diamonds <- diamonds |> 
  mutate(
    log_price = log(price),
    log_carat = log(carat)
  )

diamonds_fit <- linear_reg() |> 
  fit(log_price ~ log_carat, data = diamonds)

diamonds_aug <- augment(diamonds_fit, new_data = diamonds) |> 
  mutate(.resid = exp(.resid))

diamonds_aug |> 
  ggplot(aes(x = carat, y = .resid)) +
  geom_point()
# we removed the strong relationship between carat and price
# can now see that relative to size, better quality diamonds are more expensive

diamonds_aug |> 
  ggplot(aes(x = cut, y = .resid)) +
  geom_boxplot()