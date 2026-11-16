
# Ch 11 Communication - Visualize

library(tidyverse)
library(scales)
library(ggrepel)
library(patchwork)
library(hexbin)

# 11.2 Labels

# labs() function

cars <- mpg

cars |> 
  ggplot(aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    color = "car type",
    title = "fuel efficiency generally decreases with car engine size",
    subtitle = "two seaters (sports cars) exception with light weight",
    caption = "data from fueleconomy.gov"
  )

# subtitle adds more info under main title 
# caption adds text to bottom right (source)

# also possibel to use mathematical equations instead of text strings
# read about available options in ?plotmath
# switch out " for quote()

df <- tibble(
  x = 1:10,
  y = cumsum(x^2)
)

df |> 
  ggplot(aes(x, y)) +
  geom_point() +
  labs(
    x = quote(x[i]),
    y = quote(sum(x[i]^2, i == 2, n))
  )

## 11.3 Annotations 

# geom_text --- similar to geom_point but with additional aesthetic, label
#     two possible sources for 'labels'
#     tibble that provides labels - ex

# pull out cars with highest engine size in each drive type adn save as new df

label_info <- cars |> 
  group_by(drv) |> 
  arrange(desc(displ)) |> 
  slice_head(n=1) |> 
  mutate(
    drive_type = case_when(
      drv == "f" ~ "front-wheel drive",
      drv == "r" ~ "rear-wheel drive",
      drv == "4" ~ "4-wheel drive"
    )
  ) |> 
  select(displ, hwy, drv, drive_type)

label_info
# use this new df to directly label the 3 groups to replace the legend

cars |> 
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_text(
    data = label_info,
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, hjust = "right", vjust = "bottom"
  ) + 
  theme(legend.position = "none")
# slightly hard to read b/c of labels overlap

# geom label repel function
cars |> 
ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_label_repel(
    data = label_info, 
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, nudge_y = 2
  ) +
  theme(legend.position = "none")

# want to highlight certian points on plot?
potential_outliers <- cars|>
  filter(hwy > 40 | (hwy > 20 & displ > 5))

ggplot(cars, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_text_repel(data = potential_outliers, aes(label = model)) +
  geom_point(data = potential_outliers, color = "red") +
  geom_point(
    data = potential_outliers,
    color = "red", size = 3, shape = "circle open"
  )

# other functions to annotate plot 
###     geom_hline and geom_vline --- adding reference lines 
###     geom_rect --- draw rectangle around points of interest 
###     geom_segment -- arrow to draw attention to point 


# annotate function
#     geom (useful highlight subset), annotate (useful to add one or few annotations)

#stringr - auto add line breaths, characters per line
trend_text <- "Larger engine sizes tend to have lower fuel economy." |>
  str_wrap(width = 30)
trend_text

# add two layers annotations - label geom, segment geom
ggplot(cars, aes(x = displ, y = hwy)) +
  geom_point() +
  annotate(
    geom = "label", x = 3.5, y = 38,
    label = trend_text,
    hjust = "left", color = "red"
  ) +
  annotate(
    geom = "segment",
    x = 3, y = 35, xend = 5, yend = 25, color = "red",
    arrow = arrow(type = "closed")
  )


# 11.4 Scales 
#         adjust how aesthetic mappings manifest 
# two arguments that affect ticks on axes and keys
#    breaks and labels 
#    control position of ticks or values assoc with keys

cars |> 
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by 5))

# can also use to control appearance of legends 
cars |> 
ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL) +
  scale_color_discrete(labels = c("4" = "4-wheel", "f" = "front", "r" = "rear"))

# labels argument - format (currency, percent numbers...)
# adding $ and K
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(
    labels = label_dollar(scale = 1/1000, suffix = "K"), 
    breaks = seq(1000, 19000, by = 6000)
    
# label percent 
ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill") +
  scale_y_continuous(name = "Percentage", labels = label_percent())
  )

# If you want to control legend use theme()
ggplot(cars, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 2, override.aes = list(size = 4)))

# Other scales 
# The ColorBrewer scales are documented online at https://colorbrewer2.org/ 
#       and made available in R via the RColorBrewer package
presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))

# Other option --- using viridis color scales 
#     avail as discrete(d), continuous(c), and binned(b) palettes

df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)


ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  labs(title = "Default, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_c() +
  labs(title = "Viridis, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_b() +
  labs(title = "Viridis, binned", x = NULL, y = NULL)

# ZOOMING - control plot lines 
# three ways 
###### 1 - adjust what data plotted 
###### 2 - setting limits in each scale 
###### 3 - setting xlim and ylim in coord_cartesian


# 11.5 Themes 
#ggplot2 includes the eight themes shown in Figure 11.2, 
#       with theme_gray() as the default.2 
#       Many more are included in add-on packages like ggthemes (https://jrnold.github.io/ggthemes)


# 11.6 Layout 
#   patchwork package 
#   combine separate plots into same graphic 

p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 1")
p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
  geom_boxplot() + 
  labs(title = "Plot 2")
p1 + p2

p3 <- ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 3")
(p1 | p3) / p2

# also lets you collect legends from mult plots into common legend 
p1 <- ggplot(mpg, aes(x = drv, y = cty, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 1")

p2 <- ggplot(mpg, aes(x = drv, y = hwy, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 2")

p3 <- ggplot(mpg, aes(x = cty, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 3")

p4 <- ggplot(mpg, aes(x = hwy, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 4")

p5 <- ggplot(mpg, aes(x = cty, y = hwy, color = drv)) + 
  geom_point(show.legend = FALSE) + 
  facet_wrap(~drv) +
  labs(title = "Plot 5")

(guide_area() / (p1 + p2) / (p3 + p4) / p5) +
  plot_annotation(
    title = "City and highway mileage for cars with different drive trains",
    caption = "Source: https://fueleconomy.gov."
  ) +
  plot_layout(
    guides = "collect",
    heights = c(1, 3, 2, 4)
  ) &
  theme(legend.position = "top")