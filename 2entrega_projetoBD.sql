DROP DATABASE IF EXISTS campeonato_futebol;
CREATE DATABASE campeonato_futebol;
USE campeonato_futebol;

CREATE TABLE Estadio (
    idEstadio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    capacidade INT NOT NULL CHECK (capacidade > 0),
    cidade VARCHAR(45) NOT NULL
);

CREATE TABLE Equipe (
    idEquipe INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    cidadeOrigem VARCHAR(60) NOT NULL,
    data_fundacao DATE NOT NULL
);

CREATE TABLE Jogador (
    idJogador INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    posicao VARCHAR(45) NOT NULL,
    numeroCamisa INT NOT NULL CHECK (numeroCamisa BETWEEN 1 AND 99),
    dataNascimento DATE NOT NULL,
    idMentor INT NULL,
    idEquipe INT NOT NULL,

    FOREIGN KEY (idMentor) REFERENCES Jogador(idJogador) ON DELETE SET NULL,
    FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe),

    UNIQUE (idEquipe, numeroCamisa)
);


CREATE TABLE Partida (
    idPartida INT AUTO_INCREMENT PRIMARY KEY,
    dataHora DATETIME(3) NOT NULL,
    rodada INT NOT NULL CHECK (rodada > 0),
    id_mandante INT NOT NULL,
    id_visitante INT NOT NULL,
    idEstadio INT NOT NULL,
    FOREIGN KEY (id_mandante) REFERENCES Equipe(idEquipe),
    FOREIGN KEY (id_visitante) REFERENCES Equipe(idEquipe),
    FOREIGN KEY (idEstadio) REFERENCES Estadio(idEstadio),
    CHECK (id_mandante <> id_visitante)
);

CREATE TABLE SumulaOficial (
    idSumulaOficial INT AUTO_INCREMENT PRIMARY KEY,
    relatorioArbitro TEXT,
    publicoPagante INT NOT NULL DEFAULT 0 CHECK (publicoPagante >= 0),
    rendaTotal DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (rendaTotal >= 0),
    idPartida INT NOT NULL UNIQUE,
    FOREIGN KEY (idPartida) REFERENCES Partida(idPartida) ON DELETE CASCADE
);

CREATE TABLE Escalacao (
    idEscalacao INT AUTO_INCREMENT PRIMARY KEY,
    titular TINYINT(1) NOT NULL CHECK (titular IN (0,1)),
    minutosJogados INT NOT NULL DEFAULT 0 CHECK (minutosJogados BETWEEN 0 AND 130),
    golsMarcados INT NOT NULL DEFAULT 0 CHECK (golsMarcados >= 0),
    cartoesTomados INT NOT NULL DEFAULT 0 CHECK (cartoesTomados >= 0),
    idPartida INT NOT NULL,
    idJogador INT NOT NULL,
    FOREIGN KEY (idPartida) REFERENCES Partida(idPartida) ON DELETE CASCADE,
    FOREIGN KEY (idJogador) REFERENCES Jogador(idJogador),
    UNIQUE (idPartida, idJogador)
);

-- INSERT: mínimo de 5 linhas em cada tabela
INSERT INTO Estadio (idEstadio, nome, capacidade, cidade) VALUES
(1, 'Mineirao', 62000, 'Belo Horizonte'),
(2, 'Maracana', 78000, 'Rio de Janeiro'),
(3, 'Morumbis', 66000, 'Sao Paulo'),
(4, 'Arena do Gremio', 55000, 'Porto Alegre'),
(5, 'Castelao', 63000, 'Fortaleza');

INSERT INTO Equipe (idEquipe, nome, cidadeOrigem, data_fundacao) VALUES
(1, 'Cruzeiro', 'Belo Horizonte', '1908-03-25'),
(2, 'Flamengo', 'Rio de Janeiro', '1895-11-15'),
(3, 'Sao Paulo', 'Sao Paulo', '1930-01-25'),
(4, 'Gremio', 'Porto Alegre', '1903-09-15'),
(5, 'Fortaleza', 'Fortaleza', '1918-10-18');

