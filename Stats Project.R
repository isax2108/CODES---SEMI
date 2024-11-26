install.packages("ggplot2")
install.packages("scales")
install.packages("lmtest")
install.packages("corrplot")
library(corrplot)
library(ggplot2)
library(scales)
library(lmtest)


# Step 1: Quantile filtering (99th percentile)
quantile_limit <- quantile(data$`PRICE (GEL)`, 0.99, na.rm = TRUE)
filtered_data <- data[data$`PRICE (GEL)` <= quantile_limit, ]

# Step 2: Plot histogram for filtered data
ggplot(filtered_data, aes(x = `PRICE (GEL)`)) +
  geom_histogram(binwidth = 5000, color = "#9D8189", fill = "#38040E", alpha = 0.7) +
  scale_x_continuous(
    breaks = seq(0, max(filtered_data$`PRICE (GEL)`, na.rm = TRUE), by = 100000), 
    labels = scales::comma
  ) +
  labs(title = "Histogram of Apartment Prices (Filtered)", x = "Price (GEL)", y = "Frequency") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12)
  )

# Step 3: Filter out outliers based on Area and PRICE (GEL)
filtered_data <- filtered_data[filtered_data$Area > 200 & filtered_data$Area < 10000, ]
filtered_data <- filtered_data[filtered_data$`PRICE (GEL)` > 50000 & filtered_data$`PRICE (GEL)` < 1000000, ]

# Step 4: Apply log transformation
filtered_data$log_Area <- log(filtered_data$Area)
filtered_data$log_Price <- log(filtered_data$`PRICE (GEL)`)

# Step 5: Scatter plot with regression line
library(ggplot2)
library(ggpmisc)

ggplot(filtered_data, aes(x = log_Area, y = log_Price)) +
  geom_point(color = "#640D14", alpha = 0.5) +  # Scatter plot points
  geom_smooth(method = "lm", color = "#250902", se = TRUE) +  # Regression line
  labs(title = "Scatter Plot of Prices vs Area with Regression Line",
       x = "Area (sq. ft.) [Log Scale]",
       y = "Price (Currency Units) [Log Scale]") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  stat_poly_eq(aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")), 
               formula = y ~ x, 
               parse = TRUE)


# Step 6: Check for correlation (optional, but useful)
cor(filtered_data$log_Area, filtered_data$log_Price, use = "complete.obs")

# Optional: Correlation plot (heatmap) for more variables
library(corrplot)
corr_data <- filtered_data[, c("Area", "PRICE (GEL)", "Rooms", "Bedrooms", "Floor")]
corr_matrix <- cor(corr_data, use = "complete.obs")
corrplot(corr_matrix, method = "circle", type = "upper", tl.col = "#9D8189", tl.srt = 45)

# Plot for 'PRICE (GEL)' density
ggplot(filtered_data, aes(x = `PRICE (GEL)`)) +
  geom_histogram(aes(y = ..density..), binwidth = 5000, color = "#9D8189", fill = "#38040E", alpha = 0.7) +
  geom_density(color = "#250902", size = 1) +  # Density curve
  scale_x_continuous(
    breaks = seq(0, max(filtered_data$`PRICE (GEL)`, na.rm = TRUE), by = 100000),
    labels = scales::comma
  ) +
  labs(title = "Density Plot of Apartment Prices", x = "Price (in GEL)", y = "Density") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12)
  )

# Plot for 'Area' density
ggplot(filtered_data, aes(x = Area)) +
  geom_histogram(aes(y = ..density..), binwidth = 50, color = "#9D8189", fill = "#640D14", alpha = 0.7) +
  geom_density(color = "#250902", size = 1) +  # Density curve
  scale_x_continuous(
    breaks = seq(0, max(filtered_data$Area, na.rm = TRUE), by = 500),
    labels = scales::comma
  ) +
  labs(title = "Density Plot of Area (sq. ft.)", x = "Area (in sq. ft.)", y = "Density") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12)
  )

