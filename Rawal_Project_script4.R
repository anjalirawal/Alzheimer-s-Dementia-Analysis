# Anjali Rawal| October 18, 2023 | ALY 6000| Section: 12 | CRN: 70556 | SEA
cat("\014") # clears console
rm(list = ls()) # clears global environment 
try(dev.off(dev.list()["RStudioGD"]), silent = TRUE) # clears plots 
try(p_unload(p_loaded(), character.only = TRUE), silent = TRUE) # clears packages
options(scipen = 100) # disables scientific notion for entire R session
library(pacman)
p_load(tidyverse)

# Took MRI and Alzheimer data, it consist of 2 dataset with >700 entries and more than 8 attributes,

# Problem Questions - 
#1. Top 3 attributes which are directly proportional to having dementia based on both dataset study  
#2. Predicting dementia in crossectional dataset using longitudinal dataset as training data
#3. Which groups have are more affected by dementia Male or Female 



#Approach - will observe, clean two datasets separately and then combine the cleaned dataset for visualization and problem solving 

#Question1 - Review any written description of your dataset. This is often referenced as the data dictionary.
# The data set includes below attributes 
#1. ID 
#2. Gender - Male/Female
#3. Hand - explaining dominant hand 
#4. Age 
#5. Educ - Education 
#6. SES - Socioeconomic Status 
#7. MMSE - Mini Mental State Examination 
#8. CDR - Clinical Dementia Rating 
#9. eTIV - Estimated Total Intercranial Volume 
#10. nWBV - Normalize Whole Brain Volume 


# Loading Data - cross-sectional 
cross_sectional <- read.csv('cross-sectional.csv')
head(cross_sectional)
tail(cross_sectional)
summary (cross_sectional)

# Loading Data - longitudinal 
longitudinal <- read.csv('longitudinal.csv')
head(longitudinal)
tail(longitudinal)
summary(longitudinal)

#Question2 - Clean your data. Cleaning involves any task that prepares the dataset for analysis.This might include the following tasks:
# a. Renaming columns
# b. Managing NAs
# c. Correcting data types
# d. Removing columns or rows
# e. Manipulating strings
# f. Reorganizing the data
# g. Other steps that prepare your data

# Renaming the columns 
cross_sectional <- mutate(cross_sectional, social_economic_status = SES ,  mini_mentalstate_exam = MMSE, total_intercranial_volume = eTIV)
names(cross_sectional)

longitudinal <- mutate(longitudinal,social_economic_status = SES ,  mini_mentalstate_exam = MMSE, total_intercranial_volume = eTIV)
names(longitudinal)


#managing NAs 
cross_sectional <- na.omit(cross_sectional)
summary(cross_sectional)

longitudinal <- na.omit(longitudinal)
summary(longitudinal)

#(https://www.tutorialspoint.com/how-to-remove-all-rows-having-na-in-r#:~:text=To%20remove%20all%20rows%20having%20NA%2C%20we%20can%20use%20na,omit(df).)

# correcting datatypes 
library(lubridate)
cross_sectional$M.F <- factor(cross_sectional$M.F)
class(cross_sectional$M.F)

longitudinal$M.F <- factor(longitudinal$M.F)
class(longitudinal$M.F)

#Removing columns or rows 
cross_sectional <- subset(cross_sectional, select = -c(SES, MMSE, eTIV))
names(cross_sectional)

longitudinal <- subset(longitudinal, select = -c(SES, MMSE, eTIV))
names(longitudinal)

# Manipulating strings 
# in longitudinal dataset, we will convert Group values as 
# Demented as 2
# Nondemented as 0 
# Converted as 1
# we will use longitudinal datset to train the model and then will predict on cross_sectional, will consider converted as demented as dementia was predicted
longitudinal <- longitudinal %>% mutate(diagnosis = case_when(Group == 'Converted' ~ 2, 
                                                         Group == 'Demented' ~ 2, 
                                                         Group == 'Nondemented' ~ 1))
names(longitudinal)
longitudinal$diagnosis

#Question3 - Determine descriptive statistics for interesting variables.
summary(cross_sectional)
summary(longitudinal)

#Question4 - Produce visualizations from the raw data that identify and highlight interesting aspects. These can include bar charts, histograms, line graphs, scatter plots, etc. Be sure the chosen graph best represents the information.
#To relate which three factors are more proportional to having dementia

