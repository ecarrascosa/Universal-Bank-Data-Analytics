install.packages("e1071")
install.packages("caret")
install.packages("class")

library(tidyverse)
library(caret)
library(class)

data <- read_csv("universal_bank.csv")

set.seed(917852074)
(sets = sample(
  c("train", "valid", "test"),
  size = 5000,
  replace = TRUE,
  prob = c(0.5, 0.25, 0.25)
))


# Create 3 subsets of the dataset of logical vectors (TRUE, FALSE)

train <- sets == "train"
validation <- sets == "valid"
test <- sets == "test"

# -------------------------------------- #
# Create target and predictors and normalize data
(target <- factor(data$personal_loan))
View(data)
# Normalize continuous variables using "scale" (z-score)
# Transmute = combination of select and mutate

predictors <- data %>% transmute(
  age = scale(age),
  experience = scale(experience),
  income = scale(income),
  zip = factor(zip),
  family = scale(family),
  credit_card_spend = scale(credit_card_spend),
  education = factor(education),
  mortgage = scale(mortgage),
  securities_account = factor(securities_account),
  cd_account = factor(cd_account),
  online = factor(online),
  credit_card = factor(credit_card)
)

(compare <- tibble(
  score = score_validation, 
  reference = target[validation]
))

# -------------------------------------- #
# Model development stage
# at this stage you should not use "test set"
# you can try different models and decide which one is better
# eventually after trying different models, you have to settle on one

score_validation <- knn(
  train = predictors[train, c("age", "credit_card_spend", "education", "income", "family")],
  test = predictors[validation, c("age", "credit_card_spend", "education", "income", "family")],
  cl = target[train],
  k = 1
)

confusionMatrix(score_validation, target[validation], positive="1")

# Evaluation stage
# use your selected model to score the test set and report model performance
score_test <- knn(
  train = predictors[train, c("age", "credit_card_spend", "education", "income", "family")],
  test = predictors[test, c("age", "credit_card_spend", "education", "income", "family")],
  cl = target[train],
  k = 1
)

confusionMatrix(score_test, target[test], positive="1")
