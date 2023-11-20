# Import libraries
import pandas as pd
import numpy as np
import math
import random
from sklearn.linear_model import LinearRegression
from IPython.display import display, HTML
from ipywidgets import interact_manual, widgets
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
import matplotlib
# Load WTA and ATP data
wta_22 = pd.read_html('https://www.espn.com/tennis/rankings/_/type/wta/season/2022')
wta_21 = pd.read_html('https://www.espn.com/tennis/rankings/_/type/wta/season/2021')
wta_20 = pd.read_html('https://www.espn.com/tennis/rankings/_/type/wta/season/2020')
wta_19 = pd.read_html('https://www.espn.com/tennis/rankings/_/type/wta/season/2019')
wta_18 = pd.read_html('https://www.espn.com/tennis/rankings/_/type/wta/season/2018')
wta_17 = pd.read_html('https://www.espn.com/tennis/rankings/_/type/wta/season/2017')
wta_16 = pd.read_html('https://www.espn.com/tennis/rankings/_/type/wta/season/2016')
wta_15 = pd.read_html('https://www.espn.com/tennis/rankings/_/type/wta/season/2015')
wta_14 = pd.read_html('https://www.espn.com/tennis/rankings/_/type/wta/season/2014')
wta_13 = pd.read_html('https://www.espn.com/tennis/rankings/_/type/wta/season/2013')
wta_12 = pd.read_html('https://www.espn.com/tennis/rankings/_/type/wta/season/2012')
atp_22 = pd.read_html('https://www.espn.com/tennis/rankings/_/season/2022')
atp_21 = pd.read_html('https://www.espn.com/tennis/rankings/_/season/2021')
atp_20 = pd.read_html('https://www.espn.com/tennis/rankings/_/season/2020')
atp_19 = pd.read_html('https://www.espn.com/tennis/rankings/_/season/2019')
atp_18 = pd.read_html('https://www.espn.com/tennis/rankings/_/season/2018')
atp_17 = pd.read_html('https://www.espn.com/tennis/rankings/_/season/2017')
atp_16 = pd.read_html('https://www.espn.com/tennis/rankings/_/season/2016')
atp_15 = pd.read_html('https://www.espn.com/tennis/rankings/_/season/2015')
atp_14 = pd.read_html('https://www.espn.com/tennis/rankings/_/season/2014')
atp_13 = pd.read_html('https://www.espn.com/tennis/rankings/_/season/2013')
atp_12 = pd.read_html('https://www.espn.com/tennis/rankings/_/season/2012')
# Put wta and atp data into data frames
wta_22df = pd.DataFrame(wta_22[0])
wta_21df = pd.DataFrame(wta_21[0])
wta_20df = pd.DataFrame(wta_20[0])
wta_19df = pd.DataFrame(wta_19[0])
wta_18df = pd.DataFrame(wta_18[0])
wta_17df = pd.DataFrame(wta_17[0])
wta_16df = pd.DataFrame(wta_16[0])
wta_15df = pd.DataFrame(wta_15[0])
wta_14df = pd.DataFrame(wta_14[0])
wta_13df = pd.DataFrame(wta_13[0])
wta_12df = pd.DataFrame(wta_12[0])
atp_22df = pd.DataFrame(atp_22[0])
atp_21df = pd.DataFrame(atp_21[0])
atp_20df = pd.DataFrame(atp_20[0])
atp_19df = pd.DataFrame(atp_19[0])
atp_18df = pd.DataFrame(atp_18[0])
atp_17df = pd.DataFrame(atp_17[0])
atp_16df = pd.DataFrame(atp_16[0])
atp_15df = pd.DataFrame(atp_15[0])
atp_14df = pd.DataFrame(atp_14[0])
atp_13df = pd.DataFrame(atp_13[0])
atp_12df = pd.DataFrame(atp_12[0])
# Join atp and wta (n and n+1) data and bind the joined rows together
wta_21_22df = pd.merge(wta_21df, wta_22df, on = 'NAME')
wta_20_21df = pd.merge(wta_20df, wta_21df, on = 'NAME')
wta_19_20df = pd.merge(wta_19df, wta_20df, on = 'NAME')
wta_18_19df = pd.merge(wta_18df, wta_19df, on = 'NAME')
wta_17_18df = pd.merge(wta_17df, wta_18df, on = 'NAME')
wta_16_17df = pd.merge(wta_16df, wta_17df, on = 'NAME')
wta_15_16df = pd.merge(wta_15df, wta_16df, on = 'NAME')
wta_14_15df = pd.merge(wta_14df, wta_15df, on = 'NAME')
wta_13_14df = pd.merge(wta_13df, wta_14df, on = 'NAME')
wta_12_13df = pd.merge(wta_12df, wta_13df, on = 'NAME')
wtadf = pd.concat([wta_21_22df, wta_20_21df, wta_19_20df, wta_18_19df, wta_17_18df, wta_16_17df, wta_15_16df, wta_14_15df, wta_13_14df, wta_12_13df])
atp_21_22df = pd.merge(atp_21df, atp_22df, on = 'NAME')
atp_20_21df = pd.merge(atp_20df, atp_21df, on = 'NAME')
atp_19_20df = pd.merge(atp_19df, atp_20df, on = 'NAME')
atp_18_19df = pd.merge(atp_18df, atp_19df, on = 'NAME')
atp_17_18df = pd.merge(atp_17df, atp_18df, on = 'NAME')
atp_16_17df = pd.merge(atp_16df, atp_17df, on = 'NAME')
atp_15_16df = pd.merge(atp_15df, atp_16df, on = 'NAME')
atp_14_15df = pd.merge(atp_14df, atp_15df, on = 'NAME')
atp_13_14df = pd.merge(atp_13df, atp_14df, on = 'NAME')
atp_12_13df = pd.merge(atp_12df, atp_13df, on = 'NAME')
atpdf = pd.concat([atp_21_22df, atp_20_21df, atp_19_20df, atp_18_19df, atp_17_18df, atp_16_17df, atp_15_16df, atp_14_15df, atp_13_14df, atp_12_13df])
# Plot the data
wtadf.plot.scatter(x='RK_x', y='RK_y', title = 'WTA Player Rank and Ranking in the Following Year', xlabel = 'Ranking in the "Current" Year', ylabel='Ranking in the Following Year')
wtadf.plot.scatter(x='POINTS_x', y='RK_y', title = 'WTA Player Points and Ranking in the Following Year', xlabel = 'Points in the "Current" Year', ylabel='Ranking in the Following Year')
atpdf.plot.scatter(x='RK_x',y='RK_y', title = 'ATP Player Rank and Ranking in the Following Year', xlabel = 'Ranking in the "Current" Year', ylabel='Ranking in the Following Year')
atpdf.plot.scatter(x='POINTS_x',y='RK_y', title = 'ATP Player Points and Ranking in the Following Year', xlabel = 'Points in the "Current" Year', ylabel='Ranking in the Following Year')
# Because the scatter plot for points and ranking appears to be concave, add a quadratic term for ranking points
wtadf = wtadf.assign(POINTS_squared = wtadf['POINTS_x'] ^ 2)
atpdf = atpdf.assign(POINTS_squared = atpdf['POINTS_x'] ^ 2)
# Modeling ranking in the next year with points and rank in the previous year  
random.seed(1234)
x= wtadf[['RK_x', 'POINTS_x', 'POINTS_squared']]
y = wtadf['RK_y']
x_train, x_test, y_train, y_test = train_test_split(x, y)
mlr = LinearRegression()  
mlr.fit(x_train, y_train)
wta_constant = mlr.intercept_
z=list(zip(x, mlr.coef_))
wta_rank_coefficient =z[0]
wta_rank_coefficient = wta_rank_coefficient[1:2]
wta_rank_coefficient = wta_rank_coefficient[0]
wta_points_coefficient = z[1]
wta_points_coefficient = wta_points_coefficient[1:2]
wta_points_coefficient = wta_points_coefficient[0]
wta_points_sq_coefficient = z[2]
wta_points_sq_coefficient = wta_points_sq_coefficient[1:2]
wta_points_sq_coefficient = wta_points_sq_coefficient[0]
x2=atpdf[['RK_x', 'POINTS_x', 'POINTS_squared']]
y2=atpdf['RK_y']
x2_train, x2_test, y2_train, y2_test = train_test_split(x2, y2)
mlr2 = LinearRegression()  
mlr2.fit(x_train, y_train)
atp_constant = mlr2.intercept_
z2 = list(zip(x2, mlr2.coef_))
atp_rank_coefficient = z[0]
atp_rank_coefficient = atp_rank_coefficient[1:2]
atp_rank_coefficient = atp_rank_coefficient[0]
atp_points_coefficient = z[1]
atp_points_coefficient = atp_points_coefficient[1:2]
atp_points_coefficient = atp_points_coefficient[0]
atp_points_sq_coefficient = z[2]
atp_points_sq_coefficient = atp_points_sq_coefficient[1:2]
atp_points_sq_coefficient = atp_points_sq_coefficient[0]
# Functions for wta and atp ranking
def wta_prediction(RK, POINTS, POINTS_SQ):
    rank = wta_constant + (wta_rank_coefficient * RK) + (wta_points_coefficient * POINTS) + (wta_points_sq_coefficient * POINTS_SQ)
    return rank
