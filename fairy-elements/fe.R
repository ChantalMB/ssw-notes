library(plotly)
library(dplyr)

library(tidyverse)

fe  <- read_csv("fairy-elements.csv")

View(fe)

eft <- fe %>%
  count(ElfFairy_Type, sort = TRUE)

View(eft)

com <- fe %>%
  count(Causeofmalice, sort = TRUE)

com <- com %>%
  filter(Causeofmalice != "NULL")

View(com)

mt <- fe %>%
  count(Motif_Type, sort = TRUE)

View(mt)

rot <- fe %>%
  count(RitualObject_Type, sort = TRUE)

View(rot)


library(ggplot2)
library(ggiraph)

rot$text <- paste(rot$RitualObject_Type, "= ", rot$n)

# Horizontal version
data <- data.frame(
  x=rot$RitualObject_Type,
  y=rot$n
)

# Horizontal version
p <- ggplot(data, aes(x=x, y=y)) +
  geom_segment( aes(x=x, xend=x, y=0, yend=y), color="deeppink1") +
  geom_point_interactive(color="deeppink3", size=3, alpha=0.6, tooltip = rot$text) +
  labs(x=NULL, y="Count", title="Frequency of Recorded Ritual Objects") + 
  theme_light() +
  coord_flip() +
  scale_y_continuous(breaks = seq(0, 100, by = 2)) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.border = element_blank(),
    axis.ticks.y = element_blank(),
    plot.title = element_text(size=11, hjust = 0.5),
    axis.title.x = element_text(size=9, hjust = 0.5, vjust=-2.3),
    axis.title.y = element_text(hjust = 50)
  )

tooltip_css <- "background-color:transparent;font-style:italic;font-family:Arial;"

widg <- ggiraph(ggobj = p, width_svg = 9.5, height_svg = 4.5, code = {print(p)}, tooltip_extra_css = tooltip_css)
widg

library(htmlwidgets)
saveWidget(widg, file=paste0( getwd(), "/rot.html"))
