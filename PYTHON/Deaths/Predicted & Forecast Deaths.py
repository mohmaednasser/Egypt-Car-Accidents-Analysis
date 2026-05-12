import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestRegressor


df = pd.read_excel(r"C:\Users\OSHA\Downloads\Model DEATHS.xlsx")


month_map = {
    'January':1, 'February':2, 'March':3, 'April':4,
    'May':5, 'June':6, 'July':7, 'August':8,
    'September':9, 'October':10, 'November':11, 'December':12
}

df['Month'] = df['Category'].map(month_map)


df = df.dropna(subset=['Month'])


df = df.sort_values(['Year', 'Month'])


df['Time'] = range(1, len(df)+1)


df = df.drop(['Category'], axis=1)


df = pd.get_dummies(df, columns=['Governorates'])


X = df.drop(['Deaths'], axis=1)
y = df['Deaths']


model = RandomForestRegressor(
    n_estimators=300,
    max_depth=10,
    random_state=42
)

model.fit(X, y)


df['Predicted'] = model.predict(X)


monthly_df = df.groupby(['Year', 'Month'])[['Deaths', 'Predicted']].sum().reset_index()
monthly_df = monthly_df.sort_values(['Year', 'Month'])


plt.figure()

plt.plot(monthly_df['Deaths'], label='Actual')
plt.plot(monthly_df['Predicted'], label='Predicted')

plt.legend()
plt.title("Actual vs Predicted Deaths (Monthly)")
plt.xlabel("Time")
plt.ylabel("Number of Deaths")

plt.show()


last_time = df['Time'].max()

governorates = [col for col in df.columns if 'Governorates_' in col]

future_data = []

for i in range(1, 13):  
    for gov in governorates:
        row = {}

        row['Year'] = 2025
        row['Month'] = i
        row['Time'] = last_time + i

        for g in governorates:
            row[g] = 0
        
        row[gov] = 1

        future_data.append(row)

future_df = pd.DataFrame(future_data)


future_df = future_df[X.columns]


future_df['Predicted_Deaths'] = model.predict(future_df)
future_df['Predicted_Deaths'] = future_df['Predicted_Deaths'].clip(lower=0)


future_monthly = future_df.groupby(['Year', 'Month'])['Predicted_Deaths'].sum().reset_index()


plt.figure()

plt.plot(monthly_df['Deaths'], label='Actual')

plt.plot(
    range(len(monthly_df), len(monthly_df)+12),
    future_monthly['Predicted_Deaths'],
    label='Forecast 2025'
)

plt.legend()
plt.title("Deaths Forecast (2025)")
plt.xlabel("Time")
plt.ylabel("Number of Deaths")

plt.show()