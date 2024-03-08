Overview:
This web application provides a multivariate analysis related to Titanic passengers. Users can explore various aspects of the Titanic dataset including passenger class, age, survival status, gender, fare, and port of embarkation. The application offers interactive visualizations such as scatter plots, colored pie charts, and correlation analysis to help users gain insights into the Titanic dataset.

Features:

Data Exploration Tab: Users can select two variables to visualize their relationship through a scatter plot. Additionally, a colored pie chart reflects the distribution of one variable's categories.
Correlation Analysis Tab: Users can select two variables to calculate their correlation coefficient, providing insights into the relationship between different attributes.
Data Table Tab: Displays the entire Titanic dataset in a tabular format. Users can also download the dataset in CSV format for further analysis.
Instructions:

Data Exploration Tab:
Select two variables (X and Y) from the dropdown menus.
Adjust the sample count slider to control the number of passengers displayed in the visualizations.
Click the "Now You See!" button to generate the scatter plot and pie chart.
Correlation Analysis Tab:
Choose two variables from the dropdown menus.
Click the "Relations!!!" button to calculate the correlation coefficient between the selected variables.
Data Table Tab:
View the entire Titanic dataset in tabular format.
Click the "Download CSV" button to download the dataset for offline analysis.
Requirements:

R Programming Language
Shiny package
Shinythemes package
ggplot2 package
DT package
dplyr package
Installation:

Install R from CRAN
Install required packages using install.packages("package_name")
Run the provided code in an R environment to launch the web application.
Credits:

This web application is created using the Shiny framework in R.
Data source: Titanic dataset from Kaggle.
