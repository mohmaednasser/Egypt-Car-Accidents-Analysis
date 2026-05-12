import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestRegressor

df = pd.read_excel(r"C:\Users\OSHA\Downloads\Book1.xlsx")

month_map = {
    'January':1, 'February':2, 'March':3, 'April':4,
    'May':5, 'June':6, 'July':7, 'August':8,
    'September':9, 'October':10, 'November':11, 'December':12
}

df['Month'] = df['Month'].map(month_map)


df = df.sort_values(['Year', 'Month'])

df['Time'] = range(1, len(df)+1)

df = pd.get_dummies(df, columns=['Governorates'])


X = df.drop(['Injuries'], axis=1)
y = df['Injuries']


model = RandomForestRegressor(n_estimators=200, random_state=42)
model.fit(X, y)


df['Predicted'] = model.predict(X)

monthly_df = df.groupby(['Year', 'Month'])[['Injuries', 'Predicted']].sum().reset_index()
monthly_df = monthly_df.sort_values(['Year', 'Month'])

plt.figure()

plt.plot(monthly_df['Injuries'], label='Actual')
plt.plot(monthly_df['Predicted'], label='Predicted')

plt.legend()
plt.title("Actual vs Predicted Injuries (Monthly)")
plt.xlabel("Time")
plt.ylabel("Number of Injuries")

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

future_df['Predicted_Injuries'] = model.predict(future_df)
future_df['Predicted_Injuries'] = future_df['Predicted_Injuries'].clip(lower=0)

future_monthly = future_df.groupby(['Year', 'Month'])['Predicted_Injuries'].sum().reset_index()

plt.figure()

plt.plot(monthly_df['Injuries'], label='Actual')

plt.plot(range(len(monthly_df), len(monthly_df)+12),
         future_monthly['Predicted_Injuries'],
         label='Forecast 2025')

plt.legend()
plt.title("Injuries Forecast (2025)")
plt.xlabel("Time")
plt.ylabel("Number of Injuries")

plt.show()