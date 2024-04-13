# DAR_Final_Project
## SectionBTeam6

# Table of Contents
- [Team Members](#team-members)
- [Project Overview](#autoworthwizard-advanced-used-car-price-prediction-tool)
- [Data Preparation and Model Training](#data-preparation-and-model-training)
- [Design and User Interface](#design-and-user-interface)
- [Features](#features)
- [Accessing Deployed Application](#accessing-deployed-application)


## Team Members
- Umberto Cirilli
- Iñaki Galdiano
- Ting Jin
- Joel Pascal Kömen
- Olaf Odinn Lesniak
- André Olivier Meylan

## AutoWorthWizard: Advanced Used Car Price Prediction Tool

AutoWorthWizard is an innovative R Shiny application designed to provide users with accurate price predictions for used cars in Germany. It leverages a sophisticated machine learning model to estimate car values based on multiple attributes including brand, model, fuel type, gear type, and more. The tool is intended for both buyers and sellers, offering insights into car valuation to help users make informed decisions.

## Data Preparation and Model Training

The development of AutoWorthWizard involved several key stages:
- **Data Cleaning:** Initial raw data were thoroughly cleaned to ensure accuracy and reliability. This involved handling missing values, correcting anomalies, and standardizing formats.(`shiny_app_cars_data_preprocessing.R`)
- **Data Storage:** Cleaned data were stored in an R data format (`data_final.RData`), ensuring efficient access and manipulation within the R environment.
- **Machine Learning Model:** A machine learning model was trained using the cleaned data. This model is crucial for predicting car prices based on their characteristics. (`MODEL_WITH_COMMENTS.R`)
- **Model Storage:** The trained model was stored as an RDS file (`final_model.rds`) to facilitate easy loading and prediction in the Shiny application. This file can be accessed [final_model](https://urledu-my.sharepoint.com/:u:/g/personal/ting_jin_esade_edu/EcY7v9JgSdJBmc6ELRSuZO4B_23UdRMagnCirThU98QYmw?e=0sih6Z).

## Design and User Interface

To ensure a consistent and visually appealing user interface, we developed a specific color palette and applied throughout the application. This color palette helps maintain a uniform look and enhances the user experience. You can view the color palette ![color/palette](https://github.com/tingjintj/Team6/blob/main/color-palette.png).

## Features

- **Dynamic User Interface:** Utilizes `shinydashboard` for a responsive, modern UI.
- **Advanced Data Visualization:** Incorporates `plotly` and `leaflet` for interactive charts and maps.
- **Machine Learning Integration:** Uses the pre-trained model to predict car prices.
- **Comprehensive Data Analysis:** Employs `tidyverse` tools for efficient data manipulation and analysis.

## Accessing Deployed Application

AutoWorthWizard is hosted on an AWS EC2 instance. When needed, we will turn the EC2 instance on and provide the public IP address. Currently, the application can be accessed via:

[http://15.237.43.238:3838/](http://15.237.43.238:3838/)
