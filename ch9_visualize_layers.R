library(tidyverse)
library(ggplot2)

#data frame - car models
cars <- mpg

# variables:
#    displ - car engine size, liters, number
#    hwy - fuel efficiency on highway, mpg, number
#    class - type of car, categorical
cars |> 
  select(displ, hwy, class)

cars |> 
  ggplot(
    aes(x = displ, y = hwy, color = class)
  ) +
  geom_point()

cars |> 
  ggplot(
    aes(x = displ, y = hwy, shape = class)
  ) +
  geom_point()

# using something alpha, implies order - there is no order to class
cars |> 
  ggplot(
    aes(x = displ, y = hwy, alpha = class)
  ) +
  geom_point()

# you can set visual properties of geom manually
cars |> 
  ggplot(
    aes(x = displ, y = hwy)
  ) +
  geom_point(color = "blue")


# 9.3 Geometric Objects 

cars |> 
  ggplot(
    aes(x = displ, y = hwy)
  ) +
  geom_smooth()

# difficult to change shape of line but line type?
cars |> 
  ggplot(
    aes(x = displ, y = hwy, linetype = drv)
  ) +
  geom_smooth()

# this can be easier to read when overlaid on data 

cars |> 
  ggplot(
    aes(x = displ, y = hwy, color = drv)
  ) +
  geom_point() +
  geom_smooth(aes(linetype = drv))


# remember local vs global arguments for layers

cars |> 
  ggplot(
    aes(x = displ, y = hwy)
  ) +
  geom_point(aes(color = class)) +
  geom_smooth()

# fun new package for ridgeline plots 
library(ggridges)

cars |> 
  ggplot(
    aes(x = hwy, y = drv, fill = drv, color = drv)
  ) +
  geom_density_ridges(alpha = 0.5, show.legend = FALSE)


# 9.4 Facets 

cars |> 
  ggplot(
    aes(x = displ, y = hwy)
  ) +
  geom_point() +
  facet_wrap(~cyl)

# if you want to facet plot with combo of two var
# switch to facet_grid (double sided formula)

cars |> 
  ggplot(
    aes(x = displ, y = hwy)
  ) +
  geom_point() +
  facet_grid(drv ~ cyl)

# be default they all share same scale and range
# can change with free y, free x, or free (for both)


# 9.5 Statistical Transformation

diamonds |> 
  ggplot(aes(x = cut)) +
  geom_bar()
# gasp, count is not a variable in this dataset
# bar charts plot new values, bin counts
# the stat they use for this can be overridden


# 9.6 Position Adjustments 

cars |> 
  ggplot(aes(x = drv, fill = drv)) +
  geom_bar()

# what happens if fill with other variable?

cars |> 
  ggplot(aes(x = drv, fill = class)) +
  geom_bar()
# they auto stack
# decided with position argument
# options for identity, dodge, or fill

#identity
cars |> 
  ggplot(aes(x = drv, fill = class)) +
  geom_bar(alpha = 1/5, position = "identity")
# versus
cars |> 
  ggplot(aes(x = drv, color = class)) +
  geom_bar(fill = NA, position = "identity")

# fill - like stacking, but all bars same height
#       easy to see proportion
cars |> 
  ggplot(aes(x = drv, fill = class)) +
  geom_bar(position = "fill")

# dodge
cars |> 
  ggplot(aes(x = drv, fill = class)) +
  geom_bar(position = "dodge")

# 9.7 Coordinate System
library(maps)
nz <- map_data("nz")

nz |> 
  ggplot(aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

nz |> 
  ggplot(aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()



