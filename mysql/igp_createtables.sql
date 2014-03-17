-- to load this file -> source <file path>
CREATE TABLE Protein_Protein_Interaction(
ppi_id bigint NOT NULL auto_increment,
proteinA_id int NOT NULL, 
proteinB_id int NOT NULL,
link_id int NOT NULL,
cell_type_name varchar(140) NULL,
interaction_type_id int NULL,
PRIMARY KEY(ppi_id)
);

-- for protein_select where no = 0 and yes = 1
CREATE TABLE Protein(
protein_id int NOT NULL,
protein_desc longtext NULL,
protein_of_interest tinyint(1) DEFAULT 0,
PRIMARY KEY(protein_id)
);

CREATE TABLE Protein_Alias(
protein_id int NOT NULL,
protein_name int NOT NULL
);

CREATE INDEX idx_protein_id ON Protein_Alias (protein_id);

-- url to journal article (from rss) or public database
-- source_name includes RSS feed: <journal> and database: <db name>
CREATE TABLE Link(
link_id int NOT NULL auto_increment,
url text NOT NULL,
data_published datetime NOT NULL,
source_name varchar(140) NOT NULL,
PRIMARY KEY (link_id)
);

CREATE TABLE Interaction_Type(
interaction_type_id int NOT NULL auto_increment,
interaction_type_name varchar(140),
PRIMARY KEY (interaction_type_id)
);

-- log tables
CREATE TABLE PPI_log(
ppi_id bigint NOT NULL auto_increment,
proteinA_id int NOT NULL, 
proteinB_id int NOT NULL,
link_id int NOT NULL,
cell_type_name varchar(140) NULL,
interaction_type_id int NULL,
PRIMARY KEY(ppi_id)
);
-- changes: (as of Feb 05)
-- moved protein_desc from Protein Alias to Protein
-- merged protein_alias_id with protein_id (use Entreez number as id)
-- protein_alias has no primary key as many of the same protein_id can be there
-- changes: (as of Mar 04)
-- merge table elements, renamed and added more columns
-- changes: (as of Mar 09)
-- updated cell_type_name to Protein_Protein_Interaction

-- CREATE TABLE Cell_Type(
-- cell_type_id int NOT NULL auto_increment,
-- cell_type_name varchar(140),
-- PRIMARY KEY (cell_type_id)
-- );
