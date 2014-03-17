-- primary key constraints
ALTER TABLE Interaction_Type
ADD CONSTRAINT interaction_type_pk
PRIMARY KEY(interaction_type_id);

ALTER TABLE Protein_Protein_Interaction
ADD CONSTRAINT ppi_pk
PRIMARY KEY(ppi_id);

ALTER TABLE Link
ADD CONSTRAINT link_pk
PRIMARY KEY(link_id);

ALTER TABLE Protein
ADD CONSTRAINT protein_pk
PRIMARY KEY(protein_id);

-- foreign key constraints
ALTER TABLE Protein_Protein_Interaction
ADD CONSTRAINT ppi_must_have_link
FOREIGN KEY(link_id)
REFERENCES Link(link_id);

ALTER TABLE Protein_Protein_Interaction
ADD CONSTRAINT ppi_must_have_pA
FOREIGN KEY(proteinA__id)
REFERENCES Protein(protein_id);

ALTER TABLE Protein_Protein_Interaction
ADD CONSTRAINT ppi_must_have_pB
FOREIGN KEY(proteinB__id)
REFERENCES Protein(protein_id);

ALTER TABLE Protein_Alias
ADD CONSTRAINT alias_must_be_protein
FOREIGN KEY(protein__id)
REFERENCES Protein(protein_id);