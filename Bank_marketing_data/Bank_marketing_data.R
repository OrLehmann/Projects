# התקנת חבילות נדרשות במידה ולא מותקנות
packages <- c("rpart", "randomForest", "rpart.plot", "ROCR", "ggplot2", 
              "dplyr", "caTools", "pROC", "caret", "corrplot", 
              "purrr", "naivebayes", "reshape2")

installed_packages <- packages %in% rownames(installed.packages())
if (any(!installed_packages)) {
  install.packages(packages[!installed_packages])
}

# טעינת ספריות נדרשות
library(rpart)
library(randomForest)
library(rpart.plot)
library(ROCR)
library(ggplot2)
library(dplyr)
library(caTools)
library(pROC)
library(caret)
library(corrplot)
library(purrr)
library(naivebayes)
library(reshape2)

# הגדרת תיקיית העבודה
setwd("C:/Users/CHENA/Documents/R project bank")

# קריאת הנתונים
dataset <- read.csv('C:/Users/CHENA/Documents/R project bank/Bank Marketing Dataset.csv')

# הצגת מבנה הנתונים
str(dataset)

# ספירת הערכים של YES ו-NO בעמודת deposit
yes_count <- sum(dataset$deposit == "yes")
no_count <- sum(dataset$deposit == "no")

# הצגת התוצאות
cat("Number of YES values: ", yes_count, "\n")
cat("Number of NO values: ", no_count, "\n")

############## EDA לפני ניקוי ############