def atp_prediction(RK, POINTS, POINTS_SQ):
    rank = atp_constant + (atp_rank_coefficient * RK) + (atp_points_coefficient * POINTS) + (atp_points_sq_coefficient * POINTS_SQ)
    return rank
# Create interacts for wta and atp
wtanames = wta_22df['NAME']
atpnames = atp_22df['NAME']
@interact_manual(name = wtanames)
def main2(name):
    player_name = name
    df = pd.DataFrame([player_name],
                 columns = ['NAME'])
    df = df.merge(wta_22df, on='NAME', how='left')
    rankdf = wta_22df[ wta_22df['NAME'] == player_name]
    rank = rankdf.iat[0, 0]
    expected_ranking = round(wta_prediction(df['RK'][0], df['POINTS'][0], (df['POINTS'][0])^2))
    if expected_ranking <= 0:
        expected_ranking = 1
    else:
        expected_ranking = expected_ranking
    print(f"{player_name} was ranked #{rank} last year and is expected to be ranked #{expected_ranking} next year.")
@interact_manual(name = atpnames)
def main(name):
    player_name = name
    df = pd.DataFrame([player_name],
                 columns = ['NAME'])
    df = df.merge(atp_22df, on='NAME', how='left')
    rankdf = atp_22df[ atp_22df['NAME'] == player_name]
    rank = rankdf.iat[0, 0]
    expected_ranking = round(atp_prediction(df['RK'][0], df['POINTS'][0], (df['POINTS'][0])^2))
    if expected_ranking <= 0:
        expected_ranking = 1
    else:
        expected_ranking = expected_ranking
    print(f"{player_name} was ranked #{rank} last year and is expected to be ranked #{expected_ranking} next year.")
