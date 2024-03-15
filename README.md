# salessync

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Backend - BDD - Auth : Firebase, Cloud Firestore, ...

Objectif:
Utiliser les différents outils de Firebase (ou Supabase / AppWrite) pour construire une application complète
Une entreprise de vente de produits en porte à porte souhaite avoir une application permettant de suivre l’évolution de son chiffre d’affaire en temps réel
Elle est composée de 10 commerciaux et 4 techniciens

Lors d’un rendez-vous lorsqu’un commercial réalise une vente, on stocke les informations en base de données -> l’ensemble des employés reçoit une notification sur son téléphone
Un écran liste les ventes réalisées et est actualisé en temps réel -> Le classement des commerciaux est visible sur une TV dans la salle de réunion de l’entreprise
Les ventes sont saisies sur téléphone à la sortie du rendez-vous

Comment faire? => Utilisation de Firebase pour gérer:

- L’authentification (https://firebase.google.com/docs/auth/flutter/start)
- Le stockage des données dans FireCloud
  (https://firebase.google.com/docs/firestore/quickstart#dart_1)
- // Le stockage des images (Firebase Storage)
- // Les notifications
- // L’hébergement web

Chaque vente passe par différents statut (vendu, visite technique validée, financement validé / annulation)
On peut accéder au détail des statistiques de chaque commercial / prospecteur

Model:

- User:

  - String id
  - String displayName
  - UserRole role
  - List<SaleModel> sales

- UserRole:

  - admin
  - Commercial
  - Technician

- Sale:

  - String id
  - UserModel user
  - List<ProductModel> products
  - SaleStatus status

- SaleStatus:

  - sold
  - technicalVisitValid
  - financingValid
  - canceled

- Product:
  - String id
  - String name
  - String description
  - double price
  - String image
