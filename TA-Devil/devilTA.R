library(tidyverse)
library(tidytext)

devil  <- read_csv("devil.csv")

View(devil)

dtxt <- tibble(text = devil$Devil_Text)
dtype <- tibble(text = devil$Devil_Type)
dnotes <- tibble(text = devil$FolkNotes)

dtxt <- drop_na(dtxt)
dtype <- drop_na(dtype)
dnotes <- drop_na(dnotes)

tidy_dtxt <- dtxt %>%
  unnest_tokens(word, text)

tidy_dtype <- dtype %>%
  unnest_tokens(word, text)

tidy_dnotes <- dnotes %>%
  unnest_tokens(word, text)

data(stop_words)

tidy_dtxt <- tidy_dtxt %>%
  anti_join(stop_words)

tidy_dtype <- tidy_dtype %>%
  anti_join(stop_words)

tidy_dnotes <- tidy_dnotes %>%
  anti_join(stop_words)

dtxt_words <- tidy_dtxt %>%
  count(word, sort = TRUE)

dtype_words <- tidy_dtype %>%
  count(word, sort = TRUE)

dnotes_words <- tidy_dnotes %>%
  count(word, sort = TRUE)

head(dtxt_words)
head(dtype_words)
head(dnotes_words)

# visual- circle-packing

# libraries
library(packcircles)
library(ggplot2)
library(viridis)
library(ggiraph)

# Create data
data <- data.frame(word=dnotes_words$word, value=dnotes_words$n) 

data <- data %>%
  filter(value > 5)

View(data)
# Add a column with the text you want to display for each bubble:
data$text <- paste("Word: ",data$word, "\n", "Count:", data$value, "\n")

# Generate the layout
packing <- circleProgressiveLayout(data$value, sizetype='area')
data <- cbind(data, packing)
dat.gg <- circleLayoutVertices(packing, npoints=50)

# Make the plot with a few differences compared to the static version:
p <- ggplot() + 
  geom_polygon_interactive(data = dat.gg, aes(x, y, group = id, fill=id, tooltip = data$text[id], data_id = id), colour = "white", alpha = 0.6) +
  scale_fill_viridis() +
  geom_text(data = data, aes(x, y, size=value, label = word), color="white") +
  scale_size_continuous(range = c(1,4)) +
  theme_void() + 
  theme(legend.position="none", plot.margin=unit(c(0,0,0,0),"cm") ) + 
  coord_equal()

# Turn it interactive
widg <- ggiraph(ggobj = p, width_svg = 7, height_svg = 7)
widg

# save the widget
library(htmlwidgets)
saveWidget(widg, file=paste0( getwd(), "/devil_notes.html"))


