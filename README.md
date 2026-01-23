❄️ Snowflake – Data Engineering Evaluation Project

DataScientest | Formation Data Scientist / Data Engineer

🎯 Objectif du projet

Ce projet s’inscrit dans le cadre d’une évaluation technique réalisée chez DataScientest, visant à valider la maîtrise des fondamentaux Snowflake, depuis le chargement de données brutes depuis S3 jusqu’à leur modélisation analytique et leur exploitation via des requêtes métier.

L’approche adoptée est volontairement Data Engineering / Architecte, avec une séparation claire des responsabilités :

ingestion,

modélisation,

transformation,

consommation analytique.

🧱 Architecture logique du projet

Le projet suit une architecture analytique classique en trois couches :

Zone d’ingestion (raw / staging)

Chargement de fichiers CSV depuis un bucket S3 Snowflake

Gestion des erreurs de format et de qualité de données

Contrôle fin des paramètres COPY INTO

Zone de modélisation (schéma en étoile)

Transformation des données normalisées

Construction d’un modèle orienté analyse (facts & dimensions)

Optimisation pour les requêtes analytiques

Zone de consommation

Requêtes SQL métier

Résultats persistés dans des fichiers exploitables

Logique proche d’un data mart analytique

📦 Contenu de l’archive
1️⃣ init.sql – Ingestion & initialisation

Ce script contient :

La création des tables Snowflake

Le chargement des données depuis S3
(s3://course-snowflakes/sample/music/)

La gestion des cas réels de data engineering :

mismatch de colonnes CSV

valeurs numériques invalides

poursuite du chargement malgré erreurs (ON_ERROR = CONTINUE)

création de file formats personnalisés (csv_error)

🎯 Objectif : garantir une ingestion robuste, tolérante aux défauts des données sources.

2️⃣ doc.txt – Démarche de transformation

Ce document détaille pas à pas :

La réflexion de transformation des données normalisées

Le passage vers un schéma en étoile

Les choix de modélisation pour analyser les tracks présents sur les CDs

🎯 Objectif : démontrer la capacité à concevoir un modèle analytique, pas seulement à écrire du SQL.

3️⃣ star.sql – Modélisation analytique

Ce script implémente :

Les tables de faits

Les tables de dimensions

Une structure adaptée aux analyses de performance, durée, genres, artistes et albums

🎯 Objectif : fournir un socle performant pour l’analyse décisionnelle.

4️⃣ query.sql – Requêtes métier

Ce fichier contient les requêtes répondant à des problématiques analytiques concrètes, par exemple :

Albums multi-CD

Morceaux par année de production

Analyse par genre musical

Performances par artiste

Durée moyenne des morceaux

Analyse croisée artistes / playlists / pays

🎯 Objectif : démontrer la capacité à traduire des besoins métier en requêtes SQL analytiques.

5️⃣ answer.txt – Résultats

Stockage des résultats des requêtes

Séparation claire entre calcul et restitution

Logique proche d’un livrable client ou BI

🧠 Compétences mises en œuvre

❄️ Snowflake (SQL, COPY INTO, File Formats)

☁️ Ingestion depuis S3

🧩 Modélisation dimensionnelle (schéma en étoile)

🛠️ Gestion des erreurs de données

📊 SQL analytique avancé

🏗️ Démarche Data Engineer / Architecte

📁 Structuration professionnelle d’un projet data
