# -------------------------------------------------------------------
# Script de préparation de l'environnement R avec renv
# À placer dans le dossier "app/"
# -------------------------------------------------------------------

# Étape 1 : Installer renv si nécessaire
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

# Étape 2 : Initialiser renv s’il n’est pas déjà actif
if (!file.exists("renv.lock")) {
  renv::init(bare = TRUE)
}

# Étape 3 : Définir la liste des packages à installer
required_packages <- c(
  "dplyr", "tidyr", "purrr", "stringr", "forcats", "lubridate",
  "htmltools", "hubeau", "janitor", "knitr", "leaflet", "leaflet.extras",
  "openxlsx2", "patchwork", "plotly", "sf", "shiny", "shinydashboard",
  "pkgload", "here", "munsell", "vroom", "readxl"
)

# Étape 4 : Installer les packages manquants
missing <- setdiff(required_packages, rownames(installed.packages()))
if (length(missing) > 0) {
  install.packages(missing)
}

# Étape 5 : Charger les packages (déclenche les erreurs si un problème existe)
invisible(lapply(required_packages, library, character.only = TRUE))

# Étape 6 : Snapshot pour enregistrer l’état de l’environnement
renv::snapshot(prompt = FALSE)

cat("✅ Environnement renv prêt. ")