help("heatmap")
#install.packages("corrplot")
library(corrplot)
cor_matrix <- cor(select_if(longitudinal, is.numeric))
corrplot(cor_matrix, method = "color")


# on the basis of the chart three attributes which are correlated with Dementia are social economic statu and CDR have correlation with Dementia

library("ggthemes")
ggplot(longitudinal, aes(x = CDR, y = diagnosis)) +
  geom_point(alpha = 0.6) +
  scale_color_discrete(name = "CDR vs Diagnosis") 

# How mini_mentalstate_exam affects Diagnosis
ggplot(longitudinal, aes(x = diagnosis , y = mini_mentalstate_exam)) +
  geom_point(alpha = 0.6) +
  scale_color_discrete(name = "Mini Mental State Exam vs Diagnosis") 
# mini_mentalstate_exam and Diagnosis are inversely proportional 

# How Normalize whole Brain Volume affects Diagnosis
ggplot(longitudinal, aes(x = diagnosis , y = nWBV)) +
  geom_point(alpha = 0.6) +
  scale_color_discrete(name = "Normalize Whole Brain Volume vs Diagnosis") 
# The graph indicates that more the nWBV, less the chances of dementia 

# Problem Question2. Predicting dementia in crossectional dataset using longitudinal dataset as training data
cross_sectional %>% mutate(diagnosis = case_when(CDR > 1 | mini_mentalstate_exam <20 | nWBV<.80 ~ 2, 
                                                      CDR < 1 | mini_mentalstate_exam >20 | nWBV>.80 ~ 1, 
                                                      TRUE ~ 0))
#Part II
# Question1 - Create new variables that better capture the data you want to report. For example, if the data shows yearly sales by month, you might calculate the month-to-month increase or decrease in sales as a new column.
#Mergedataset 
mri_data <- bind_rows(longitudinal, cross_sectional)

round(mri_data$diagnosis, digits = 0)
mri_data <- mri_data[!is.na(mri_data$diagnosis), ]
#view(mri_data)


#Creating new variable
mri_data <- mri_data %>% mutate(diagnosis_final = case_when(diagnosis == 1 ~ 'Demented', 
                                                      diagnosis == 2 ~ 'Demented', 
                                                      diagnosis == 0 ~ 'Nondemented'))

#Problem Question 2 - Which groups have are more affected by dementia Male or Female 

#Question2 - Group, summarize, rank, arrange, count, or perform any other useful operations to create new data frames that provide access to different views of the data.
# create dataframe containing only diagnosis and CDR, nWBV, and MMSE, M/F and work on that, merge the dataset 
working_mri_dataset <- subset(mri_data, select = c(M.F, Age, CDR, nWBV, mini_mentalstate_exam, diagnosis))
working_mri_dataset

#view(working_mri_dataset) 

# For further analysis, converted are changed to demented, as they were diagnosed with dementia at one stage of life
# count demented in male and female using count and summarise function 
dementia_count <- mri_data %>%
  filter(diagnosis_final == "Demented") %>%
  group_by(M.F) %>%
  summarise(count_demented = n())
dementia_count

ggplot(dementia_count, aes(x = M.F, y = count_demented)) + 
  geom_bar(stat="identity", fill="blue") + 
  labs(y = "Dementia Count", x = "Gender", title = "Dementia Count by Gender")

# Question 3 - create a graph with all three factors with diagnosis on a same graph 
# visualize, cdr nwbv and mmse vs diagnosis and see if there is any diffrence 

# Load necessary libraries
library(dplyr)

# Plot the boxplot using ggplot2
final_data <- mri_data %>%
pivot_longer(cols = c(CDR, nWBV, mini_mentalstate_exam), 
             names_to = "variable", 
             values_to = "value")

# Calculate means by diagnosis for each variable

aggregate_data <- final_data %>%
  group_by(diagnosis, variable) %>%
  summarise(mean_value = mean(value, na.rm = TRUE))

# Create a bar chart using ggplot2
ggplot(aggregate_data, aes(x = variable, y = mean_value, fill = diagnosis)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Mean Value of Variables by Diagnosis", x = "Variable", y = "Mean Value") +
  theme_minimal()
