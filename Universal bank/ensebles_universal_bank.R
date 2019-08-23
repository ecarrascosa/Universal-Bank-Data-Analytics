library(tidyverse)
library(caret)

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
training_p <- 0.30
validation_p <- 0.35
validation_size <- validation_p * n

set.seed(913852074)
all_rows = 1:n
training <- createDataPartition(target, p = training_p, list=TRUE)$Resample1
validation <- sample(setdiff(all_rows, training), size = validation_size)
test <- setdiff(setdiff(all_rows, training), validation)

training_downsample <- downSample(training, target[training], list = FALSE)$x
training_upsample <- upSample(training, target[training], list = FALSE)$x

# -------------------------------------- #
# Create target and predictors and normalize data

data <- data %>% mutate(
  education = factor(education),
  securities_account = factor(securities_account),
  cd_account = factor(cd_account),
  online = factor(online),
  creadit_card = factor(credit_card)
) %>% select(-zip)

# -------------------------------------- #
# Model development stage
# at this stage you should not use "test set"
# you can try different models and decide which one is better
# eventually after trying different models, you have to settle on one

# Model 1: Classification Tree
model_1 <- train(
  factor(personal_loan) ~ .,
  data = data[training_downsample, ],
  method = 'rpart'
)

score_validation <- predict(model_1, newdata = data[validation, ])

confusionMatrix(score_validation, target[validation], positive="1")


# Model 2: Random Forrest
model_2 <- train(
  factor(personal_loan) ~ .,
  data = data[training_downsample, ],
  method = 'rf'
)

score_validation <- predict(model_2, newdata = data[validation, ])

confusionMatrix(score_validation, target[validation], positive="1")

# Model 3: Gradient Boosting
model_3 <- train(
  factor(personal_loan) ~ .,
  data = data[training_downsample, ],
  method = 'xgbTree'
)

score_validation <- predict(model_3, newdata = data[validation, ])

confusionMatrix(score_validation, target[validation], positive="1")

# -------------------------------------- #
# Evaluation stage
# use your selected model to score the test set and report model performance

score_test <- predict(model_3, newdata = data[test, ])

confusionMatrix(score_test, target[test], positive="1")
