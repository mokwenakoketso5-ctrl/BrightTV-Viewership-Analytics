# BrightTV-Viewership-Analytics

## Introduction
The CEO of BightTV has an objective to grow the company's subcription base for the current financial year. The dataset with information on the user's profiles and viewer transactions were provided.

## Objective 
To extract insights from the provided dataset that will help the Custpmer Value Management team in decesion making to meet their objective.

## Planning plartform
- Miro(Flow diagram)
- Canva(Gantt chart)


## Coding plartform
*SQL on Snowflake*
- Handling null/missing values on both userprofiles and viewership tables using IFNULL function 
- Use CASE statements to create age groups from the userprofiles table
- Create a temporary table called users
- Format the date/time on viewership table, using TO_TIMESTAMP functions
- Use CASE statements to categorise days of week and watch time slots
- Create a temporary table from the viewership table and name it views
- Joing both temporary tables and export the data to Excel

## Data visualisation
Google sheet(Pivot Tables) and Google Looker Studio(Dashboard)
*The following charts were generated:*
- Monthly overview
- Weekly viewership trends
- Total views by time of day
- Total views by age groups
- Total views by chanel
- Total views by province
- Total views by gender


## Presentation
Canva(Slide presentation) contents
- User and usage trends of BrightTV
- Factors influencing consumption
- Summaries
- Recommendations
Sales recommendations

