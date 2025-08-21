#' Explication sur la provenance et le traitement des données
#' Origine et utilisation du site

mod_donnees_traitements_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "contenu-donnees-traitements",

      h3("Origine des données"),
      p("Les données utilisées par l’outil sont principalement stockées sur le stockage réseau commun (R:)."),

      h4("Sources des données"),
      tags$ul(
        tags$li(strong("Données Hubeau :"), " récupérées via l’API Hydrobiologie, nettoyées et structurées dans un fichier .rda pour un chargement rapide."),
        tags$li(strong("Fichier Excel interne :"), " utilisé pour filtrer les stations pertinentes."),
        tags$li(strong("Fonds de carte :"), " issus de flux cartographiques (OpenStreetMap, orthophotos IGN, réseau hydrographique, bassins versants, etc.)."),
        tags$li(strong("Zones géographiques :"), " départements, AESN, AEAP préparées à partir de fichiers internes via un script dédié.")      ),

      h4("Fiches stations"),
      p("Le logiciel recherche automatiquement les fiches stations PDF associées aux stations selon la zone géographique (Seine-Normandie ou Artois-Picardie).",
      tags$br(), "Les dossiers et fichiers sont analysés pour retrouver la fiche station correspondante à la station et indicateur sélectionné"),
      p("Pour plus d'informations et de détails sur les données, voir la notice d'utilisation stockée dans le répertoire suivant :",
      tags$br(),
        "R:/ServicesRegionaux/Service_Connaissance/7-Laboratoire_hydrobiologie/Donnees/Syntheses_et_valorisation/Outil_valorisation_HB_HDF_2025"),
      hr(),


      h3("Origine du site (version)"),
      p("Logiciel initialement développé par Cédric Mondy pour l'OFB de L'Île-de-France en 2023.
        Cette version du logiciel est le fruit d’un stage de 4 mois réalisé par
        Edgar Matter, sous la supervision de Stéphane Gamard et
        Emmanuelle Latouche, à la Direction Régionale des Hauts-de-France
        de l’OFB, située à Amiens"),

      hr(),

      h3("Connaître le producteur/préleveur d'un relevé spécifique"),
      p("L'information du producteur et préleveur d'un relevé n'est pas renseigné sur hubeau.
        Elle n'apparaît donc pas sur ce logiciel. Voici une méthode pour retrouver cette information :",
      tags$br(), "Se rendre sur naiade.eaufrance.fr -> accès aux données -> Recherche.",
      tags$br(), "Entrer les informations du prélèvement dont vous recherchez les informations (date, code ou nom station, Indice ou support).",
      tags$br(), "Après avoir cliqué sur 'Visualiser les résultats', il sera possible de télécharger un fichier .zip qui contiendra un fichier Operations.csv qui fournira le producteur et préleveur pour chaque opération réalisées sur cette station.")


      # h3("Informations complémentaires"),
      # tags$ul(
      #   tags$li("Contact support ou documentation."),
      #   tags$li("Lien vers les rapports ou publications associées."),
      #   tags$li("Notes légales ou de confidentialité.")
      # )
    )
  )
}