INSERT INTO Jogador (idJogador, nome, posicao, numeroCamisa, dataNascimento, idMentor, idEquipe) VALUES
(1, 'Lucas Martins', 'Atacante', 9, '1998-05-12', NULL, 1),
(2, 'Pedro Costa', 'Meia', 10, '2002-08-21', 1, 1),
(3, 'Rafael Souza', 'Atacante', 9, '1997-07-09', NULL, 2),
(4, 'Bruno Lima', 'Zagueiro', 4, '2001-04-30', 3, 2),
(5, 'Caio Ferreira', 'Meia', 8, '1999-10-15', NULL, 3),
(6, 'Diego Alves', 'Atacante', 11, '2003-01-05', 5, 3),
(7, 'Eduardo Silva', 'Goleiro', 1, '1996-06-18', NULL, 4),
(8, 'Felipe Rocha', 'Atacante', 9, '2000-12-03', 7, 4),
(9, 'Gabriel Nunes', 'Meia', 10, '1998-02-11', NULL, 5),
(10, 'Henrique Melo', 'Atacante', 7, '2002-09-27', 9, 5);

INSERT INTO Partida (idPartida, dataHora, rodada, id_mandante, id_visitante, idEstadio) VALUES
(1, '2026-10-01 19:00:00.000', 1, 1, 2, 1),
(2, '2026-10-02 20:00:00.000', 1, 3, 4, 3),
(3, '2026-10-03 18:00:00.000', 1, 5, 1, 5),
(4, '2026-10-10 19:30:00.000', 2, 2, 3, 2),
(5, '2026-10-11 16:00:00.000', 2, 4, 5, 4);

INSERT INTO SumulaOficial (idSumulaOficial, relatorioArbitro, publicoPagante, rendaTotal, idPartida) VALUES
(1, 'Partida encerrada sem incidentes.', 30000, 1200000.00, 1),
(2, 'Um cartao amarelo foi aplicado.', 24000, 890000.00, 2),
(3, 'Jogo com dois gols e sem expulsao.', 22000, 620000.00, 3),
(4, 'Partida disputada e sem ocorrencias graves.', 52000, 2300000.00, 4),
(5, 'Arbitragem registrou jogo regular.', 27000, 970000.00, 5);

INSERT INTO Escalacao (idEscalacao, titular, minutosJogados, golsMarcados, cartoesTomados, idPartida, idJogador) VALUES
(1, 1, 90, 1, 0, 1, 1),
(2, 1, 90, 0, 1, 1, 3),
(3, 1, 90, 1, 0, 2, 5),
(4, 1, 80, 0, 0, 2, 8),
(5, 1, 90, 0, 0, 3, 9),
(6, 1, 90, 2, 0, 3, 2),
(7, 1, 90, 1, 0, 4, 4),
(8, 1, 90, 0, 1, 4, 6),
(9, 1, 90, 0, 0, 5, 7),
(10, 1, 70, 1, 0, 5, 10);

-- Quantidade de registros por tabela
SELECT 'Estadio' AS tabela, COUNT(*) AS registros FROM Estadio
UNION ALL SELECT 'Equipe', COUNT(*) FROM Equipe
UNION ALL SELECT 'Jogador', COUNT(*) FROM Jogador
UNION ALL SELECT 'Partida', COUNT(*) FROM Partida
UNION ALL SELECT 'SumulaOficial', COUNT(*) FROM SumulaOficial
UNION ALL SELECT 'Escalacao', COUNT(*) FROM Escalacao;

SET SQL_SAFE_UPDATES = 0;

UPDATE Estadio SET capacidade = 62500 WHERE idEstadio = 1;
INSERT INTO Estadio (nome, capacidade, cidade) VALUES ('Estadio Temporario', 1000, 'Teste');
DELETE FROM Estadio WHERE nome = 'Estadio Temporario' AND cidade = 'Teste';
SELECT idEquipe, nome, cidadeOrigem FROM Equipe ORDER BY nome;

-- ROLE e usuários 
CREATE ROLE IF NOT EXISTS 'papel_consulta';
GRANT SELECT ON campeonato_futebol.* TO 'papel_consulta';
CREATE USER IF NOT EXISTS 'analista_futebol'@'localhost' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'auditor_futebol'@'localhost' IDENTIFIED BY '1234';
GRANT 'papel_consulta' TO 'analista_futebol'@'localhost', 'auditor_futebol'@'localhost';
SET DEFAULT ROLE 'papel_consulta' TO 'analista_futebol'@'localhost', 'auditor_futebol'@'localhost';

-- JOIN 1:1  cada partida tem no máximo uma súmula (UNIQUE em SumulaOficial.idPartida)
SELECT p.idPartida, p.dataHora, s.relatorioArbitro, s.publicoPagante, s.rendaTotal
FROM Partida p
JOIN SumulaOficial s ON s.idPartida = p.idPartida
ORDER BY p.dataHora;

