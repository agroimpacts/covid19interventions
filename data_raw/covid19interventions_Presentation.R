## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)
library(covid19interventions)
library(shiny)
library(DT)
library(ggplot2)
library(tidyverse)
library(changepoint)
library(shinythemes)
library(DT)
library(knitr)

data(mobility)
data(county_intervention_cases)

data(county_interventions)
data(df_joined)

