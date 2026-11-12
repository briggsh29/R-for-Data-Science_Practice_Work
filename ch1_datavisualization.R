# Chapter 1 Data Visualization

library(tidyverse)
library(ggthemes)
library(palmerpenguins)

# Look at palmer penguins data frame

peng <- palmerpenguins::penguins

peng |> 
  ggplot()
# blank - didn't tell R how to visualize data 

peng |> 
  ggplot(
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )
# did not tell R how to display the data 
# need geom --- geometrical object used to rep data 

peng |> 
  ggplot(
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_point()
# scatter plot
# warning message on missing values 

# Add aesthetics and layers to plot 

peng |> 
  ggplot(
    mapping = aes(x = flipper_length_mm, 
                  y = body_mass_g, 
                  color = species)
  ) + 
  geom_point()
# adding unique color to unique levels of variable 'species'

# global verus local level for ggplot arguments 
# difference between the two below graphs 
# note that lm stands for linear model

# global color species argument
peng |> 
  ggplot(
    mapping = aes(x = flipper_length_mm, 
                  y = body_mass_g, 
                  color = species)
  ) + 
  geom_point() +
  geom_smooth(method = "lm")

# local color species argument (color only applied to point)
peng |> 
  ggplot(
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) + 
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm")

# can also add something like shape or change color scheme 

# Adding better labels and color blind scheme 
peng |> 
  ggplot(
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) + 
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm") + 
  labs(
    title = "Body Mass and Flipper Length",
    subtitle = "Dimensions for Adelie, Chinstrap, Gentoo Penguins",
    x = "flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "species"
  ) + 
  scale_color_colorblind()

# 1.5 Visualizing Relationships 

# box and whisker plots 
peng |> 
  ggplot(
    aes(x = species, y = body_mass_g)
  ) + 
  geom_boxplot()

# Density plots 
peng |> 
  ggplot(
    aes(x = body_mass_g, color = species)
  ) +
  geom_density(linewidth = 0.75)
# fill aesthetic 
peng |> 
  ggplot(
    aes(x = body_mass_g, color = species, fill = species)
  ) +
  geom_density(alpha = 0.5)

# 1.6 Saving Plots --- ggsave()

peng |> 
  ggplot(
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) + 
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm") + 
  labs(
    title = "Body Mass and Flipper Length",
    subtitle = "Dimensions for Adelie, Chinstrap, Gentoo Penguins",
    x = "flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "species"
  ) + 
  scale_color_colorblind()
ggsave(filename = "penguin-plot.png")
