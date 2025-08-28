# packages.R

# Liste des packages nécessaires pour l'application
required_packages <- c(
  "shiny",
  "shinydashboard",
  "dplyr",
  "tidyr",
  "purrr",
  "stringr",
  "forcats",
  "lubridate",
  "htmltools",
  "patchwork",
  "plotly",
  "sf",
  "leaflet",
  "leaflet.extras")


# Charger tous les packages
invisible(lapply(required_packages, library, character.only = TRUE))
