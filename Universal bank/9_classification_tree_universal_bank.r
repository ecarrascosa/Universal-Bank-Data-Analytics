library(tidyverse)
library(caret)
library(class)

# -------------------------------------- #
# Load the data
data <- read_csv("universal_bank.csv")

# check if there is any missing values in the data
colSums(is.na(data))
# turns out: No missing value

# how many customers (rows) are there in the data
n <- nrow(data)
n
# turns out: 5,000

# -------------------------------------- #
# Create target
target <- factor(data$personal_loan)

# -------------------------------------- #
# Partition Data
# partition the data according to the following ratios
set.seed(913852074)
all_rows = 1:n
(training <- createDataPartition(target, p = 0.5, list=FALSE))
(validation <- sample(setdiff(all_rows, training), size = n/4))
(test <- setdiff(setdiff(all_rows, training), validation))

(training_downsample <- downSample(training, target[training], list = TRUE)$x)
(training_upsample <- upSample(training, target[training], list = TRUE)$x)
# -------------------------------------- #
# Create target and predictors and normalize data

data <- data %>% mutate(
  education = factor(education),
  securities_account = factor(securities_account),
  cd_account = factor(cd_account),
  online = factor(online),
  creadit_card = factor(credit_card)
)

# Use these models in the final 
# -------------------------------------- #

# Model development stage
# at this stage you should not use "test set"
# you can try different models and decide which one is better
# eventually after trying different models, you have to settle on one

# Model 1
model <- train(
  factor(personal_loan) ~ .,
  data = data[training, ],
  method = 'rpart'
)

# Plot the decision tree
prp(model$finalModel)

# Alternative ways to plot the tree (done in class, not as clear)
plot(model$finalModel)
text(model$finalModel)

score_validation <- predict(model, newdata = data[validation, ])
confusionMatrix(score_validation, target[validation], positive="1")

# Model 2
model <- train(
  factor(personal_loan) ~ .,
  data = data[training_upsample, ],
  method = 'rpart'
)

# Plot the decision tree
prp(model$finalModel)

# Alternative ways to plot (used in class)
plot(model$finalModel)
text(model$finalModel)



score_validation <- predict(model, newdata = data[validation, ])

confusionMatrix(score_validation, target[validation], positive="1")


# -------------------------------------- #
# Evaluation stage
# use your selected model to score the test set and report model performance

score_test <- predict(model, newdata = data[test, ])

confusionMatrix(score_test, target[test], positive="1")
