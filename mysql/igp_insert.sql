-- NOTE: insert to parent then to child
-- Protein (parent of ppi, protein_alias):
-- case 1 - w/ protein_desc
INSERT INTO Protein (protein_id, protein_desc, protein_of_interest)
VALUES (?, ?, ?);
-- case 2 - w/o protein_desc
INSERT INTO Protein (protein_id, protein_of_interest)
VALUES (?, ?);

-- Link (parent of ppi)
INSERT INTO Link (link_id, url, date_published, source_name)
VALUES (?, ?, ?, ?);

-- Interaction_Type (parent of ppi)
INSERT INTO Interaction_Type (interaction_type_id, interaction_type_name)
VALUES (?, ?);

-- Protein Alias (child of protein)
INSERT INTO Protein_Alias (protein_id, protein_name)
VALUES (?, ?);

-- PPI

-- get link_id
SELECT link_id
FROM Link
ORDER BY link_id DESC
LIMIT 1;
-- get interaction_type_id
SELECT interaction_type_id
FROM Interaction_Type
ORDER BY interaction_type_id DESC
LIMIT 1;

INSERT INTO Protein_Protein_Interaction(
proteinA_id, 
proteinB_id,
link_id,
cell_type_name,
interaction_type_id)
VALUES (?, ?, ?, ?, ?);

-- input to db: protein_id (entreez gene id), protein_name
-- protein_desc, protein_of_interest, url, date_published, source_name
-- interaction_type_name, cell_type_name