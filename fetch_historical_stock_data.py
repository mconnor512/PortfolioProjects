import yfinance as yf
import pandas as pd

# Define the list of tickers
tickers = ["NVDA", "AAPL", "MSFT", "AVGO", "ORCL", "CRM", "AMD", "CSCO", "ACN", "ADBE",
           "NOW", "IBM", "TXN", "QCOM", "INTU", "UBER", "AMAT", "ANET", "ADP", "PANW",
           "FI", "MU", "ADI", "INTC", "LRCX"]

# Define the new date range for the historical data
start_date = "2023-01-01"
end_date = "2024-01-01"

# Create an Excel writer object
excel_file = "Technology_Top25_HistoricalData.xlsx"

try:
    with pd.ExcelWriter(excel_file, engine='openpyxl') as writer:
        # Loop through each ticker and fetch its data
        for ticker in tickers:
            print(f"Fetching data for {ticker}...")
            try:
                # Download historical data
                data = yf.download(ticker, start=start_date, end=end_date)

                # Check if data is retrieved; sometimes yfinance may return an empty DataFrame
                if data.empty:
                    print(f"No data found for {ticker}. Skipping...")
                    continue

                # Remove timezone information from the index
                if data.index.tz is not None:
                    data.index = data.index.tz_localize(None)

                # Add the data to the Excel file with the ticker as the sheet name
                data.to_excel(writer, sheet_name=ticker)
                print(f"Data for {ticker} added to Excel.")

            except Exception as e:
                print(f"Error fetching data for {ticker}: {e}")
                continue

    print(f"Data saved to {excel_file}")

except Exception as e:
    print(f"Failed to save data to Excel file: {e}")
