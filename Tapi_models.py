import pandas as pd
import numpy as np
from statsmodels.tsa import ExponentialSmoothing, ARIMA, SARIMAX, VAR, VARMAX, Prophet, SimpleExpSmoothing
from sklearn.metrics import mean_squared_error

# Load the data
df = pd.read_csv("production_data.csv")

# Convert the date column to a datetime format
df['Date'] = pd.to_datetime(df['Date'])

# Set the date column as the index
df.set_index('Date', inplace=True)

# Define a function to train and fit the model based on the given model type
def train_model(df, model_type):
    if model_type == 'SES':
        model = SimpleExpSmoothing(df['Production'])
        result = model.fit()
    elif model_type == 'Holt':
        model = ExponentialSmoothing(df['Production'], trend='add')
        result = model.fit()
    elif model_type == 'Holt-Winters':
        model = ExponentialSmoothing(df['Production'], seasonal_periods=12, trend='add', seasonal='add')
        result = model.fit()
    elif model_type == 'ARIMA':
        model = ARIMA(df['Production'], order=(1,1,1))
        result = model.fit()
    elif model_type == 'SARIMA':
        model = SARIMAX(df['Production'], order=(1,1,1), seasonal_order=(0,1,1,12))
        result = model.fit()
    elif model_type == 'VAR':
        model = VAR(df)
        result = model.fit()
    elif model_type == 'VARMAX':
        model = VARMAX(df, order=(1,1))
        result = model.fit()
    else:
        model = Prophet()
        model.fit(df.reset_index().rename(columns={'Date':'ds', 'Production':'y'}))
        future = model.make_future_dataframe(periods=12, freq='MS')
        forecast = model.predict(future)
        result = forecast.set_index('ds')['yhat']
    return result

# Define a list of model types to try
model_types = ['SES', 'Holt', 'Holt-Winters', 'ARIMA', 'SARIMA', 'VAR', 'VARMAX', 'Prophet']

# Train and fit each model and calculate the MSE
mses = []
results = []
for model_type in model_types:
    result = train_model(df, model_type)
    results.append(result)
    mse = mean_squared_error(df['Production'].iloc[12:], result.iloc[12:])
    mses.append(mse)

# Choose the model with the lowest MSE
best_model_index = np.argmin(mses)
best_model = results[best_model_index]

# Generate the forecast for the next 12 months using the best model
forecast = best_model.forecast(12)

# Print the forecast
print(forecast)



