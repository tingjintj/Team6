#load libraries
library(tidyverse)
library(tidymodels)
library(data.table)
library(corrplot)
library(kknn)
library(vip)        
library(probably)   
library(scales)
library(janitor)    
library(themis)     
library(parallel)
library(doParallel)

num_cores <- parallel::detectCores(logical = FALSE)
cl <- makeCluster(num_cores - 1) 
registerDoParallel(cl)

# Load the data --------------------------------------------------------------
# The data has been preprocessed in a separate file for organization and maintainability.
# We're now loading the cleaned data set, which is stored as an RDS file on GitHub, to train the model.
# This approach separates data preprocessing from model training, improving code readability and modularity.

url <- "https://raw.githubusercontent.com/tingjintj/Team6/main/data_final.RData"
temp_file <- tempfile()
download.file(url, temp_file, mode = "wb")
load(temp_file) # For .RData
unlink(temp_file)

## Training and Testing sets -------------------------------------------------

set.seed(123)
data_split <- initial_split(data_final, prop = 0.80)
train_data <- training(data_split)
test_data  <- testing(data_split)

# Adjust factor levels for both 'make' and 'model' in training and testing data
all_make_levels <- levels(data_final$make)
all_model_levels <- levels(data_final$model)

train_data <- train_data %>%
  mutate(
    make = factor(make, levels = all_make_levels),
    model = factor(model, levels = all_model_levels)
  )

test_data <- test_data %>%
  mutate(
    make = factor(make, levels = all_make_levels),
    model = factor(model, levels = all_model_levels)
  )

str(train_data)
str(test_data)

## RANDOM FOREST MODEL --------------------------------------------------------

### Model specification ------------------------------------------------------

rf_spec <- rand_forest(trees = 500, mtry = tune(), min_n = tune()) %>%
  set_mode("regression") %>%
  set_engine("ranger", importance = 'permutation')

### Create a recipe for preprocessing ----------------------------------------
recipe <- recipe(price ~ ., data = train_data)

### Set up 5-fold cross-validation -------------------------------------------
cv_folds <- vfold_cv(train_data, v = 5)

#### Define a tuning ---------------------------------------------------------
grid <- grid_latin_hypercube(
  mtry(range = c(2, round(sqrt(ncol(train_data)), 0))),
  min_n(range = c(5, 20)),
  size = 30
)

### Tune the model -----------------------------------------------------------
tuned_results <- tune_grid(
  workflow() %>%
    add_recipe(recipe) %>%
    add_model(rf_spec),
  resamples = cv_folds,
  grid = grid,
  control = control_grid(save_pred = TRUE, save_workflow = TRUE)
)

# First, collect all metrics from the tuning results
all_metrics <- collect_metrics(tuned_results)

# Filter for the lowest RMSE
best_rmse <- all_metrics %>%
  filter(.metric == "rmse") %>%
  arrange(mean) %>%
  slice(1)

print(best_rmse) # From this object it is possible to visualize the best parameters

# FINAL MODEL -----------------------------------------------------

rf_spec <- rand_forest(
  trees = 500,    # This is fixed
  mtry = 3,       # Best parameter from tuning
  min_n = 6       # Best parameter from tuning
) %>% 
  set_mode("regression") %>%
  set_engine("ranger")

## Fitting the model on training data ----------------------------------------
model_fit <- rf_spec %>% 
  fit(price ~ ., data = train_data)

## Save the final model ------------------------------------------------------
saveRDS(model_fit, "/home/ubuntu/model_fit.rds") #adjust the path to save the model locally

## Evaluate on test data ------------------------------------------------------
test_results <- predict(model_fit, test_data) %>%
  bind_cols(test_data) %>%
  metrics(truth = price, estimate = .pred)

# Print the MAE for the test set
test_results %>% filter(.metric == "mae")

# Stop and clear parallel processing
stopCluster(cl)
registerDoSEQ()
