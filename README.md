# Netflix SQL Project

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. Below is a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Dataset
The dataset for this project is sourced from the [Kaggle dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows). It contains information about Netflix's movies and TV shows, including their titles, directors, actors, countries, release years, ratings, durations, and genres.

### Dataset Schema:
```sql
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix (
  show_id VARCHAR(5),
  type VARCHAR(10),
  title VARCHAR(250),
  director VARCHAR(550),
  casts VARCHAR(1050),
  country VARCHAR(550),
  date_added VARCHAR(55),
  release_year INT,
  rating VARCHAR(15),
  duration VARCHAR(15),
  listed_in VARCHAR(250),
  description VARCHAR(550)
);