# How have the big 4 players performed and dominated over the years?
atp_21df = atp_21df.assign(YEAR = 2021)
atp_20df = atp_20df.assign(YEAR = 2020)
atp_19df = atp_19df.assign(YEAR = 2019)
atp_18df = atp_18df.assign(YEAR = 2018)
atp_17df = atp_17df.assign(YEAR = 2017)
atp_16df = atp_16df.assign(YEAR = 2016)
atp_15df = atp_15df.assign(YEAR = 2015)
atp_14df = atp_14df.assign(YEAR = 2014)
atp_13df = atp_13df.assign(YEAR = 2013)
atp_12df = atp_12df.assign(YEAR = 2012)
big4df = pd.concat([atp_12df, atp_13df, atp_14df, atp_15df, atp_16df, atp_17df, atp_18df, atp_19df, atp_20df, atp_21df])
federerdf = big4df[ big4df['NAME'] == 'Roger Federer']
nadaldf = big4df[ big4df['NAME'] == 'Rafael Nadal']
djokovicdf = big4df[ big4df['NAME'] == 'Novak Djokovic']
murraydf = big4df[ big4df['NAME'] == 'Andy Murray']
# How would they compare to someone who isn't as dominant?
isnerdf = big4df[ big4df['NAME'] == 'John Isner']
plotbig4 = big4df[ (big4df['NAME'] == 'Roger Federer') | (big4df['NAME'] == 'Rafael Nadal') | (big4df['NAME'] == 'Novak Djokovic') | (big4df['NAME'] == 'Andy Murray')]
plotbig4isner = big4df[ (big4df['NAME'] == 'Roger Federer') | (big4df['NAME'] == 'Rafael Nadal') | (big4df['NAME'] == 'Novak Djokovic') | (big4df['NAME'] == 'Andy Murray') | (big4df['NAME'] == 'John Isner')]
# How do all their individual rankings look year-by-year
federerdf.plot.scatter(x='YEAR', y='RK', color = 'red', edgecolor='black', xlabel = 'Year', ylabel = 'Rank', title = 'Roger Federer End-of-Year Ranking Scatterplot')
federerdf.plot.line(x='YEAR', y='RK', color = 'red', xlabel = 'Year', ylabel = 'Rank', title = 'Roger Federer End-of-Year Ranking by Year Line Graph')
nadaldf.plot.scatter(x='YEAR', y='RK', color = 'yellow', edgecolor='black', xlabel = 'Year', ylabel = 'Rank', title = 'Rafael Nadal End-of-Year Ranking Scatterplot')
nadaldf.plot.line(x='YEAR', y='RK', color = 'yellow', xlabel = 'Year', ylabel = 'Rank', title = 'Rafael Nadal End-of-Year Ranking by Year Line Graph')
djokovicdf.plot.scatter(x='YEAR', y='RK', color = 'blue', edgecolor='red', xlabel = 'Year', ylabel = 'Rank', title = 'Novak Djokovic End-of-Year Ranking Scatterplot')
djokovicdf.plot.line(x='YEAR', y='RK', color = 'blue', xlabel = 'Year', ylabel = 'Rank', title = 'Novak Djokovic End-of-Year Ranking by Year Line Graph')
murraydf.plot.scatter(x='YEAR', y='RK', color = 'red', edgecolor='blue', xlabel = 'Year', ylabel = 'Rank', title = 'Andy Murray End-of-Year Ranking Scatterplot')
murraydf.plot.line(x='YEAR', y='RK', color = 'red', xlabel = 'Year', ylabel = 'Rank', title = 'Andy Murray End-of-Year Ranking by Year Line Graph')
isnerdf.plot.scatter(x='YEAR', y='RK', color = 'black', edgecolor='blue', xlabel = 'Year', ylabel = 'Rank', title = 'John Isner End-of-Year Ranking Scatterplot')
isnerdf.plot.line(x='YEAR', y='RK', color = 'blue', xlabel = 'Year', ylabel = 'Rank', title = 'John Isner End-of-Year Ranking by Year Line Graph')
# How does the big 4 look collectively over the years?
plotbig4.plot.scatter(x='YEAR', y='RK', color = 'white', edgecolor = 'blue', xlabel = 'Year', ylabel = 'Player Ranking', title = 'Big 4 Rankings by Year Scatterplot')
# Create ranking data frame
df = pd.DataFrame({
    'federer': [federerdf.iat[0,0], federerdf.iat[1,0], federerdf.iat[2,0], federerdf.iat[3,0], federerdf.iat[4,0], federerdf.iat[5,0]],
    'nadal': [nadaldf.iat[0,0], nadaldf.iat[1,0], nadaldf.iat[2,0], nadaldf.iat[3,0], nadaldf.iat[4,0], nadaldf.iat[5,0]],
    'djokovic' : [djokovicdf.iat[0,0], djokovicdf.iat[1,0], djokovicdf.iat[2,0], djokovicdf.iat[3,0], djokovicdf.iat[4,0], djokovicdf.iat[5,0]],
    'murray' : [murraydf.iat[0,0], murraydf.iat[1,0], murraydf.iat[2,0], murraydf.iat[3,0], murraydf.iat[4,0], murraydf.iat[5,0]],
    'isner' : [isnerdf.iat[0,0], isnerdf.iat[1,0], isnerdf.iat[2,0], isnerdf.iat[3,0], isnerdf.iat[4,0], isnerdf.iat[5,0]]
})
# Create a plot
df['federer'].plot.line(color = 'red')
df['nadal'].plot.line(color = 'yellow')
df['djokovic'].plot.line(color = 'purple')
df['murray'].plot.line(color = 'blue', ylabel = 'Rank', title = 'Big 4 Rankings by Year Line Graph')
df
# How does the big 4 look collectively over the years compared to another top player?
plotbig4isner.plot.scatter(x= 'YEAR', y='RK', color = 'white', edgecolor = 'blue', xlabel = 'Year', ylabel = 'Player Ranking', title = 'Big 4 Rankings by Year (Including John Isner) Scatterplot')
# Run the plot with John Isner
df['federer'].plot.line(color = 'red')
df['nadal'].plot.line(color = 'yellow')
df['djokovic'].plot.line(color = 'purple')
df['murray'].plot.line(color = 'blue')
df['isner'].plot.line(ylabel = 'Rank', title = 'Big 4 Rankings by Year (Including John Isner) Line Graph')
