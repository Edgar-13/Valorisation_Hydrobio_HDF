packages_necessaires <- c("dplyr", "sf","leaflet")

installer_et_charger_packages <- function(packages) {
  installes <- rownames(installed.packages())
  for (pkg in packages) {
    if (!pkg %in% installes) {
      install.packages(pkg, dependencies = TRUE)
    }
    library(pkg, character.only = TRUE)
  }
}

# Appel de la fonction
installer_et_charger_packages(packages_necessaires)

#unlink("../data_carte.rda")
unlink("R:/ServicesRegionaux/Service_Connaissance/7-Laboratoire_hydrobiologie/Donnees/Syntheses_et_valorisation/Outil_valorisation_HB_HDF_2025/data_carte.rda")

limites_bassin_utiles <- sf::st_read("R:/ServicesRegionaux/Service_Connaissance/7-Laboratoire_hydrobiologie/Donnees/Syntheses_et_valorisation/Outil_valorisation_HB_HDF_2025/AEAP_AESN/AEAP_AESN_utile.shp")%>%
  sf::st_transform(crs = 4326) %>%
  rmapshaper::ms_simplify()

limites_bassin_utiles_l <- limites_bassin_utiles$geometry %>%
  sf::st_cast("MULTILINESTRING") %>%  # Convertir le MULTIPOLYGON en MULTILINESTRING
  sf::st_cast("LINESTRING")  # Convertir chaque ligne du MULTILINESTRING en LINESTRING

limites_dep_utiles <- sf::st_read("R:/ServicesRegionaux/Service_Connaissance/7-Laboratoire_hydrobiologie/Donnees/Syntheses_et_valorisation/Outil_valorisation_HB_HDF_2025/departements/departements_utiles.shp")%>%
  sf::st_transform(crs = 4326) %>%
  rmapshaper::ms_simplify()

limites_dep_utiles_l <- limites_dep_utiles %>%
  sf::st_cast("MULTILINESTRING") %>%  # Convertir le MULTIPOLYGON en MULTILINESTRING
  sf::st_cast("LINESTRING")  # Convertir chaque ligne du MULTILINESTRING en LINESTRING

centroids <- st_centroid(limites_dep_utiles_l)
# Extraction des coordonnées en matrice
coords <- sf::st_coordinates(centroids)

# Création d'un data.frame simple avec lng, lat et label
labels_df <- data.frame(
  lng = coords[,1],
  lat = coords[,2],
  label = as.character(centroids$code_insee)
)


edl <- sf::st_read("R:/ServicesRegionaux/Service_Connaissance/7-Laboratoire_hydrobiologie/Donnees/Syntheses_et_valorisation/Outil_valorisation_HB_HDF_2025/edl/edl_ap_sn_utile.gpkg") %>%
  sf::st_transform(crs = 4326) %>%
  dplyr::filter(!sf::st_is_empty(.)) %>%
  dplyr::mutate(
    dplyr::across(
      c("ETAT.BIOLOGIQUE"),
      function(x) {factor(x, levels = c("très bon", "bon", "moyen", "médiocre", "mauvais", "indéterminé"))}
    ),
    ANNEE = 2022
  ) %>%
  rmapshaper::ms_simplify()


save(limites_bassin_utiles, limites_bassin_utiles_l,
     limites_dep_utiles , limites_dep_utiles_l,
     centroids, labels_df,edl,
     file = "R:/ServicesRegionaux/Service_Connaissance/7-Laboratoire_hydrobiologie/Donnees/Syntheses_et_valorisation/Outil_valorisation_HB_HDF_2025/data_carte.rda")


# usethis::use_data(
#   limites_bassin_utiles, limites_bassin_utiles_l,
#   limites_dep_utiles , limites_dep_utiles_l,
#   centroids, labels_df,
#   edl,
#   internal = TRUE, overwrite = TRUE
# )
