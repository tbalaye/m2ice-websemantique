DROP TABLE IF EXISTS Position_Term;
DROP TABLE IF EXISTS Contain;
DROP TABLE IF EXISTS Term;
DROP TABLE IF EXISTS Paragraph;
DROP TABLE IF EXISTS Document;

CREATE TABLE Document(
  idDocument INTEGER NOT NULL AUTO_INCREMENT,
  label VARCHAR(200),
  pathFile VARCHAR(200),
  CONSTRAINT pk_document PRIMARY KEY(idDocument)
);
-- Index pour éviter les doublons à l'insertion
CREATE UNIQUE INDEX ind_Document_PathFile ON Document(pathFile);
-- Utiliser la commande :
-- INSERT INTO Document (label, pathFile) VALUES (@var1, @var2)
--   ON DUPLICATE KEY UPDATE label = VALUES(label);

CREATE TABLE Paragraph(
  idParagraph INTEGER NOT NULL AUTO_INCREMENT,
  xpath VARCHAR(200),
  idDocument INTEGER,
  CONSTRAINT pk_paragraph PRIMARY KEY(idParagraph),
  CONSTRAINT fk_paragraphDocument FOREIGN KEY(idDocument) REFERENCES Document(idDocument)
);

CREATE TABLE Term(
  idTerm INTEGER NOT NULL AUTO_INCREMENT,
  label VARCHAR(6),
  CONSTRAINT pk_term PRIMARY KEY(idTerm)
);
-- Index pour éviter les doublons à l'insertion
CREATE UNIQUE INDEX ind_term_label ON Term(label);
-- Utiliser la commande :
-- INSERT IGNORE INTO Term(label) VALUES (@var1);

CREATE TABLE Contain(
  idContain INTEGER NOT NULL AUTO_INCREMENT,
  weight DECIMAL(12,8),
  isTitle BOOLEAN,
  idTerm INTEGER,
  idParagraph INTEGER,
  CONSTRAINT pk_contain PRIMARY KEY(idContain),
  CONSTRAINT fk_containTerm FOREIGN KEY(idParagraph) REFERENCES Paragraph(idParagraph),
  CONSTRAINT fk_containParagraph FOREIGN KEY(idTerm) REFERENCES Term(idTerm)
);

-- Position est un mot clé SQL
CREATE TABLE Position_Term(
  idPosition INTEGER NOT NULL AUTO_INCREMENT,
  valuePos INTEGER,
  word VARCHAR(50),
  idContain INTEGER,
  CONSTRAINT pk_position PRIMARY KEY(idPosition),
  CONSTRAINT fk_positionContain FOREIGN KEY(idContain) REFERENCES Contain(idContain)
);
