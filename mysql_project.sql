/*
	# MYSQL Final Project
    # Student: Mauricio Sanchez
    # Date: Nov 29th 2015
    #Description: To create a new database called BuildingEnergy. All of the work below should be
completed in the BuildingEnergy database. The SQL script should be self-contained, such that if it runs again it
will re-create the database.
*/

DROP DATABASE IF EXISTS BuildingEnergy;

CREATE DATABASE BuildingEnergy;

USE BuildingEnergy;

CREATE TABLE EnergyCategories(
  energycat_id INT(6) NOT NULL,
  category_type VARCHAR(255),
  PRIMARY KEY (energycat_id)
);

CREATE TABLE EnergyTypes(
  energytype_id INT(6) NOT NULL,
  type_name VARCHAR(255),
  energycat_id INT(6),
  PRIMARY KEY (energytype_id),
  FOREIGN KEY (energycat_id) REFERENCES EnergyCategories(energycat_id) ON DELETE CASCADE
); 

INSERT INTO EnergyCategories (energycat_id, category_type)
VALUES
(1, 'Fossil'),
(2, 'Renewable');

INSERT INTO EnergyTypes (energytype_id, type_name, energycat_id)
VALUES
(1, 'Gas', 1),
(2, 'Steam', 1),
(3, 'Fuel Oil', 1),
(4, 'Solar', 2),
(5, 'Wind', 2),
(6, 'Electricity', 1);

#3. Write a JOIN statement that shows the energy categories and associated energy types that you entered. 
SELECT EnergyCategories.category_type, 
       EnergyTypes.type_name
FROM EnergyCategories
LEFT JOIN EnergyTypes 
ON EnergyCategories.energycat_id=EnergyTypes.energycat_id
GROUP BY EnergyCategories.category_type, 
         EnergyTypes.type_name
ORDER BY EnergyCategories.category_type ASC;

#4.You should add a table called Buildings. There should be a many-to-many relationship between Building and EnergyTypes. 
CREATE TABLE Buildings(
  building_id INT(6) NOT NULL,
  building_name VARCHAR(255),
  PRIMARY KEY (building_id)
); 

INSERT INTO Buildings(building_id, building_name)
VALUES
(1, 'Empire State Building'),
(2, 'Chrysler Building'),
(3, 'Borough of Manhattan Community College');

#5 Write a JOIN statement that shows the buildings and associated energy types for each building.

CREATE TABLE Buildings_by_Energytype(
  building_id INT(6) NOT NULL,
  energytype_id INT(6) NOT NULL,
  PRIMARY KEY (building_id, energytype_id),
  FOREIGN KEY (building_id) REFERENCES Buildings(building_id) ON UPDATE CASCADE,
  FOREIGN KEY (energytype_id) REFERENCES EnergyTypes(energytype_id) ON UPDATE CASCADE
);

INSERT INTO Buildings_by_Energytype (building_id, energytype_id)
VALUES
(1,1),
(1,2),
(1,6),
(2,2),
(2,6),
(3,2),
(3,4),
(3,6);

SELECT Buildings.building_name AS 'Building',
       EnergyTypes.type_name AS 'Energy Type'
FROM Buildings
LEFT JOIN Buildings_by_Energytype
ON Buildings.building_id = Buildings_by_Energytype.building_id
LEFT JOIN EnergyTypes
ON EnergyTypes.energytype_id = Buildings_by_Energytype.energytype_id
GROUP BY Buildings.building_name,
       EnergyTypes.type_name
ORDER BY Buildings.building_name ASC; 

# 6. Please add this information to the BuildingEnergy database, inserting rows as needed in various tables.

INSERT INTO Buildings(building_id, building_name)
VALUES
(4, 'Bronx Lion House'),
(5, 'Brooklyn Childrens Museum');

INSERT INTO EnergyTypes (energytype_id, type_name, energycat_id)
VALUES
(7, 'Geothermal', 2);

INSERT INTO Buildings_by_Energytype (building_id, energytype_id)
VALUES
(4,7),
(5,6),
(5,7);
 
# 7. Write a SQL query that displays all of the buildings that use Renewable Energies.
SELECT Buildings.building_name AS 'Building',
       EnergyTypes.type_name AS 'Energy Type',
       (SELECT category_type FROM EnergyCategories
		WHERE EnergyCategories.energycat_id = EnergyTypes.energycat_id
        GROUP BY category_type) AS 'Energy Category'
FROM Buildings
LEFT JOIN Buildings_by_Energytype
ON Buildings.building_id = Buildings_by_Energytype.building_id
LEFT JOIN EnergyTypes
ON EnergyTypes.energytype_id = Buildings_by_Energytype.energytype_id
WHERE EnergyTypes.energycat_id IN (2)
GROUP BY Buildings.building_name,
       EnergyTypes.type_name
ORDER BY Buildings.building_name ASC; 

# 8. Write a SQL query that shows the frequency with which energy types are used in various buildings.
SELECT EnergyTypes.type_name AS 'Energy Type',
       COUNT(*) AS 'Frequency'
FROM Buildings
LEFT JOIN Buildings_by_Energytype
ON Buildings.building_id = Buildings_by_Energytype.building_id
LEFT JOIN EnergyTypes
ON EnergyTypes.energytype_id = Buildings_by_Energytype.energytype_id
GROUP BY EnergyTypes.type_name
HAVING COUNT(Frequency) > 0
ORDER BY Frequency DESC; 

/* 9. EER Diagram has been uploaded to GitHub
   d. Suppose you want to track changes over time in energy type preferences in New York City buildings. What
      information should you add to each table? What might a report that shows the trends over time look like?
   ANSWER:
   I would create a field called effective date and add it to the Buildings_by_Energytype table to record the energy
   choice by building over time where the history of energy preference would remain in the same table. It would be easy
   to store past, present and future data per building enabling one to see the trends in building energy consumption
   prefenreces over time.




*/
