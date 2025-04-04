CREATE DATABASE NOTA_FISCAL_NORMALIZADA;

USE `NOTA_FISCAL_NORMALIZADA`;

CREATE TABLE `NOTA_FISCAL`(
		`NRO_NOTA` INT NOT NULL auto_increment primary KEY,
        `NM_CLIENTE` VARCHAR(256) NOT NULL,
        `END_CLIENTE` VARCHAR(256) NOT NULL,
        `NM_VENDEDOR` VARCHAR(256) NOT NULL,
        `DT_EMISSAO` DATETIME DEFAULT current_timestamp,
        `VL_TOTAL` FLOAT NOT NULL
);

CREATE TABLE `PRODUTO`(
	`COD_PROODUTO` INT NOT NULL auto_increment primary key,
    `DESC_PRODUTO` VARCHAR (256) NOT NULL,
    `UN_MED` CHAR(2) NOT NULL,
    `VL_PRODUTO` FLOAT NOT NULL
);

DROP TABLE `PRODUTO`;

CREATE TABLE `PRODUTO`(
	`COD_PRODUTO` INT NOT NULL auto_increment primary key,
    `DESC_PRODUTO` VARCHAR (256) NOT NULL,
    `UN_MED` CHAR(2) NOT NULL,
    `VL_PRODUTO` FLOAT NOT NULL
);

create TABLE `ITEM_NOTA_FISCAL`(
	`NRO_NOTA` INT NOT NULL,
    `COD_PRODUTO` INT NOT NULL,
    `QTD_PRODUTO` INT NOT NULL,
	`VL_PRECO` FLOAT NOT NULL,
    `VL_TOTAL` FLOAT NOT NULL,
    PRIMARY KEY (NRO_NOTA, COD_PRODUTO),
    constraint FK_NRO_NOTA_NOTA_FISCAL 
		foreign key(NRO_NOTA) references NOTA_FISCAL(NRO_NOTA),
	constraint FK_COD_PRODUTO_PRODUTO
		foreign key (COD_PRODUTO) references PRODUTO(COD_PRODUTO)
);

INSERT INTO `PRODUTO` (DESC_PRODUTO, UN_MED, VL_PRODUTO)
VALUES ('Leite','LT', 4.50);

INSERT INTO `PRODUTO` (DESC_PRODUTO, UN_MED, VL_PRODUTO)
VALUES ('Desodorante', 'UN', 8.00);

INSERT INTO `PRODUTO` (DESC_PRODUTO, UN_MED, VL_PRODUTO)
VALUES ('Salame', 'KG', 40.00);

SELECT * FROM `PRODUTO`;

-- NOTA FISCAL

INSERT INTO `NOTA_FISCAL`(NM_CLIENTE, END_CLIENTE, NM_VENDEDOR, VL_TOTAL)
VALUES ('Aragorn', 'Terra Média', 'Bilbo', 100.00);

INSERT INTO `NOTA_FISCAL`(NM_CLIENTE, END_CLIENTE, NM_VENDEDOR, VL_TOTAL)
VALUES ('Gandalf', 'Terra Média', 'Frodo', 100.00);

INSERT INTO `NOTA_FISCAL`(NM_CLIENTE, END_CLIENTE, NM_VENDEDOR, VL_TOTAL)
VALUES ('Bomromir', 'Mordor', 'Sam', 100.00);

INSERT INTO `NOTA_FISCAL`(NM_CLIENTE, END_CLIENTE, NM_VENDEDOR, VL_TOTAL)
VALUES ('Galadriel', 'Valinor', 'Saruman', 100.00);

SELECT * FROM `NOTA_FISCAL`;

-- Itens da Nota

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (1, 1, 1, 4.50, 4.50);

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (1, 2, 2, 40.00, 80.00);

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (1, 3, 10, 100.00, 1000.00);

--

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (2, 1, 1, 9.00, 9.00);

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (2, 2, 2, 50.00, 60.00);

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (2, 3, 10, 200.00, 2000.00);

--

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (3, 1, 1, 15.00, 15.00);

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (3, 2, 2, 5.00, 10.00);

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (3, 3, 10, 120.00, 1200.00);

--

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (4, 1, 1, 32.00, 32.00);

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (4, 2, 2, 420.00, 840.00);

INSERT INTO `ITEM_NOTA_FISCAL`(NRO_NOTA, COD_PRODUTO, QTD_PRODUTO, VL_PRECO, VL_TOTAL)
VALUES (4, 3, 10, 800.00, 8000.00);

SELECT * FROM `ITEM_NOTA_FISCAL`;

SELECT * FROM PRODUTO WHERE COD_PRODUTO = 3;

-- Upadate, atualizando dados de coluna em tabelas
UPDATE PRODUTO 
SET VL_PRODUTO = 45, DESC_PRODUTO = 'Atualizado',
UN_MED = 'CX'
WHERE COD_PRODUTO = 3;

-- DELETE, EXCLUINDO REGISTROS DE TABELAS
DELETE FROM PRODUTO 
WHERE COD_PRODUTO = 3;
-- Neste caso uma exceção sera lançada
-- Violação de constraint que amarra o produto ao item da nota fiscal
-- Não é possível excluir uma chave primária  que tem dependências em FKs

INSERT INTO PRODUTO (DESC_PRODUTO, UN_MED, VL_PRODUTO)
VALUES ('TESTE DELETE', 'LT', 5.50);

SELECT * FROM PRODUTO;
DELETE FROM PRODUTO WHERE COD_PRODUTO = 4;