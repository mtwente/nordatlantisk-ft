# Setup -----
## Packages -----

library(here)
library(ggplot2)
library(dplyr)

## Read Data -----

northatlantic_ft <- readRDS(here("data", "processed", "northatlantic_ft.rds"))

MPnames <- read.csv(here("data", "processed", "csv", "MP_names.csv"))

## Manipulate Data -----

northatlantic_ft_without_absences <- subset(northatlantic_ft, vote_type_id != 3)

# Plotting Votes Per MP -----

plot_votes <- ggplot(northatlantic_ft, aes(x = MP_id, fill = vote_type_id)) +
  geom_bar() +
  
  scale_x_discrete(
  ) +
  
  scale_fill_manual(
    name = "Vote",
    labels = c("for", "against", "absence", "abstention"),
    values = c("#6195CF", "#F7CB45", "#D1BBD7", "#777777")
  ) +
  
  coord_flip()

pdf(file = here("build", "vote_per_MP.pdf"))
print(plot_votes)
dev.off()

# Plotting Votes Per MP, without absences -----

plot_votes_without_absences <- ggplot(northatlantic_ft_without_absences, aes(x = MP_id, fill = vote_type_id)) +
  geom_bar() +
  
  scale_x_discrete(
  ) +
  
  scale_fill_manual(
    name = "Vote",
    labels = c("for", "against", "abstention"),
    values = c("#6195CF", "#F7CB45", "#777777")
  ) +
  
  coord_flip()

pdf(file = here("build", "vote_per_MP_without_absences.pdf"))
print(plot_votes_without_absences)
dev.off()


# Ploting Votes Over Time -----

scatterplot <- ggplot(northatlantic_ft, aes(x = ballot_date, y = MP_id, color = vote_type_id)) +
  geom_point() +
  
  scale_y_discrete(
    ) +
  
  scale_color_manual(
    name = "Vote",
    labels = c("for", "against", "absence", "abstention"),
    values = c("#6195CF", "#F7CB45", "#D1BBD7", "#777777")
  )

pdf(file = here("build", "scatterplot.pdf"))
print(scatterplot)
dev.off()

# Ploting Votes Over Time, Without Absences -----

scatterplot_without_absences <- ggplot(northatlantic_ft_without_absences, aes(x = ballot_date, y = MP_id, color = vote_type_id)) +
  geom_point() +
  
  scale_y_discrete(
  ) +
  
  scale_color_manual(
    name = "Vote",
    labels = c("for", "against", "abstention"),
    values = c("#6195CF", "#F7CB45", "#777777")
  )

pdf(file = here("build", "scatterplot_without_absences.pdf"))
print(scatterplot_without_absences)
dev.off()