-- JOIN 1:N  uma equipe possui vários jogadores
SELECT e.nome AS equipe, j.nome AS jogador, j.posicao, j.numeroCamisa
FROM Equipe e
JOIN Jogador j ON j.idEquipe = e.idEquipe
ORDER BY e.nome, j.numeroCamisa;

-- JOIN N:M  jogadores participam de várias partidas via tabela Escalacao
SELECT p.idPartida, p.dataHora, j.nome AS jogador, e.nome AS equipe,
       es.titular, es.minutosJogados, es.golsMarcados
FROM Partida p
JOIN Escalacao es ON es.idPartida = p.idPartida
JOIN Jogador j ON j.idJogador = es.idJogador
JOIN Equipe e ON e.idEquipe = j.idEquipe
ORDER BY p.idPartida, j.nome;

-- JOIN com múltiplas FKs para Equipe, Estadio e SumulaOficial
SELECT p.idPartida, p.rodada, mand.nome AS mandante, vis.nome AS visitante,
       est.nome AS estadio, est.cidade, s.publicoPagante, s.rendaTotal
FROM Partida p
JOIN Equipe mand ON mand.idEquipe = p.id_mandante
JOIN Equipe vis ON vis.idEquipe = p.id_visitante
JOIN Estadio est ON est.idEstadio = p.idEstadio
LEFT JOIN SumulaOficial s ON s.idPartida = p.idPartida
ORDER BY p.dataHora;

-- JOIN + GROUP BY para ranking de artilheiros
SELECT j.idJogador, j.nome, e.nome AS equipe,
       SUM(es.golsMarcados) AS totalGols
FROM Jogador j
JOIN Equipe e ON e.idEquipe = j.idEquipe
LEFT JOIN Escalacao es ON es.idJogador = j.idJogador
GROUP BY j.idJogador, j.nome, e.nome
ORDER BY totalGols DESC, j.nome;

-- VIEW: simplifica consultas frequentes sobre partidas
CREATE VIEW vw_resumo_partidas AS
SELECT p.idPartida, p.rodada, p.dataHora,
       mand.nome AS mandante, vis.nome AS visitante,
       est.nome AS estadio, s.publicoPagante, s.rendaTotal
FROM Partida p
JOIN Equipe mand ON mand.idEquipe = p.id_mandante
JOIN Equipe vis ON vis.idEquipe = p.id_visitante
JOIN Estadio est ON est.idEstadio = p.idEstadio
LEFT JOIN SumulaOficial s ON s.idPartida = p.idPartida;

DELIMITER $$

CREATE FUNCTION fn_total_gols_jogador(p_idJogador INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_total INT DEFAULT 0;
    SELECT SUM(golsMarcados) INTO v_total
    FROM Escalacao
    WHERE idJogador = p_idJogador;
    RETURN v_total;
END$$

-- TRIGGER: impede escalar jogadores de equipes ausentes da partida

CREATE TRIGGER trg_validar_escalacao
BEFORE INSERT ON Escalacao
FOR EACH ROW
BEGIN
    DECLARE v_equipe_jogador INT;
    DECLARE v_mandante INT;
    DECLARE v_visitante INT;

    SELECT idEquipe INTO v_equipe_jogador
    FROM Jogador
    WHERE idJogador = NEW.idJogador;

    SELECT id_mandante, id_visitante
    INTO v_mandante, v_visitante
    FROM Partida
    WHERE idPartida = NEW.idPartida;
END$$


-- PROCEDURE: centraliza a inserção de novas escalações
CREATE PROCEDURE sp_escalar_jogador(
    IN p_idPartida INT,
    IN p_idJogador INT,
    IN p_titular TINYINT,
    IN p_minutos INT,
    IN p_gols INT,
    IN p_cartoes INT
)
BEGIN
    INSERT INTO Escalacao (idPartida, idJogador, titular, minutosJogados, golsMarcados, cartoesTomados)
    VALUES (p_idPartida, p_idJogador, p_titular, p_minutos, p_gols, p_cartoes);
END$$
DELIMITER ;

-- Demonstração de procedure, function e view
CALL sp_escalar_jogador(1, 4, 0, 20, 0, 0);
SELECT fn_total_gols_jogador(2) AS gols_do_jogador_2;
SELECT * FROM vw_resumo_partidas ORDER BY dataHora;