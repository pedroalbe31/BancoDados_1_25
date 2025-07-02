CREATE DATABASE CINEMA;

USE CINEMA;

CREATE TABLE DISTRIBUIDORA (
    ID_DISTRIBUIDORA INT PRIMARY KEY AUTO_INCREMENT,
    NOME VARCHAR(100) NOT NULL
);

-- Tabela para armazenar informações sobre os cinemas
CREATE TABLE CINEMA (
    ID_CINEMA INT PRIMARY KEY AUTO_INCREMENT,
    NOME_CINEMA VARCHAR(100) NOT NULL,
    ENDERECO VARCHAR(255),
    TELEFONE VARCHAR(20),
    ID_DISTRIBUIDORA INT NOT NULL,
    FOREIGN KEY (ID_DISTRIBUIDORA) REFERENCES DISTRIBUIDORA(ID_DISTRIBUIDORA)
);

-- Tabela para armazenar informações sobre os filmes
CREATE TABLE FILME (
    ID_FILME INT PRIMARY KEY AUTO_INCREMENT,
    TITULO VARCHAR(255) NOT NULL,
    GENERO VARCHAR(255) NOT NULL,
    TIPO VARCHAR(50),
    DURACAO_MIN INT,
    DIRETOR VARCHAR(100)
);

-- Tabela para armazenar informações sobre os atores
CREATE TABLE ATOR (
    ID_ATOR INT PRIMARY KEY AUTO_INCREMENT,
    NOME_ATOR VARCHAR(100) NOT NULL,
    NACIONALIDADE VARCHAR(50),
    DATA_NASCIMENTO DATE
);

-- Tabela de junção para relacionamento N:N entre Filme e Ator
-- Um Filme pode ter MUITOS Atores
-- Um Ator pode participar de MUITOS Filmes
CREATE TABLE FILMEATOR (
    ID_FILME INT,
    ID_ATOR INT,
    PRIMARY KEY (ID_FILME, ID_ATOR),
    FOREIGN KEY (ID_FILME) REFERENCES FILME(ID_FILME),
    FOREIGN KEY (ID_ATOR) REFERENCES ATOR(ID_ATOR)
);

-- Tabela para armazenar informações sobre as sessões
CREATE TABLE SESSAO (
    ID_SESSAO INT PRIMARY KEY AUTO_INCREMENT,
    ID_FILME INT NOT NULL,
    ID_CINEMA INT NOT NULL,
    HORARIO DATETIME NOT NULL,
    IDIOMA VARCHAR(50),
    TIPO VARCHAR(50), -- Ex: 2D, 3D, IMAX
    FOREIGN KEY (ID_FILME) REFERENCES FILME(ID_FILME),
    FOREIGN KEY (ID_CINEMA) REFERENCES CINEMA(ID_CINEMA)
);

-- Trigger para garantir que a duração do filme seja positiva
DELIMITER //

CREATE TRIGGER VALIDAR_DURACAO
BEFORE INSERT ON FILME
FOR EACH ROW
BEGIN
    IF NEW.DURACAO_MIN <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A duração do filme deve ser um valor positivo.';
    END IF;
END;
//

-- Se tivéssemos apenas a trigger de INSERT, 
-- um filme poderia ser criado com uma duração válida (ex: 120 minutos), 
-- mas depois alguém poderia tentar atualizá-lo para uma duração inválida (ex: 0 minutos ou -10 minutos) 
-- e o banco de dados permitiria, pois a trigger de INSERT não seria disparada.
CREATE TRIGGER VALIDAR_DURACAO_UPDATE
BEFORE UPDATE ON FILME
FOR EACH ROW
BEGIN
    IF NEW.DURACAO_MIN <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A duração do filme deve ser um valor positivo.';
    END IF;
END;
//

DELIMITER ;

CREATE VIEW FILMES_POR_DIRETOR AS
SELECT
    F.DIRETOR AS DIRETOR,
    F.TITULO AS TITULO_FILME,
    F.GENERO AS GENERO_FILME,
    F.DURACAO_MIN AS DURACAO_MINUTOS
FROM
    FILME F
WHERE
    F.DIRETOR IS NOT NULL AND F.DIRETOR != '' -- Garante que apenas filmes com diretor preenchido apareçam
ORDER BY
    F.DIRETOR, F.TITULO;

-- View para contar quantos filmes cada ator participou
CREATE VIEW CONTADOR_FILMES_ATOR AS
SELECT
    A.NOME_ATOR AS ATOR,
    A.NACIONALIDADE AS NACIONALIDADE,
    COUNT(FA.ID_FILME) AS FILMES_PARTICIPADOS
FROM
    ATOR A
JOIN
    FILMEATOR FA ON A.ID_ATOR = FA.ID_ATOR
GROUP BY
    A.ID_ATOR, A.NOME_ATOR, A.NACIONALIDADE -- Agrupa por ID para garantir unicidade, inclui nome e nacionalidade para exibição
ORDER BY
    FILMES_PARTICIPADOS DESC, A.NOME_ATOR;

    
INSERT INTO DISTRIBUIDORA (NOME) VALUES
('Distribuidora Wolfs'),
('Distribuidora Iron'); 

INSERT INTO CINEMA (NOME_CINEMA, ENDERECO, TELEFONE, ID_DISTRIBUIDORA) VALUES
('Cine Mais', 'Rua das Flores, 123, Centro', '11987654321', 1),
('Super Cine', 'Av. Principal, 456, Bairro Novo', '21998765432', 2);

-- Inserir alguns filmes
INSERT INTO FILME (TITULO, GENERO, DURACAO_MIN, DIRETOR) VALUES
('Aventura nas Estrelas', 'Ficção Científica', 150, 'João Silva'),
('O Segredo da Floresta', 'Drama', 120, 'Maria Souza');

-- Tentativa de inserir filme com duração inválida (vai ativar a trigger)
-- INSERT INTO Filme (titulo_original, genero, duracao_minutos, diretor) VALUES
-- ('Filme Curto', 'Comédia', 0, 'Carlos Pereira');

-- Inserir alguns atores
INSERT INTO ATOR (NOME_ATOR, NACIONALIDADE, DATA_NASCIMENTO) VALUES
('Ana Clara', 'Brasileira', '1990-05-15'),
('Pedro Henrique', 'Portuguesa', '1985-11-20'),
('Julia Mendes', 'Brasileira', '1992-03-01');

-- Relacionar filmes e atores
INSERT INTO FILMEATOR (ID_FILME, ID_ATOR) VALUES
(1, 1), -- Aventura nas Estrelas com Ana Clara
(1, 2), -- Aventura nas Estrelas com Pedro Henrique
(2, 1), -- O Segredo da Floresta com Ana Clara
(2, 3); -- O Segredo da Floresta com Julia Mendes

-- Inserir algumas sessões
INSERT INTO SESSAO (ID_FILME, ID_CINEMA, HORARIO, IDIOMA, TIPO) VALUES
(1, 1, '2025-06-20 19:00:00', 'Dublado', '3D'),
(1, 2, '2025-06-20 21:30:00', 'Legendado', '2D'),
(2, 1, '2025-06-21 16:00:00', 'Dublado', '2D');

SELECT * FROM FILMES_POR_DIRETOR;

SELECT * FROM CONTADOR_FILMES_ATOR;
