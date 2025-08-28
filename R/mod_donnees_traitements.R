mod_donnees_traitements_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "contenu-donnees-traitements",

      h3("Précaution d’usage"),
      p("Pour tout usage des données dans un cadre légal, il est recommandé de les rechercher sur les plateformes officielles.
        Le présent site propose un traitement et une valorisation des données à titre informatif."),

      hr(),

      h3("Origine des données"),

      h4("Sources des données"),
      tags$ul(
        tags$li(strong("Données Hubeau :"),
                " récupérées via l’API Hydrobiologie, nettoyées et structurées dans un fichier .rda pour un chargement rapide."),
        tags$li(strong("Fichier Excel interne :"),
                " utilisé pour filtrer les stations pertinentes."),
        tags$li(strong("Fonds de carte :"),
                " issus de flux cartographiques (OpenStreetMap, orthophotos IGN, réseau hydrographique, bassins versants, etc.)."),
        tags$li(strong("Zones géographiques :"),
                " départements, AESN, AEAP préparés à partir de fichiers internes via un script dédié.")
      ),

      h4("Fiches stations"),
      p("Le logiciel recherche automatiquement les fiches stations PDF associées aux stations selon la zone géographique
         (Seine-Normandie ou Artois-Picardie).",
        tags$br(),
        "Les dossiers et fichiers sont analysés pour retrouver la fiche station correspondant à la station et à l’indicateur sélectionné."),

      hr(),

      h3("Origine du site (version)"),
      p("Logiciel initialement développé par Cédric Mondy pour l'OFB Île-de-France en 2023.",
        tags$br(),
        "Cette version du logiciel est le fruit d’un stage de 4 mois réalisé par Edgar Matter, sous la supervision de Stéphane Gamard et Emmanuelle Latouche,
         à la Direction Régionale des Hauts-de-France de l’OFB, située à Amiens.",
        tags$br(),
        "Voici une liste des principales modifications et améliorations apportées pour adapter l’outil aux besoins du laboratoire d’hydrobiologie des Hauts-de-France (plus de détails dans la notice d’utilisation) :"
      ),
      tags$ul(
        tags$li(strong("Affichage de la carte : "),
                "Le laboratoire d'hydrobiologie des Hauts-de-France effectue des prélèvements sur une zone géographique très étendue
                (plus de 10 départements et 3 régions). Il a donc fallu adapter l’affichage de la carte et des bassins versants afin que
                la zone affichée corresponde à l’activité du laboratoire.",
                tags$br(),
                "Les fonds de carte ont également été mis à jour pour répondre aux besoins des utilisateurs de l’outil."),
        tags$li(strong("Données d’hydrobiologie : "),
                "Seules les stations situées dans la zone d’activité du laboratoire sont chargées."),
        tags$li(strong("Ergonomie du logiciel : "),
                "Amélioration du panneau de sélection et ajustement de la taille d’affichage des différents composants de l’outil."),
        tags$li(strong("Ajouts divers : "),
                "Bouton export/impression permettant d’exporter ou d’imprimer ce qui est affiché par le logiciel.
                Un glossaire, des légendes et titres de graphiques ont été ajoutés afin d’en faciliter la lecture.
                Un bouton permet également d’accéder aux fiches stations stockées dans le répertoire de travail du laboratoire.")
      ),

      hr(),

      h3("Connaître le producteur/préleveur d'un relevé spécifique"),
      p("L'information sur le producteur ou préleveur d’un relevé n’est pas renseignée sur Hubeau et n’apparaît donc pas dans ce logiciel.
        Voici une méthode pour retrouver cette information :",
        tags$br(),
        "1. Se rendre sur ", tags$b("naiade.eaufrance.fr"), " → Accès aux données → Recherche.",
        tags$br(),
        "2. Renseigner les informations du prélèvement (date, code ou nom de la station, indice ou support).",
        tags$br(),
        "3. Après avoir cliqué sur 'Visualiser les résultats', télécharger le fichier .zip proposé : il contient un fichier ",
        tags$b("Operations.csv"), " qui fournit le producteur et le préleveur pour chaque opération réalisée sur la station."
      )
    )
  )
}
