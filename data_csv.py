import xml.etree.ElementTree as ET
import csv
import os

# Define the data folder where all CSV files will be saved
data_folder = "data"
os.makedirs(data_folder, exist_ok=True)  # Create the folder if it doesn't exist

# Load and parse the XML file
xml_file = "food_hygiene.xml"  # Update the filename if different
tree = ET.parse(xml_file)
root = tree.getroot()

# Dictionary to store data by category
category_data = {
    "hotels": [],
    "mobile_caterers": [],
    "pubs": [],
    "restaurants": [],
    "retailers_other": [],
    "retailers_supermarkets": [],
    "takeaways": [],
}

# Mapping of business types to specific categories
category_mapping = {
    "Hotel/bed & breakfast/guest house": "hotels",
    "Mobile caterer": "mobile_caterers",
    "Pub/bar/nightclub": "pubs",
    "Restaurant/Cafe/Canteen": "restaurants",
    "Retailers - other": "retailers_other",
    "Retailers - supermarkets/hypermarkets": "retailers_supermarkets",
    "Takeaway/sandwich shop": "takeaways",
}

# Create the general CSV file inside the "data" folder
csv_filename = os.path.join(data_folder, "oxford_food_hygiene_cleaned.csv")
with open(csv_filename, "w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["FHRSID", "BusinessName", "BusinessType", "FullAddress", "PostCode", "Hygiene", "Structural", "ConfidenceInManagement"])

    # Extract relevant information from each business
    for establishment in root.findall(".//EstablishmentDetail"):
        fhrsid = establishment.find("FHRSID").text if establishment.find("FHRSID") is not None else None
        business_name = establishment.find("BusinessName").text if establishment.find("BusinessName") is not None else None
        business_type = establishment.find("BusinessType").text if establishment.find("BusinessType") is not None else None
        address1 = establishment.find("AddressLine1").text if establishment.find("AddressLine1") is not None else ""
        address2 = establishment.find("AddressLine2").text if establishment.find("AddressLine2") is not None else ""
        address3 = establishment.find("AddressLine3").text if establishment.find("AddressLine3") is not None else ""
        postcode = establishment.find("PostCode").text if establishment.find("PostCode") is not None else None

        # Extract hygiene scores
        hygiene = establishment.find("./Scores/Hygiene").text if establishment.find("./Scores/Hygiene") is not None else "N/A"
        structural = establishment.find("./Scores/Structural").text if establishment.find("./Scores/Structural") is not None else "N/A"
        confidence = establishment.find("./Scores/ConfidenceInManagement").text if establishment.find("./Scores/ConfidenceInManagement") is not None else "N/A"

        # Create a single address field
        full_address = ", ".join(filter(None, [address1, address2, address3])).strip()

        # Skip businesses with missing key data
        if None in [fhrsid, business_name, business_type, full_address, postcode]:
            continue

        # Filter out irrelevant businesses
        excluded_keywords = ["catering", "farmers", "hospitals", "distributors", "school", "manufacturers/packers"]
        if any(keyword in business_type.lower() for keyword in excluded_keywords):
            continue

        # Write to the main CSV file
        row = [fhrsid, business_name, business_type, full_address, postcode, hygiene, structural, confidence]
        writer.writerow(row)

        # Save to the corresponding category
        category = category_mapping.get(business_type, None)
        if category:
            category_data[category].append(row)


# Save each category as a separate CSV inside the "data" folder
for category, rows in category_data.items():
    category_filename = os.path.join(data_folder, f"{category}.csv")
    with open(category_filename, "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["FHRSID", "BusinessName", "BusinessType", "FullAddress", "PostCode", "Hygiene", "Structural", "ConfidenceInManagement"])
        writer.writerows(rows)
    print(f"File '{category_filename}' created with {len(rows)} records.")