# בדיקת קשר בין גיל להפקדה
ggplot(dataset, aes(x = age, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Age", x = "Age", y = "Proportion") +
  scale_fill_manual(values = c("lightblue", "lightgreen"))

# בדיקת קשר בין סוג המשרה להפקדה
ggplot(dataset, aes(x = job, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Job", x = "Job", y = "Proportion") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("pink", "purple"))

# בדיקת קשר בין המצב המשפחתי להפקדה
ggplot(dataset, aes(x = marital, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Marital Status", x = "Marital Status", y = "Proportion") +
  scale_fill_manual(values = c("orange", "blue"))

# בדיקת קשר בין השכלה להפקדה
ggplot(dataset, aes(x = education, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Education", x = "Education", y = "Proportion") +
  scale_fill_manual(values = c("yellow", "green"))

# בדיקת קשר בין יתרת חשבון להפקדה
ggplot(dataset, aes(x = balance, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Balance", x = "Balance", y = "Proportion") +
  scale_fill_manual(values = c("red", "cyan"))

# בדיקת קשר בין סוג התקשרות להפקדה
ggplot(dataset, aes(x = contact, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Contact", x = "Contact", y = "Proportion") +
  scale_fill_manual(values = c("brown", "pink"))

# בדיקת קשר בין משכנתא להפקדה
ggplot(dataset, aes(x = housing, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Housing", x = "Housing", y = "Proportion") +
  scale_fill_manual(values = c("darkblue", "lightblue"))

# בדיקת קשר בין הלוואה אישית להפקדה
ggplot(dataset, aes(x = loan, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Loan", x = "Loan", y = "Proportion") +
  scale_fill_manual(values = c("darkgreen", "lightgreen"))

# בדיקת קשר בין חודש להפקדה
ggplot(dataset, aes(x = month, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Month", x = "Month", y = "Proportion") +
  scale_fill_manual(values = c("blue", "yellow"))

# בדיקת קשר בין משך השיחה להפקדה
ggplot(dataset, aes(x = duration, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Duration", x = "Duration", y = "Proportion") +
  scale_fill_manual(values = c("purple", "orange"))

# בדיקת קשר בין מספר הקמפיינים להפקדה
ggplot(dataset, aes(x = campaign, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Campaign", x = "Campaign", y = "Proportion") +
  scale_fill_manual(values = c("darkorange", "darkgreen"))

# בדיקת קשר בין מספר הימים שעברו מאז יצירת הקשר האחרון להפקדה
ggplot(dataset, aes(x = pdays, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Pdays", x = "Pdays", y = "Proportion") +
  scale_fill_manual(values = c("purple", "lightyellow"))

# בדיקת קשר בין מספר הקשרים הקודמים להפקדה
ggplot(dataset, aes(x = previous, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Previous", x = "Previous", y = "Proportion") +
  scale_fill_manual(values = c("pink", "lightblue"))

# בדיקת קשר בין תוצאות הקשר הקודם להפקדה
ggplot(dataset, aes(x = poutcome, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Poutcome", x = "Poutcome", y = "Proportion") +
  scale_fill_manual(values = c("blue", "red"))

############## תהליך ניקוי ##################

# בדיקה אם העמודות הן מספריות והמרה במידת הצורך
numeric_columns <- c("age", "balance", "day", "duration", "campaign", "pdays", "previous")
for (col in numeric_columns) {
  if (!is.numeric(dataset[[col]])) {
    dataset[[col]] <- as.numeric(as.character(dataset[[col]]))
  }
}

# בחירת עמודות רלוונטיות לחישוב קורלציה (רק עמודות מספריות)
correlation_data <- dataset[, numeric_columns]

# בדיקה אם כל העמודות הנומריות קיימות בנתונים
missing_columns <- numeric_columns[!numeric_columns %in% colnames(correlation_data)]
if(length(missing_columns) > 0) {
  print(paste("The following numeric columns are missing:", paste(missing_columns, collapse = ", ")))
} else {
  print("All specified numeric columns are present.")
}

# חישוב מטריצת הקורלציה
correlation_matrix <- cor(correlation_data, use = "complete.obs")

# הוספת שמות השורות והעמודות
rownames(correlation_matrix) <- toupper(numeric_columns)
colnames(correlation_matrix) <- toupper(numeric_columns)

# הצגת מטריצת הקורלציה כטבלה
print(correlation_matrix)

# הצגת מטריצת הקורלציה כתרשים
corrplot(correlation_matrix, method = "circle", type = "upper", tl.cex = 0.8, title = "Correlation Matrix")

# שמירת מטריצת הקורלציה לקובץ CSV
write.csv(correlation_matrix, "correlation_matrix.csv")

# המרת גיל לקטגוריות
dataset$age <- cut(dataset$age, breaks = c(18, 35, 60, 95), labels = c("18-35", "36-60", "61+"), right = FALSE)

# המרת 'unknown' ל-'student' בעמודת job
make_student <- function(x) {
  if (x == 'unknown') return ('student')
  return(x)
}
dataset$job <- sapply(dataset$job, make_student)
dataset$job <- as.factor(dataset$job)

# המרת marital לפקטור
dataset$marital <- as.factor(dataset$marital)

# המרת 'unknown' ל-'tertiary' בעמודת education
make_tertiary <- function(x) {
  if (x == 'unknown') return ('tertiary')
  return(x)
}
dataset$education <- sapply(dataset$education, make_tertiary)
dataset$education <- as.factor(dataset$education)

# המרת default לפקטור
dataset$default <- as.factor(dataset$default)

# חלוקת balance לקטגוריות
balance_binned <- vector("character", length = nrow(dataset))
balance_binned[dataset$balance < 0] <- "Less than 0"
balance_binned[dataset$balance == 0] <- "0"
balance_binned[dataset$balance > 0 & dataset$balance <= 1000] <- "1-1000"
balance_binned[dataset$balance > 1000] <- "1,000+"
dataset$balance_binned <- as.factor(balance_binned)

# המרת housing לפקטור
dataset$housing <- as.factor(dataset$housing)

# המרת loan לפקטור
dataset$loan <- as.factor(dataset$loan)

# המרת 'unknown' ל-'cellular' בעמודת contact
make_cellular <- function(x) {
  if (x == 'unknown') return ('cellular')
  return(x)
}
dataset$contact <- sapply(dataset$contact, make_cellular)
dataset$contact <- as.factor(dataset$contact)

# חלוקת month לרבעונים
make_quarter <- function(x) {
  if (x %in% c("jan", "feb", "mar")) return("Quarter 1")
  if (x %in% c("apr", "may", "jun")) return("Quarter 2")
  if (x %in% c("jul", "aug", "sep")) return("Quarter 3")
  return("Quarter 4")
}
dataset$month <- sapply(dataset$month, make_quarter)
names(dataset)[which(names(dataset) == "month")] <- "quarter"
dataset$quarter <- as.factor(dataset$quarter)

# חלוקת duration לקטגוריות
call_time <- max(dataset$duration)
time_breaks <- c(0, 120, 300, call_time)
time_labels <- c("until 2 minutes", "2-5 minutes", "more than 5 minutes")
dataset$duration_binned <- cut(dataset$duration, breaks = time_breaks, labels = time_labels)

# חלוקת campaign לקטגוריות
campaign_binned <- vector("character", length = nrow(dataset))
campaign_binned[dataset$campaign == 1] <- "until 2 times"
campaign_binned[dataset$campaign >= 2] <- "more than 2 times"
dataset$campaign_binned <- as.factor(campaign_binned)

# חלוקת pdays לקטגוריות
pdays_binned <- vector("character", length = nrow(dataset))
pdays_binned[dataset$pdays == -1] <- "no_connection"
pdays_binned[dataset$pdays > 0 & dataset$pdays <= 60] <- "under half a year"
pdays_binned[dataset$pdays > 60] <- "More than half a year"
dataset$pdays_binned <- as.factor(pdays_binned)

# המרת previous לפקטור
dataset$previous <- as.factor(dataset$previous)

# המרת poutcome לפקטור
dataset$poutcome <- as.factor(dataset$poutcome)

# מחיקת נתונים לא רלוונטיים
dataset$balance <- NULL
dataset$duration <- NULL
dataset$campaign <- NULL
dataset$pdays <- NULL
dataset$previous <- NULL
dataset$day <- NULL
dataset$poutcome <- NULL

# הצגת מבנה הנתונים לאחר המחיקה
str(dataset)

# הסרת שורות עם ערכים חסרים
dataset <- na.omit(dataset)

# סיכום הנתונים לאחר המחיקה
summary(dataset)

########################## EDA #############################

# התקנת חבילות נדרשות במידה ולא מותקנות
if (!require(ggplot2)) install.packages('ggplot2')
if (!require(GGally)) install.packages('GGally')
if (!require(scatterplot3d)) install.packages('scatterplot3d')
if (!require(psych)) install.packages('psych')

# טעינת ספריות נדרשות
library(ggplot2)
library(GGally)
library(scatterplot3d)
library(psych)

# בדיקת קשר בין גיל להפקדה
ggplot(dataset, aes(x = age, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Age Group", x = "Age Group", y = "Proportion") +
  scale_fill_manual(values = c("lightblue", "lightgreen"))

# בדיקת קשר בין סוג המשרה להפקדה
ggplot(dataset, aes(x = job, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Job Type", x = "Job Type", y = "Proportion") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("pink", "purple"))

# בדיקת קשר בין המצב המשפחתי להפקדה
ggplot(dataset, aes(x = marital, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Marital Status", x = "Marital Status", y = "Proportion") +
  scale_fill_manual(values = c("orange", "blue"))

# בדיקת קשר בין השכלה להפקדה
ggplot(dataset, aes(x = education, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Education Level", x = "Education Level", y = "Proportion") +
  scale_fill_manual(values = c("yellow", "green"))

# בדיקת קשר בין יתרת חשבון להפקדה
ggplot(dataset, aes(x = balance_binned, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Account Balance", x = "Account Balance", y = "Proportion") +
  scale_fill_manual(values = c("red", "cyan"))

# בדיקת קשר בין סוג התקשרות להפקדה
ggplot(dataset, aes(x = contact, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Contact Type", x = "Contact Type", y = "Proportion") +
  scale_fill_manual(values = c("brown", "pink"))

# בדיקת קשר בין משכנתא להפקדה
ggplot(dataset, aes(x = housing, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Housing Loan", x = "Housing Loan", y = "Proportion") +
  scale_fill_manual(values = c("darkblue", "lightblue"))

# בדיקת קשר בין הלוואה אישית להפקדה
ggplot(dataset, aes(x = loan, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Personal Loan", x = "Personal Loan", y = "Proportion") +
  scale_fill_manual(values = c("darkgreen", "lightgreen"))

# בדיקת קשר בין רבעון להפקדה
ggplot(dataset, aes(x = quarter, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Quarter", x = "Quarter", y = "Proportion") +
  scale_fill_manual(values = c("blue", "yellow"))

# בדיקת קשר בין משך השיחה להפקדה
ggplot(dataset, aes(x = duration_binned, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Call Duration", x = "Call Duration", y = "Proportion") +
  scale_fill_manual(values = c("purple", "orange"))

# בדיקת קשר בין מספר הקמפיינים להפקדה
ggplot(dataset, aes(x = campaign_binned, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Campaign Contact", x = "Campaign Contact", y = "Proportion") +
  scale_fill_manual(values = c("darkorange", "darkgreen"))

# בדיקת קשר בין מספר הימים שעברו מאז יצירת הקשר האחרון להפקדה
ggplot(dataset, aes(x = pdays_binned, fill = deposit)) + 
  geom_bar(position = "fill") +
  labs(title = "Deposit Status by Days Since Last Contact", x = "Days Since Last Contact", y = "Proportion") +
  scale_fill_manual(values = c("purple", "lightyellow"))

################# מודלים ###################

################# רגרסיה לוגיסטית ##################

# התקנת חבילות נדרשות במידה ולא מותקנות
packages <- c("dplyr", "caret", "caTools", "ROCR", "ggplot2", "pROC", "glmnet")
installed_packages <- packages %in% rownames(installed.packages())
if (any(!installed_packages)) {
  install.packages(packages[!installed_packages])
}

# טעינת ספריות נדרשות
library(dplyr)
library(caret)
library(caTools)
library(ROCR)
library(ggplot2)
library(pROC)
library(glmnet)

# קריאת הנתונים
dataset <- read.csv('C:/Users/CHENA/Documents/R project bank/Bank Marketing Dataset.csv')

# המרת עמודת deposit לערכים בינאריים
dataset$deposit <- ifelse(dataset$deposit == "yes", 1, 0)

# המרת משתנים קטגוריים לדמי משתנים
dummies <- dummyVars(deposit ~ ., data = dataset)
dataset_dummies <- predict(dummies, newdata = dataset)
dataset_dummies <- as.data.frame(dataset_dummies)

# הוספת עמודת deposit מחדש
dataset_dummies$deposit <- dataset$deposit

# חלוקה לקבוצות אימון ובדיקה
set.seed(123)
split <- sample.split(dataset_dummies$deposit, SplitRatio = 0.7)
train_set <- subset(dataset_dummies, split == TRUE)
test_set <- subset(dataset_dummies, split == FALSE)

# הרצת מודל רגרסיה לוגיסטית עם רגולריזציה
x_train <- as.matrix(train_set[, -ncol(train_set)])
y_train <- train_set$deposit
x_test <- as.matrix(test_set[, -ncol(test_set)])
y_test <- test_set$deposit

# הרצת המודל
set.seed(123)
cv_glmnet <- cv.glmnet(x_train, y_train, family = "binomial", alpha = 0.5)

# מציאת lambda האופטימלי
lambda_opt <- cv_glmnet$lambda.min

# חיזוי על קבוצת הבדיקה
predict_glmnet <- predict(cv_glmnet, s = lambda_opt, newx = x_test, type = "response")
predicted_glmnet <- ifelse(predict_glmnet > 0.4, 1, 0)

# מטריצת בלבול - מודל glmnet
cf_glmnet <- table(y_test, predicted_glmnet)

# חישוב מדדי הדיוק
TP_glmnet <- cf_glmnet["1", "1"]
TN_glmnet <- cf_glmnet["0", "0"]
FP_glmnet <- cf_glmnet["0", "1"]
FN_glmnet <- cf_glmnet["1", "0"]

Precision_glmnet <- TP_glmnet / (TP_glmnet + FP_glmnet)
Recall_glmnet <- TP_glmnet / (TP_glmnet + FN_glmnet)
Specificity_glmnet <- TN_glmnet / (TN_glmnet + FP_glmnet)
NPV_glmnet <- TN_glmnet / (TN_glmnet + FN_glmnet)
Accuracy_glmnet <- (TP_glmnet + TN_glmnet) / (TP_glmnet + TN_glmnet + FP_glmnet + FN_glmnet)

# יצירת טבלה מסודרת להצגת תוצאות מדדי הדיוק
results_glmnet <- data.frame(
  Metric = c("Precision", "Recall", "Specificity", "NPV", "Accuracy"),
  Value = c(round(Precision_glmnet, 4), round(Recall_glmnet, 4), round(Specificity_glmnet, 4), round(NPV_glmnet, 4), round(Accuracy_glmnet, 4))
)

cat("Performance Metrics for Logistic Regression with Regularization:\n")
print(results_glmnet)

# מטריצת בלבול - מודל glm
actual <- test_set$deposit
cf_glm <- table(actual, predicted_glmnet)

# הדפסת מטריצת הבלבול בצורה מסודרת
confusion_matrix_df <- data.frame(
  " " = c("Predicted No", "Predicted Yes"),
  "Actual No" = c(cf_glm["0", "0"], cf_glm["0", "1"]),
  "Actual Yes" = c(cf_glm["1", "0"], cf_glm["1", "1"])
)
print("Confusion Matrix:")
print(confusion_matrix_df)

# הדפסת כמות הרשומות בכל קטגוריה
cat("Actual vs Predicted Counts:\n")
cat("True Positives: ", cf_glm["1", "1"], "\n")
cat("True Negatives: ", cf_glm["0", "0"], "\n")
cat("False Positives: ", cf_glm["0", "1"], "\n")
cat("False Negatives: ", cf_glm["1", "0"], "\n")

######################## Random Forest ##################################

# התקנת חבילות אם לא מותקנות
if (!require(randomForest)) install.packages("randomForest")
if (!require(rpart)) install.packages("rpart")
if (!require(rpart.plot)) install.packages("rpart.plot")

library(randomForest)
library(rpart)
library(rpart.plot)

# המרת עמודת deposit לערכים בינאריים
dataset$deposit <- as.factor(ifelse(dataset$deposit == 1, "yes", "no"))

# חלוקה לקבוצות אימון ובדיקה
set.seed(123)  # הגדרת seed ליכולת שיחזור
split <- sample.split(dataset$deposit, SplitRatio = 0.7)
train_set <- subset(dataset, split == TRUE)
test_set <- subset(dataset, split == FALSE)

# בדיקת הקטגוריות בקבוצת האימון
cat("קטגוריות ב-train_set$deposit:\n")
print(table(train_set$deposit))

# אם יש רק קטגוריה אחת, נציג הודעה ונפסיק את הביצוע
if(length(unique(train_set$deposit)) < 2) {
  stop("נדרשות לפחות שתי קטגוריות בקבוצת האימון לביצוע סיווג.")
}

# הרצת מודל יער אקראי
rf_model <- randomForest(deposit ~ ., data = train_set, ntree = 100, mtry = 2, importance = TRUE)

# סיכום המודל
print(rf_model)

# יצירת וקטור חיזוי על בסיס ה-test set
predict_rf <- predict(rf_model, newdata = test_set, type = "response")

# מטריצת בלבול - מודל יער אקראי
cf_rf <- table(test_set$deposit, predict_rf)

# הדפסת מטריצת הבלבול בצורה מסודרת
confusion_matrix_rf <- data.frame(
  " " = c("Predicted No", "Predicted Yes"),
  "Actual No" = c(cf_rf["no", "no"], cf_rf["no", "yes"]),
  "Actual Yes" = c(cf_rf["yes", "no"], cf_rf["yes", "yes"])
)
print("Confusion Matrix for Random Forest:")
print(confusion_matrix_rf)

# חישוב מדדי הדיוק עבור יער אקראי
TP_rf <- ifelse("yes" %in% rownames(cf_rf) & "yes" %in% colnames(cf_rf), cf_rf["yes", "yes"], 0)
TN_rf <- ifelse("no" %in% rownames(cf_rf) & "no" %in% colnames(cf_rf), cf_rf["no", "no"], 0)
FP_rf <- ifelse("no" %in% rownames(cf_rf) & "yes" %in% colnames(cf_rf), cf_rf["no", "yes"], 0)
FN_rf <- ifelse("yes" %in% rownames(cf_rf) & "no" %in% colnames(cf_rf), cf_rf["yes", "no"], 0)

# הוספת בדיקות כדי להימנע מחלוקה באפס
Precision_rf <- ifelse((TP_rf + FP_rf) > 0, TP_rf / (TP_rf + FP_rf), NA)
Recall_rf <- ifelse((TP_rf + FN_rf) > 0, TP_rf / (TP_rf + FN_rf), NA)
Specificity_rf <- ifelse((TN_rf + FP_rf) > 0, TN_rf / (TN_rf + FP_rf), NA)
NPV_rf <- ifelse((TN_rf + FN_rf) > 0, TN_rf / (TN_rf + FN_rf), NA)
Accuracy_rf <- (TP_rf + TN_rf) / (TP_rf + TN_rf + FP_rf + FN_rf)

Precision_rf <- TP_rf / (TP_rf + FP_rf)
Recall_rf <- TP_rf / (TP_rf + FN_rf)
Specificity_rf <- TN_rf / (TN_rf + FP_rf)
NPV_rf <- TN_rf / (TN_rf + FN_rf)
Accuracy_rf <- (TP_rf + TN_rf) / (TP_rf + TN_rf + FP_rf + FN_rf)

# הדפסת תוצאות מדדי הדיוק
print(paste("Precision:", round(Precision_rf, 4)))
print(paste("Recall:", round(Recall_rf, 4)))
print(paste("Specificity:", round(Specificity_rf, 4)))
print(paste("NPV:", round(NPV_rf, 4)))
print(paste("Accuracy:", round(Accuracy_rf, 4)))

# יצירת טבלה מסודרת להצגת תוצאות מדדי הדיוק עבור Random Forest
results_rf <- data.frame(
  Metric = c("Precision", "Recall", "Specificity", "NPV", "Accuracy"),
  Value = c(round(Precision_rf, 4), round(Recall_rf, 4), round(Specificity_rf, 4), round(NPV_rf, 4), round(Accuracy_rf, 4))
)

cat("Performance Metrics for Random Forest:\n")
print(results_rf)

# הרצת עץ החלטות לצורך ויזואליזציה
tree_model <- rpart(deposit ~ ., data = train_set, method = "class")

# ויזואליזציה של העץ
rpart.plot(tree_model, main = "עץ החלטה לחיזוי הפקדה")

############XXXXXXXXXXXX XGB Boost ############################

# התקנת חבילות נדרשות במידה ולא מותקנות
packages <- c("dplyr", "caret", "caTools", "ROCR", "ggplot2", "pROC", "glmnet", "xgboost")
installed_packages <- packages %in% rownames(installed.packages())
if (any(!installed_packages)) {
  install.packages(packages[!installed_packages])
}

library(dplyr)
library(caret)
library(caTools)
library(ROCR)
library(ggplot2)
library(pROC)
library(glmnet)
library(xgboost)

# הכנת הנתונים לפורמט המתאים ל-XGBoost
# הפיכת עמודת deposit לערכים בינאריים
dataset$deposit <- ifelse(dataset$deposit == "yes", 1, 0)

# חלוקה לקבוצות אימון ובדיקה
set.seed(123)
split <- sample.split(dataset$deposit, SplitRatio = 0.7)
train_set <- subset(dataset, split == TRUE)
test_set <- subset(dataset, split == FALSE)

# המרת העמודות ל-dummy variables
dummies_model <- dummyVars(deposit ~ ., data = train_set)
train_dummies <- predict(dummies_model, newdata = train_set)
test_dummies <- predict(dummies_model, newdata = test_set)

# המרת הנתונים למטריצות עבור XGBoost
train_matrix <- xgb.DMatrix(data = as.matrix(train_dummies), label = train_set$deposit)
test_matrix <- xgb.DMatrix(data = as.matrix(test_dummies), label = test_set$deposit)

# הגדרת הפרמטרים למודל
params <- list(
  objective = "binary:logistic",
  eval_metric = "error",
  max_depth = 10,
  eta = 0.2,
  nthread = 4,
  verbosity = 1,
  scale_pos_weight = 1.5  # העלאת משקל המקרים החיוביים
)

# הרצת המודל
xgb_model <- xgb.train(
  params = params,
  data = train_matrix,
  nrounds = 750,
  watchlist = list(train = train_matrix, eval = test_matrix),
  early_stopping_rounds = 20,
  class_weights = c(0.6, 1.4)   # העלאת משקל המקרים החיובים
)

# יצירת וקטור חיזוי על בסיס ה-test set
predict_xgb <- predict(xgb_model, newdata = test_matrix)
predicted_xgb <- ifelse(predict_xgb > 0.5, 1, 0)

# מטריצת בלבול - מודל XGBoost
cf_xgb <- table(test_set$deposit, predicted_xgb)

# הדפסת מטריצת הבלבול בצורה מסודרת
onfusion_matrix_df <- data.frame(
  " " = c("Predicted No", "Predicted Yes"),
  "Actual No" = c(cf_xgb["0", "0"], cf_xgb["0", "1"]),
  "Actual Yes" = c(cf_xgb["1", "0"], cf_xgb["1", "1"])
)
print("Confusion Matrix:")
print(confusion_matrix_df)

# חישוב מדדי הדיוק
TP_xgb <- cf_xgb[2, 2]
TN_xgb <- cf_xgb[1, 1]
FP_xgb <- cf_xgb[1, 2]
FN_xgb <- cf_xgb[2, 1]

Precision_xgb <- TP_xgb / (TP_xgb + FP_xgb)
Recall_xgb <- TP_xgb / (TP_xgb + FN_xgb)
Specificity_xgb <- TN_xgb / (TN_xgb + FP_xgb)
NPV_xgb <- TN_xgb / (TN_xgb + FN_xgb)
Accuracy_xgb <- (TP_xgb + TN_xgb) / (TP_xgb + TN_xgb + FP_xgb + FN_xgb)

# הדפסת תוצאות מדדי הדיוק בצורה אלגנטית
results <- data.frame(
  Metric = c("Precision", "Recall", "Specificity", "NPV", "Accuracy"),
  Value = c(round(Precision_xgb, 4), round(Recall_xgb, 4), round(Specificity_xgb, 4), round(NPV_xgb, 4), round(Accuracy_xgb, 4))
)

print("Performance Metrics:")
print(results)

# חשיבות המשתנים במודל XGBoost
importance_matrix <- xgb.importance(model = xgb_model)
print("חשיבות המשתנים:")
print(importance_matrix)

# הגדרת גבולות התרשים
par(mar = c(5, 5, 5, 5))

# ויזואליזציה של חשיבות המשתנים במודל XGBoost
# הגדרת חלון גרפי חדש עם גודל מתאים
dev.new(width = 15, height = 8)

# ציור התרשים
xgb.plot.importance(importance_matrix, cex = 0.5)

################ השוואה בין האלגוריתמים ##########
# יצירת טבלה להשוואת הפרמטרים
results <- data.frame(
  Model = c("רגרסיה לוגיסטית", "יער אקראי", "XGBoost"),
  Precision = c(round(Precision_glmnet, 4), round(Precision_rf, 4), round(Precision_xgb, 4)),
  Recall = c(round(Recall_glmnet, 4), round(Recall_rf, 4), round(Recall_xgb, 4)),
  Specificity = c(round(Specificity_glmnet, 4), round(Specificity_rf, 4), round(Specificity_xgb, 4)),
  NPV = c(round(NPV_glmnet, 4), round(NPV_rf, 4), round(NPV_xgb, 4)),
  Accuracy = c(round(Accuracy_glmnet, 4), round(Accuracy_rf, 4), round(Accuracy_xgb, 4))
)

print("השוואת מדדי ביצוע:")
for(i in 1:nrow(results)) {
  cat("\n", results$Model[i], ":\n")
  cat("  Precision:   ", results$Precision[i], "\n")
  cat("  Recall:      ", results$Recall[i], "\n")
  cat("  Specificity: ", results$Specificity[i], "\n")
  cat("  NPV:         ", results$NPV[i], "\n")
  cat("  Accuracy:    ", results$Accuracy[i], "\n")
}


#############################   ROC ו-AUC  ######################################
# התקנת חבילות נדרשות במידה ולא מותקנות
if (!require(pROC)) install.packages("pROC")
if (!require(ROCR)) install.packages("ROCR")
library(pROC)
library(ROCR)

# יצירת תרשים ROC ומדידת AUC עבור Logistic Regression
predict_glmnet_numeric <- as.numeric(predict_glmnet[,1])  # המרה לווקטור נומרי
roc_glm <- roc(test_set$deposit, predict_glmnet_numeric)
auc_glm <- auc(roc_glm)
cat("AUC Logistic Regression: ", auc_glm, "\n")

# יצירת תרשים ROC ומדידת AUC עבור Random Forest
predict_rf_numeric <- as.numeric(predict_rf) - 1  # המרה לווקטור נומרי (0 ו-1)
roc_rf <- roc(test_set$deposit, predict_rf_numeric)
auc_rf <- auc(roc_rf)
cat("AUC Random Forest: ", auc_rf, "\n")

# יצירת תרשים ROC ומדידת AUC עבור XGBoost
roc_xgb <- roc(test_set$deposit, predict_xgb)
auc_xgb <- auc(roc_xgb)
cat("AUC XGBoost: ", auc_xgb, "\n")

# ציור עקומות ROC להשוואה
par(mfrow = c(1, 1), mar = c(5, 5, 4, 2) + 0.1)
plot(roc_glm, col = "red", main = "עקומות ROC עבור רגרסיה לוגיסטית, יער אקראי ו-XGBoost", cex.main = 1.5, cex.lab = 1.2, cex.axis = 1.2, lwd = 2)
lines(roc_rf, col = "blue", lwd = 2)
lines(roc_xgb, col = "green", lwd = 2)
legend("bottomright", legend = c(paste("רגרסיה לוגיסטית (AUC =", round(auc_glm, 2), ")"), 
                                 paste("יער אקראי (AUC =", round(auc_rf, 2), ")"), 
                                 paste("XGBoost (AUC =", round(auc_xgb, 2), ")")), 
       col = c("red", "blue", "green"), lty = 1, lwd = 2, cex = 1.2)

# פונקציה ליצירת תרשים Gain
gain_chart <- function(labels, scores, model_name) {
  pred <- prediction(scores, labels)
  perf <- performance(pred, "tpr", "rpp")
  plot(perf, col = "blue", main = paste("תרשים Gain -", model_name), cex.main = 1.5, cex.lab = 1.2, cex.axis = 1.2)
  lines(x = c(0, 1), y = c(0, 1), col = "red", lty = 2) # קו ייחוס
}

# ציור תרשימי Gain
par(mfrow = c(1, 3), mar = c(5, 5, 4, 2) + 0.1)
gain_chart(test_set$deposit, predict_glmnet_numeric, "רגרסיה לוגיסטית")
gain_chart(test_set$deposit, predict_rf_numeric, "יער אקראי")
gain_chart(test_set$deposit, predict_xgb, "XGBoost")

# הצגת הערכים המקסימליים לכל מדד
cat("\nערכים מקסימליים לכל מדד:\n")
for(col in names(results)[-1]) {  # מתעלם מעמודת Model
  max_value <- max(results[[col]])
  max_model <- results$Model[which.max(results[[col]])]
  cat(sprintf("%s: %s (%s)\n", col, round(max_value, 4), max_model))
}
############################## ROI ############################

# טעינת ספריות נדרשות
library(ggplot2)
library(reshape2)

# הגדרת עלויות ותועלות
cost_FP <- 100  # עלות חיזוי חיובי שגוי
cost_FN <- 200  # עלות חיזוי שלילי שגוי
benefit_TP <- 1000  # תועלת חיזוי חיובי נכון
benefit_TN <- 500  # תועלת חיזוי שלילי נכון

# חישוב עלות-תועלת עבור כל מודל
calculate_economic_model <- function(confusion_matrix, cost_FP, cost_FN, benefit_TP, benefit_TN) {
  TP <- ifelse("TRUE" %in% colnames(confusion_matrix) & "1" %in% rownames(confusion_matrix), confusion_matrix["1", "TRUE"], 0)
  TN <- ifelse("FALSE" %in% colnames(confusion_matrix) & "0" %in% rownames(confusion_matrix), confusion_matrix["0", "FALSE"], 0)
  FP <- ifelse("TRUE" %in% colnames(confusion_matrix) & "0" %in% rownames(confusion_matrix), confusion_matrix["0", "TRUE"], 0)
  FN <- ifelse("FALSE" %in% colnames(confusion_matrix) & "1" %in% rownames(confusion_matrix), confusion_matrix["1", "FALSE"], 0)
  
  total_cost <- (FP * cost_FP) + (FN * cost_FN)
  total_benefit <- (TP * benefit_TP) + (TN * benefit_TN)
  net_benefit <- total_benefit - total_cost
  
  return(net_benefit)
}

# חישוב ROI עבור כל מודל
calculate_roi <- function(confusion_matrix, cost_FP, cost_FN, benefit_TP, benefit_TN) {
  TP <- ifelse("TRUE" %in% colnames(confusion_matrix) & "1" %in% rownames(confusion_matrix), confusion_matrix["1", "TRUE"], 0)
  TN <- ifelse("FALSE" %in% colnames(confusion_matrix) & "0" %in% rownames(confusion_matrix), confusion_matrix["0", "FALSE"], 0)
  FP <- ifelse("TRUE" %in% colnames(confusion_matrix) & "0" %in% rownames(confusion_matrix), confusion_matrix["0", "TRUE"], 0)
  FN <- ifelse("FALSE" %in% colnames(confusion_matrix) & "1" %in% rownames(confusion_matrix), confusion_matrix["1", "FALSE"], 0)
  
  total_cost <- (FP * cost_FP) + (FN * cost_FN)
  total_benefit <- (TP * benefit_TP) + (TN * benefit_TN)
  net_benefit <- total_benefit - total_cost
  
  roi <- (net_benefit / total_cost) * 100
  return(roi)
}

# חישוב עלות, תועלת ו-ROI עבור כל מודל וכל ערך cut-off
calculate_metrics <- function(model_scores, test_labels, cost_FP, cost_FN, benefit_TP, benefit_TN) {
  cutOff <- seq(0, 1, by = 0.1)
  results <- sapply(cutOff, function(cut_off) {
    confusion_matrix <- table(test_labels, model_scores > cut_off)
    if (all(c("0", "1") %in% rownames(confusion_matrix)) & all(c("TRUE", "FALSE") %in% colnames(confusion_matrix))) {
      net_benefit <- calculate_economic_model(confusion_matrix, cost_FP, cost_FN, benefit_TP, benefit_TN)
      roi <- calculate_roi(confusion_matrix, cost_FP, cost_FN, benefit_TP, benefit_TN)
      total_cost <- (confusion_matrix["0", "TRUE"] * cost_FP) + (confusion_matrix["1", "FALSE"] * cost_FN)
      return(c(net_benefit, roi, total_cost))
    } else {
      return(c(NA, NA, NA))
    }
  })
  return(results)
}

# וודא שיש לך את החיזויים הנכונים לכל מודל
results_glm <- calculate_metrics(predict_glmnet_numeric, test_set$deposit, cost_FP, cost_FN, benefit_TP, benefit_TN)
results_rf <- calculate_metrics(predict_rf_numeric, test_set$deposit, cost_FP, cost_FN, benefit_TP, benefit_TN)
results_xgb <- calculate_metrics(predict_xgb, test_set$deposit, cost_FP, cost_FN, benefit_TP, benefit_TN)

# הכנת הנתונים לגרפים
cutOff <- seq(0, 1, by = 0.1)
net_benefit_df <- data.frame(
  cutOff = cutOff,
  LogisticRegression = results_glm[1, ],
  RandomForest = results_rf[1, ],
  XGBoost = results_xgb[1, ]
)
roi_df <- data.frame(
  cutOff = cutOff,
  LogisticRegression = results_glm[2, ],
  RandomForest = results_rf[2, ],
  XGBoost = results_xgb[2, ]
)
cost_df <- data.frame(
  cutOff = cutOff,
  LogisticRegression = results_glm[3, ],
  RandomForest = results_rf[3, ],
  XGBoost = results_xgb[3, ]
)

# המרת הנתונים לפורמט מתאים ל-ggplot2
melted_net_benefit <- melt(net_benefit_df, id.vars = "cutOff")
melted_roi <- melt(roi_df, id.vars = "cutOff")
melted_cost <- melt(cost_df, id.vars = "cutOff")

# סינון ערכים NA מהנתונים לפני יצירת הגרפים
melted_net_benefit <- melted_net_benefit[complete.cases(melted_net_benefit), ]
melted_roi <- melted_roi[complete.cases(melted_roi), ]
melted_cost <- melted_cost[complete.cases(melted_cost), ]

# גרף השוואת עלות-תועלת
ggplot(melted_net_benefit, aes(x = cutOff, y = value, color = variable)) +
  geom_line() +
  geom_point() +
  ggtitle("Net Benefit Comparison Across Models") +
  labs(x = "Cut Off Value", y = "Net Benefit") +
  scale_color_manual(values = c("red", "blue", "green")) +
  guides(color = guide_legend(title = "Model")) +
  theme_minimal()

# גרף השוואת ROI
ggplot(melted_roi, aes(x = cutOff, y = value, color = variable)) +
  geom_line() +
  geom_point() +
  ggtitle("ROI Comparison Across Models") +
  labs(x = "Cut Off Value", y = "ROI (%)") +
  scale_color_manual(values = c("red", "blue", "green")) +
  guides(color = guide_legend(title = "Model")) +
  theme_minimal()

# גרף השוואת עלות
ggplot(melted_cost, aes(x = cutOff, y = value, color = variable)) +
  geom_line() +
  geom_point() +
  ggtitle("Cost Comparison Across Models") +
  labs(x = "Cut Off Value", y = "Total Cost") +
  scale_color_manual(values = c("red", "blue", "green")) +
  guides(color = guide_legend(title = "Model")) +
  theme_minimal()

# התקנת והטענת חבילת knitr אם היא לא מותקנת
if (!require(knitr)) install.packages("knitr")
library(knitr)

# חישוב עלות מינימלית עבור כל מודל
min_cost_glm <- min(results_glm[3, ], na.rm = TRUE)
min_cost_rf <- min(results_rf[3, ], na.rm = TRUE)
min_cost_xgb <- min(results_xgb[3, ], na.rm = TRUE)

# יצירת data frame עם העלויות המינימליות
min_costs <- data.frame(
  Model = c("Logistic Regression", "Random Forest", "XGBoost"),
  MinimumCost = c(min_cost_glm, min_cost_rf, min_cost_xgb)
)

# עיצוב והדפסת הטבלה
print("Minimum Costs for Each Model:")
kable(min_costs, format = "pipe", align = c('l', 'r'), 
      col.names = c("Model", "Minimum Cost"),
      digits = 2)

# מציאת המודל עם העלות המינימלית הנמוכה ביותר
best_model <- min_costs$Model[which.min(min_costs$MinimumCost)]
lowest_cost <- min(min_costs$MinimumCost)

# הדפסת המודל הטוב ביותר
cat("\nBest Performing Model (Lowest Minimum Cost):\n")
cat(paste(best_model, "with a minimum cost of", round(lowest_cost, 2)))
