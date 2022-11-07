import plotly.graph_objects as go
import pandas as pd
data = pd.read_csv('/Users/antoniaaguilera/ConsiliumBots Dropbox/antoniaaguilera@consiliumbots.com/iadb-segregation-paper/tables/sankey.csv', sep = ',')
inputs=data.to_dict('list')
print(inputs)
source1 = inputs['source']
target1 = inputs['destination']
value1 = inputs['id']
label = ['assigned', 'assigned', 'same school', 'different school', 'not enrolled', 'same school', 'different school', 'same school', 'different school'] 
lin = dict(source = source1, target = target1, value = value1)
node = dict(label = label, pad = 15, thickness = 5 )
data = go.Sankey(link = lin, node = node)

fig = go.Figure(data)

for x_coordinate, column_name in enumerate(["SAS","Beginning of Year","End of Year"]):
  fig.add_annotation(
          x=x_coordinate,
          y=1.05,
          xref="x",
          yref="paper",
          text=column_name,
          showarrow=False,
          font=dict(
              family="Courier New, monospace",
              size=16,
              color="tomato"
              ),
          align="center",
          )

fig.update_layout(
  title_text="Basic Sankey Diagram", 
  xaxis={
  'showgrid': False, # thin lines in the background
  'zeroline': False, # thick line at x=0
  'visible': False,  # numbers below
  },
  yaxis={
  'showgrid': False, # thin lines in the background
  'zeroline': False, # thick line at x=0
  'visible': False,  # numbers below
  }, plot_bgcolor='rgba(0,0,0,0)', font_size=10)


fig.show()
fig.write_html("sas_efficiency.html")