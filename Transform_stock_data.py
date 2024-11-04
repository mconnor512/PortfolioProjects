# Preparing data for Tableau
# I want to combine the data into one excel file and add a ticker column
import pandas as pd

# Load the Excel file
file_path = 'Technology_Top25_HistoricalData.xlsx'
excel_data = pd.ExcelFile(file_path)

# Initialize an empty list to hold the dataframes from each sheet
all_data = []

# Process each sheet, adding a 'Ticker' column with the sheet name
for sheet_name in excel_data.sheet_names:
    sheet_data = excel_data.parse(sheet_name)
    sheet_data['Ticker'] = sheet_name  # Add the ticker column with the sheet name
    all_data.append(sheet_data)

# Concatenate all the sheets into a single DataFrame
combined_data = pd.concat(all_data, ignore_index=True)

# Save the combined data to a new Excel file
output_path = 'Technology_Top25_HistoricalData_for_Tableau.xlsx'
combined_data.to_excel(output_path, index=False)

print(f"Data has been saved to {output_path}")

# Reminder that I am executing this by choosing Desktop as directory in my Terminal, or else will need to specify file path 
# Replace file name for different sectors as needed
# Reminder to clean data!