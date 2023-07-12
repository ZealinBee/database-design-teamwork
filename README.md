# Introduction

This is the e-commerce database project by Team 5.

Team 5 Members:
Stefanos Kapsoritakis
Malik Zaryan ul Hassan
Kim Khanh Nguyen
Ebizimoh Abodei
Zhiyuan Liu

## Table of content

- [Technologies](#technologies)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)

## Technologies

- PostgreSQL
- pgAdmin 4

##  Project Structure
````
.
│   .gitignore
│   E-Commerce ERD.JPG
│   README.md
│
├───API
│       Endpoints.md
│       RESTAPIArchitecture.md
│
├───data
│       categories.csv
│       inventory.csv
│       products.csv
│       reviews.csv
│       users.csv
│
└───querries
    ├───createDatabase
    │       createDatabase.sql
    │
    └───function
        ├───orderFunction
        │       cancelOrder.sql
        │       placeOrder.sql
        │
        ├───productFunction
        │       deleteProduct.sql
        │       getMostBought.sql
        │       updateProduct.sql
        │
        ├───retrievalFunction
        │       categoryRetrieval.sql
        │       inventoryRetrieval.sql
        │       orderDetailRetrieval.sql
        │       orderRetrieval.sql
        │       productRetrieval.sql
        │       retrieveItemFromTableById.sql
        │       reviewRetrieval.sql
        │       userRetrieval.sql
        │
        ├───reviewFunction
        │       createReview.sql
        │       deleteReview.sql
        │       readReview.sql
        │       updateReview.sql
        │       
        └───userFunction
                authenticateUser.sql
                deleteUser.sql
                registerUser.sql
                updateUser.sql
````