# Plot for 'Rooms' density
ggplot(filtered_data, aes(x = Rooms)) +
  geom_histogram(aes(y = ..density..), binwidth = 0.5, color = "#9D8189", fill = "#38040E", alpha = 0.7) +
  geom_density(color = "#250902", size = 1) +  # Density curve
  scale_x_continuous(
    breaks = seq(0, max(filtered_data$Rooms, na.rm = TRUE), by = 1),
    labels = scales::comma
  ) +
  labs(title = "Density Plot of Rooms", x = "Rooms", y = "Density") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12)
  )

# Plot for 'Bedrooms' density
ggplot(filtered_data, aes(x = Bedrooms)) +
  geom_histogram(aes(y = ..density..), binwidth = 0.5, color = "#9D8189", fill = "#640D14", alpha = 0.7) +
  geom_density(color = "#250902", size = 1) +  # Density curve
  scale_x_continuous(
    breaks = seq(0, max(filtered_data$Bedrooms, na.rm = TRUE), by = 1),
    labels = scales::comma
  ) +
  labs(title = "Density Plot of Bedrooms", x = "Bedrooms", y = "Density") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12)
  )


# Multiple Regression Model
srm <- lm(`PRICE (GEL)` ~ Floor, data = filtered_data)

# Display the summary of the model
summary(srm)
# Multiple Regression Model
mrm <- lm(`PRICE (GEL)` ~ Rooms + Area + Bedrooms + Floor, data = filtered_data)

# Display the summary of the model
summary(mrm)

# Predictions using the fitted model
predictions <- predict(mrm, newdata = filtered_data)

# Calculate residuals (errors) - actual - predicted
residuals <- filtered_data$`PRICE (GEL)` - predictions

# Mean Squared Error (MSE)
MSE <- mean(residuals^2)
cat("Mean Squared Error (MSE):", MSE, "\n")

# Root Mean Squared Error (RMSE)
RMSE <- sqrt(MSE)
cat("Root Mean Squared Error (RMSE):", RMSE, "\n")

# Mean Absolute Error (MAE)
MAE <- mean(abs(residuals))
cat("Mean Absolute Error (MAE):", MAE, "\n")

# Mean Absolute Percentage Error (MAPE)
MAPE <- mean(abs(residuals / filtered_data$`PRICE (GEL)`)) * 100
cat("Mean Absolute Percentage Error (MAPE):", MAPE, "%\n")

# Get predictions from the model
predictions <- predict(mrm, newdata = filtered_data)

# Calculate residuals (actual - predicted)
residuals <- filtered_data$`PRICE (GEL)` - predictions

# Plot the histogram of residuals
ggplot(data.frame(residuals), aes(x = residuals)) +
  geom_histogram(binwidth = 50000, color = "#9D8189", fill = "#38040E", alpha = 0.7) +
  labs(title = "Histogram of Residuals from Multiple Regression Model", 
       x = "Residuals", y = "Frequency") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Breusch-Pagan test for heteroscedasticity
bp_test <- bptest(mrm)
print(bp_test)

# Standardize the variables based on z-score
filtered_data$Rooms_z <- (filtered_data$Rooms - mean(filtered_data$Rooms, na.rm = TRUE)) / sd(filtered_data$Rooms, na.rm = TRUE)
filtered_data$Area_z <- (filtered_data$Area - mean(filtered_data$Area, na.rm = TRUE)) / sd(filtered_data$Area, na.rm = TRUE)
filtered_data$Bedrooms_z <- (filtered_data$Bedrooms - mean(filtered_data$Bedrooms, na.rm = TRUE)) / sd(filtered_data$Bedrooms, na.rm = TRUE)
filtered_data$Floor_z <- (filtered_data$Floor - mean(filtered_data$Floor, na.rm = TRUE)) / sd(filtered_data$Floor, na.rm = TRUE)

# Check correlation after standardization
cor(filtered_data$Rooms_z, filtered_data$Area_z)
cor(filtered_data$Rooms_z, filtered_data$Bedrooms_z)

#Model with Standardized variables
# Step 1: Fit a Multiple Regression Model using standardized variables
mrm_standardized <- lm(`PRICE (GEL)` ~ Rooms_z + Area_z + Bedrooms_z + Floor_z, data = filtered_data)

# Step 2: Display the summary of the regression model
summary(mrm_standardized)

