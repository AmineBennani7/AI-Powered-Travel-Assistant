import xml.etree.ElementTree as ET
import csv
import os

# Configuration for folders and files
data_folder = "data"
xml_file = "food_hygiene.xml"
os.makedirs(data_folder, exist_ok=True)  # Create the folder if it doesn't exist

# Mapping of business types to categories
category_mapping = {
    "Hotel/bed & breakfast/guest house": "hotels",
    "Mobile caterer": "mobile_caterers",
    "Pub/bar/nightclub": "pubs",
    "Restaurant/Cafe/Canteen": "restaurants",
    "Retailers - other": "retailers_other",
    "Retailers - supermarkets/hypermarkets": "retailers_supermarkets",
    "Takeaway/sandwich shop": "takeaways",
}

# Categories to be combined into a single CSV
combined_categories = ["hotels", "mobile_caterers", "retailers_supermarkets", "takeaways"]

# Keywords to exclude irrelevant businesses
excluded_keywords = ["catering", "farmers", "hospitals", "distributors", "school", "manufacturers/packers"]

# Function to extract data from an establishment
def extract_establishment_data(establishment):
    data = {
        "FHRSID": establishment.find("FHRSID").text if establishment.find("FHRSID") is not None else None,
        "BusinessName": establishment.find("BusinessName").text if establishment.find("BusinessName") is not None else None,
        "BusinessType": establishment.find("BusinessType").text if establishment.find("BusinessType") is not None else None,
        "FullAddress": ", ".join(filter(None, [
            establishment.find("AddressLine1").text if establishment.find("AddressLine1") is not None else "",
            establishment.find("AddressLine2").text if establishment.find("AddressLine2") is not None else "",
            establishment.find("AddressLine3").text if establishment.find("AddressLine3") is not None else "",
        ])).strip(),
        "PostCode": establishment.find("PostCode").text if establishment.find("PostCode") is not None else None,
        "Hygiene": establishment.find("./Scores/Hygiene").text if establishment.find("./Scores/Hygiene") is not None else "N/A",
        "Structural": establishment.find("./Scores/Structural").text if establishment.find("./Scores/Structural") is not None else "N/A",
        "ConfidenceInManagement": establishment.find("./Scores/ConfidenceInManagement").text if establishment.find("./Scores/ConfidenceInManagement") is not None else "N/A",
    }
    return data

# Function to save data to a CSV file
def save_to_csv(filename, headers, rows):
    with open(filename, "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(headers)
        writer.writerows(rows)
    print(f"File '{filename}' created with {len(rows)} records.")

# Load and parse the XML file
tree = ET.parse(xml_file)
root = tree.getroot()

# Dictionary to store data by category
category_data = {category: [] for category in category_mapping.values()}

# List to store combined data
combined_rows = []

# Process each establishment
for establishment in root.findall(".//EstablishmentDetail"):
    data = extract_establishment_data(establishment)

    # Skip establishments with missing or irrelevant data
    if None in [data["FHRSID"], data["BusinessName"], data["BusinessType"], data["FullAddress"], data["PostCode"]]:
        continue
    if any(keyword in data["BusinessType"].lower() for keyword in excluded_keywords):
        continue

    # Create the row for the CSV
    row = [data["FHRSID"], data["BusinessName"], data["BusinessType"], data["FullAddress"], data["PostCode"], data["Hygiene"], data["Structural"], data["ConfidenceInManagement"]]

    # Save to the corresponding category
    category = category_mapping.get(data["BusinessType"])
    if category:
        category_data[category].append(row)

        # If the category is in the combined list, add to combined_rows
        if category in combined_categories:
            combined_rows.append(row)

# Save the combined CSV file
combined_filename = os.path.join(data_folder, "combined_places.csv")
save_to_csv(combined_filename, ["FHRSID", "BusinessName", "BusinessType", "FullAddress", "PostCode", "Hygiene", "Structural", "ConfidenceInManagement"], combined_rows)

# Save each category to a separate CSV file (except combined categories)
for category, rows in category_data.items():
    if category not in combined_categories:  # Avoid saving combined categories again
        category_filename = os.path.join(data_folder, f"{category}.csv")
        save_to_csv(category_filename, ["FHRSID", "BusinessName", "BusinessType", "FullAddress", "PostCode", "Hygiene", "Structural", "ConfidenceInManagement"], rows)