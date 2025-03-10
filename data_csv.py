#https://ratings.food.gov.uk/api/open-data-files/FHRS269en-GB.xml COFFEE, RESTAURANTS, CLUBS, PUBS

import xml.etree.ElementTree as ET
import csv

# Load and parse the XML file
xml_file = "food_hygiene.xml"  # Update with your actual XML filename
tree = ET.parse(xml_file)
root = tree.getroot()


# Prepare CSV file
csv_filename = "oxford_food_hygiene_cleaned.csv"
with open(csv_filename, "w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["FHRSID", "BusinessName", "BusinessType", "FullAddress", "PostCode", "Hygiene", "Structural", "ConfidenceInManagement"])

    # Extract relevant fields from each EstablishmentDetail
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



        # Create a single address field by joining available address parts
        full_address = ", ".join(filter(None, [address1, address2, address3])).strip()

        # Skip entries with any missing key fields (FHRSID, Name, Type, Address, Postcode)
        if None in [fhrsid, business_name, business_type, full_address, postcode]:
            continue
        
        # Convert business type to lowercase and exclude unwanted categories
        excluded_keywords = ["catering", "farmers", "hospitals", "distributors", "school", "manufacturers/packers"]

        if any(keyword in business_type.lower() for keyword in excluded_keywords):
            continue

       

        # Write row to CSV
        writer.writerow([fhrsid, business_name, business_type, full_address, postcode,hygiene,structural,confidence])

print(f"CSV file '{csv_filename}' created successfully! ✅")

# Set to store unique business categories
business_categories = set()

# Extract BusinessType from each EstablishmentDetail
for establishment in root.findall(".//EstablishmentDetail"):
    business_type = establishment.find("BusinessType").text if establishment.find("BusinessType") is not None else None
    if business_type:
        business_categories.add(business_type)

# Print all unique business categories
print("Unique Business Categories Found:")
for category in sorted(business_categories):  # Sorted for better readability
    print(category)



# Set para almacenar los tipos de negocios únicos en el CSV
csv_business_categories = set()

# Leer el CSV y extraer la columna BusinessType
with open(csv_filename, "r", newline="", encoding="utf-8") as file:
    reader = csv.reader(file)
    next(reader)  # Saltar la primera fila (cabecera)

    for row in reader:
        if len(row) > 2:  # Asegurar que hay suficientes columnas
            business_type = row[2]  # La columna BusinessType está en el índice 2
            if business_type:
                csv_business_categories.add(business_type)

# Imprimir las categorías únicas encontradas en el CSV
print("\n📂 Unique Business Categories in CSV (After Creation):")
for category in sorted(csv_business_categories):
    print(f"✔ {category}")
