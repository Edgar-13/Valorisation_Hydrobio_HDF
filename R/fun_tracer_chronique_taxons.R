#' Tracer les chroniques d'abondance des taxons
#'
#' @param liste_station Un data.frame contenant les listes faunistiques ou floristiques
#'   avec les colonnes date_prelevement, libelle_taxon et resultat_taxon
#' @param ordre_taxon Une chaîne de caractères indiquant l'ordre de présentation des taxons :
#'   "ordre alphabétique", "abondance sur la chronique" ou une année spécifique
#'
#' @return Une liste d'objets ggplot2 représentant les chroniques d'abondance des taxons
#'   par groupes de 20 taxons maximum
#' @export
#'
#' @details Cette fonction trace les chroniques d'abondance des taxons en les regroupant
#'   par lots de 20 taxons maximum. L'ordre des taxons peut être :
#'   \itemize{
#'     \item alphabétique (ordre inverse)
#'     \item selon l'abondance totale sur la chronique
#'     \item selon l'abondance pour une année spécifique
#'   }
#'
#' @examples
#' \dontrun{
#' chroniques <- tracer_chroniques_taxons(liste_station, "ordre alphabétique")
#' chroniques <- tracer_chroniques_taxons(liste_station, "abondance sur la chronique")
#' chroniques <- tracer_chroniques_taxons(liste_station, 2020)
#' }
#' @importFrom dplyr mutate group_by summarise group_split
#' @importFrom ggplot2 ggplot geom_point aes scale_x_continuous sec_axis theme_minimal theme element_blank element_text labs
#' @importFrom lubridate year
#' @importFrom purrr map
tracer_chroniques_taxons <- function(liste_station, ordre_taxon) {
  liste_station <- liste_station %>%
    dplyr::mutate(annee = lubridate::year(date_prelevement))

  x_lims <- range(na.omit(liste_station$annee))
  x_breaks <- integer_breaks(n = 3)(liste_station$annee)

  if (ordre_taxon == "ordre alphabétique") {
    taxons <- liste_station %>%
      dplyr::distinct(libelle_taxon) %>%
      dplyr::arrange(dplyr::desc(libelle_taxon)) %>%
      dplyr::mutate(
        taxon = libelle_taxon %>%
          forcats::fct_inorder()
      ) %>%
      dplyr::pull(taxon) %>%
      levels()
  }

  if (ordre_taxon == "abondance sur la chronique") {
    taxons <- liste_station %>%
      dplyr::group_by(libelle_taxon) %>%
      dplyr::summarise(ab_tot = sum(resultat_taxon)) %>%
      dplyr::mutate(taxon = libelle_taxon %>%
                      forcats::fct_reorder(ab_tot)) %>%
      dplyr::pull(taxon) %>%
      levels()
  }

  if (!is.na(as.numeric(ordre_taxon))) {
    taxons <- liste_station %>%
      dplyr::filter(annee == ordre_taxon) %>%
      dplyr::group_by(libelle_taxon) %>%
      dplyr::summarise(ab_tot = sum(resultat_taxon)) %>%
      dplyr::mutate(taxon = libelle_taxon %>%
                      forcats::fct_reorder(ab_tot)) %>%
      dplyr::pull(taxon) %>%
      levels() %>%
      (function(x) {
        c(liste_station %>%
            dplyr::filter(!libelle_taxon %in% x) %>%
            dplyr::distinct(libelle_taxon) %>%
            dplyr::arrange(dplyr::desc(libelle_taxon)) %>%
            dplyr::mutate(
              taxon = libelle_taxon %>%
                forcats::fct_inorder()
            ) %>%
            dplyr::pull(taxon) %>%
            levels(),
          x
        )
      })

  }

  liste_station %>%
    dplyr::mutate(
      libelle_taxon = libelle_taxon %>%
        factor(levels = taxons)
      ) %>%
    dplyr::group_by(code_station_hydrobio, libelle_station_hydrobio,
                    annee, libelle_support, libelle_taxon) %>%
    dplyr::summarise(resultat_taxon = sum(resultat_taxon), .group = "drop") %>%
    dplyr::group_by(libelle_support) %>%
    dplyr::group_split() %>%
    purrr::map(
      function(df_temp) {
        # --- calcul du nombre de taxons distincts par année
        totaux_annee <- df_temp %>%
          dplyr::group_by(annee) %>%
          dplyr::summarise(nb_taxons = dplyr::n_distinct(libelle_taxon), .groups = "drop")

        max_taxons <- max(totaux_annee$nb_taxons, na.rm = TRUE)

        # --- graphique principal
        p1 <- ggplot(df_temp) +
          geom_point(
            aes(
              x = annee,
              y = libelle_taxon,
              size = sqrt(resultat_taxon)
            )
          ) +
          scale_x_continuous(
            breaks = x_breaks,
            limits = x_lims,
            sec.axis = sec_axis(~., breaks = x_breaks)
          ) +
          theme_minimal() +
          theme(
            panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank(),
            axis.title = element_text(hjust = .95),
            legend.position = "top",
            axis.text.y = element_text(hjust = 0, size = 10)
          ) +
          labs(x = "", y = "", size = "Abondance")

        # --- petit tableau des totaux (graphique stylisé en "table")
        p2 <- ggplot(totaux_annee, aes(x = annee, y = 1, label = nb_taxons)) +
          geom_text(size = 4) +
          theme_void() +
          labs(title = "Nombre de taxons par année")

        # --- combinaison des deux : graphe au-dessus, tableau dessous
        p2 / p1 + plot_layout(heights = c(1, max_taxons))
      }
    )

}
