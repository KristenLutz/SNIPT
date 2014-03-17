-- to load this file -> source <file path>

--1 INTERACTION MAIN TABLE
-----------------------------------------------
CREATE TABLE SNIPT.ppi(
ppi_id bigint NOT NULL auto_increment,
protein_A_id int NOT NULL, 
protein_B_id int NOT NULL,
link text NOT NULL,
interaction_type_id int NULL,
PRIMARY KEY(ppi_id)
);

insert into SNIPT.ppi (ppi_id,protein_A_id, protein_B_id, link, interaction_type_id)
VALUE (1, 1, 2, "www.google.ca", 1);
select * from SNIPT.ppi;


-- 2 PROTEIN DESCRIPTION TABLE!!!
---------------------------------------------------
CREATE TABLE Protein(
protein_id int NOT NULL,
protein_desc longtext NULL,
protein_of_interest tinyint(1) DEFAULT 0,
PRIMARY KEY(protein_id)
);


INSERT INTO SNIPT.Protein (protein_id, protein_desc, protein_of_interest)
VALUE (1, "example protein", 1);

SELECT * FROM SNIPT.Protein;


-- 3 protein alias section
-------------------------------------------------------
CREATE TABLE SNIPT.Protein_Alias (
protein_id int NOT NULL,
protein_name text NOT NULL
);

INSERT INTO SNIPT.Protein_Alias(protein_id, protein_name) VALUES (1, "example1");
INSERT INTO SNIPT.Protein_Alias(protein_id, protein_name) VALUES (2, "example2");
SELECT * from SNIPT.Protein_Alias;
--ppi alias
CREATE INDEX idx_protein_id ON Protein_Alias (protein_id);

-- LINK TABLE
--CREATE TABLE SNIPT.Link(
--link_id int NOT NULL auto_increment,
--url text NOT NULL,
--data_published datetime NOT NULL,
--source_name varchar(140) NOT NULL,
--PRIMARY KEY (link_id)
--);

--INSERT INTO SNIPT.Link(link_id, url, data_published, source_name)
--VALUES (1, "www.google.ca", "", "nature");
--SELECT * FROM SNIPT.Link;

-- CREATE TABLE Cell_Type(
-- cell_type_id int NOT NULL auto_increment,
-- cell_type_name varchar(140),
-- PRIMARY KEY (cell_type_id)
-- );

-- 4 INTERACTION TYPE
______________________________________________
CREATE TABLE SNIPT.Interaction_Type(
interaction_type_id int NOT NULL auto_increment,
interaction_type_name varchar(140),
PRIMARY KEY (interaction_type_id)
);

INSERT INTO SNIPT.Interaction_Type(interaction_type_id, interaction_type_name)
VALUES (1, "phosphorylation");

SELECT * FROM SNIPT.Interaction_Type;

-- SUMMARY OF TABLES
_________________________________________
SELECT * FROM SNIPT.Interaction_Type;
SELECT * FROM SNIPT.Protein;
SELECT * from SNIPT.Protein_Alias;
select * from SNIPT.ppi;
-- changes: (as of Feb 05)
-- moved protein_desc from Protein Alias to Protein
-- merged protein_alias_id with protein_id (use Entreez number as id)
-- protein_alias has no primary key as many of the same protein_id can be there
-- changes: (as of Mar 04)
-- merge table elements, renamed and added more columns

SELECT a.protein_name AS proteinA, interaction_type_name, b.protein_name AS proteinB, link
FROM SNIPT.ppi, SNIPT.Protein_Alias a, SNIPT.Protein_Alias b, SNIPT.Interaction_Type
WHERE ppi.Protein_A_id = a.protein_id
AND ppi.Protein_B_id = b.protein_id
AND ppi.interaction_type_id = Interaction_Type.interaction_type_id;

CREATE VIEW SNIPT.proteinInteractions AS SELECT a.protein_name AS proteinA, interaction_type_name, b.protein_name AS proteinB, link
FROM SNIPT.ppi, SNIPT.Protein_Alias a, SNIPT.Protein_Alias b, SNIPT.Interaction_Type
WHERE ppi.Protein_A_id = a.protein_id
AND ppi.Protein_B_id = b.protein_id
AND ppi.interaction_type_id = Interaction_Type.interaction_type_id;