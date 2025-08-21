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

# Installer les packages manquants
# installed_pkgs <- rownames(installed.packages())
# for (pkg in required_packages) {
#   if (!pkg %in% installed_pkgs) install.packages(pkg)
# }

# Charger tous les packages
invisible(lapply(required_packages, library, character.only = TRUE))
