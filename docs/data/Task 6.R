
# Load the necessary packages, use install.packages if not yet installed
#install.packages("tidyverse")

library(tidyverse)

#set a minimal theme for ggplot visuals
theme_set(theme_minimal())

# in the following code, only change the location of your "watch-history.json"
yt_data <-
  
  #read in the json file
  jsonlite::fromJSON("Workshop/data/Data for Task 6.json") |>
  
  #reformat it to a tibble for compability with tidyverse
  as_tibble() |>
  
  #reduce to relevant variables
  select(title, titleUrl, time, subtitles) |>
  
  #reformat and rename some variables
  unnest(subtitles) |>
  rename(title_url = titleUrl, channel = name, channel_url = url) |>
  mutate(
    timestamp = lubridate::as_datetime(time),
    day = as.Date(timestamp),
    hour = lubridate::hour(timestamp),
    weekday = lubridate::wday(timestamp, label = TRUE, week_start = 1),
    .keep = "unused"
  )

#inspect your data
View(yt_data)

# On which day do you mostly watch YouTube?
yt_data %>%
  count(weekday) %>%
  ggplot(aes(x = weekday, y = n)) +
  geom_col(fill = "#539FC6") +
  labs(title = "YouTube videos viewed per day of the week")

# At what time do you mostly watch YouTube?
yt_data %>%
  count(hour) %>%
  ggplot(aes(x = hour, y = n)) +
  geom_col(fill = "#539FC6") +
  labs(title = "YouTube videos viewed per hour of day")