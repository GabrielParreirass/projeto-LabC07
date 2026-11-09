# Sistema de Gestão de Torneio de Futebol
---

## 👥 Integrantes do Grupo

- **Gabriel Parreiras Afonseca** - 644
- **João Paulo de Moura Brandão** - 2288
- **Matheus Carvalho Michelli Ramazzina Reis** - 2227


---

## ⚽ Tema do Projeto

**Sistema de Gestão e Monitoramento de Torneios de Futebol**

### Breve Explicação do Tema
O projeto consiste em um sistema de banco de dados relacional projetado para automatizar e organizar o gerenciamento completo de campeonatos de futebol. A solução abrange desde o cadastro dos clubes, atletas e estadios até o registro detalhado dos confrontos, suas súmulas e escalações.

O sistema permite registrar o histórico de partidas, controlar o desempenho individual dos atletas em cada jogo (minutos jogados, gols, cartões), catalogar locais de jogos e formalizar o relatório oficial do árbitro para cada evento esportivo.

---

## 🗄️ Modelagem do Banco de Dados

### Entidades do Sistema (6 Entidades)
1. **`Equipe`**: Armazena as informações dos clubes/times participantes do torneio.
2. **`Jogador`**: Contém o cadastro dos atletas vinculados às equipes.
3. **`Estadio`**: Registra as arenas e locais onde ocorrem os confrontos.
4. **`Partida`**: Controla os jogos agendados, definindo mandante, visitante e estádio.
5. **`SumulaOficial`**: Armazena o registro formal e financeiro pós-jogo efetuado pela arbitragem.
6. **`Escalacao`**: Tabela intermediária para registrar a atuação dos atletas por partida.

---

## 🔗 Mapeamento de Relacionamentos

| Tipo de Relacionamento | Tabelas Envolvidas | Descrição / Regra de Negócio |
| :--- | :--- | :--- |
| **1:1 (Um para Um)** | `Partida` — `SumulaOficial` | Cada partida finalizada possui exatamente uma súmula oficial vinculada (`UNIQUE` em `idPartida`). |
| **1:N (Um para Muitos)** | `Equipe` — `Jogador` | Uma equipe possui diversos jogadores contratados; cada jogador atua por um clube por vez. |
| **1:N (Um para Muitos)** | `Estadio` — `Partida` | Um estádio pode sediar múltiplas partidas ao longo do campeonato. |
| **N:M (Muitos para Muitos)** | `Partida` — `Jogador` | Resolvido através da tabela intermediária **`Escalacao`**, permitindo registrar múltiplos atletas em uma partida e vice-versa. |
| **Auto-relacionamento (1:N)** | `Jogador` — `Jogador` | Permite associar um jogador experiente (mentor/tutor) a um atleta mais jovem da base via `idMentor`. |


# Sistema de Gerenciamento de Campeonato de Futebol

## 1. Estrutura do Banco de Dados

O banco de dados foi denominado `campeonato_futebol` e é composto por seis tabelas.

### 1.1. Estadio

Armazena as informações dos estádios utilizados nas partidas.

| Campo | Tipo | Descrição |
|---|---|---|
| idEstadio | INT | Chave primária |
| nome | VARCHAR(100) | Nome do estádio |
| capacidade | INT | Capacidade máxima de público |
| cidade | VARCHAR(45) | Cidade do estádio |

A coluna `capacidade` utiliza uma restrição `CHECK` para impedir valores menores ou iguais a zero.

### 1.2. Equipe

Armazena as informações das equipes participantes do campeonato.

| Campo | Tipo | Descrição |
|---|---|---|
| idEquipe | INT | Chave primária |
| nome | VARCHAR(80) | Nome da equipe |
| cidadeOrigem | VARCHAR(60) | Cidade de origem |
| data_fundacao | DATE | Data de fundação |

### 1.3. Jogador

Armazena os jogadores cadastrados e suas respectivas equipes.

| Campo | Tipo | Descrição |
|---|---|---|
| idJogador | INT | Chave primária |
| nome | VARCHAR(100) | Nome do jogador |
| posicao | VARCHAR(45) | Posição em campo |
| numeroCamisa | INT | Número da camisa |
| dataNascimento | DATE | Data de nascimento |
| idMentor | INT | Referência a outro jogador |
| idEquipe | INT | Equipe à qual pertence |

O campo `idMentor` permite estabelecer uma relação entre jogadores, representando um jogador que atua como mentor de outro.

A restrição `UNIQUE (idEquipe, numeroCamisa)` impede que dois jogadores de uma mesma equipe tenham o mesmo número de camisa.

### 1.4. Partida

Armazena as informações das partidas realizadas.

| Campo | Tipo | Descrição |
|---|---|---|
| idPartida | INT | Chave primária |
| dataHora | DATETIME(3) | Data e horário da partida |
| rodada | INT | Rodada do campeonato |
| id_mandante | INT | Equipe mandante |
| id_visitante | INT | Equipe visitante |
| idEstadio | INT | Estádio da partida |

A tabela utiliza chaves estrangeiras para relacionar cada partida às equipes participantes e ao estádio.

Também possui uma restrição `CHECK` para impedir que uma equipe seja mandante e visitante na mesma partida.

### 1.5. SumulaOficial

Armazena os relatórios oficiais das partidas.

| Campo | Tipo | Descrição |
|---|---|---|
| idSumulaOficial | INT | Chave primária |
| relatorioArbitro | TEXT | Relatório da arbitragem |
| publicoPagante | INT | Quantidade de espectadores pagantes |
| rendaTotal | DECIMAL(12,2) | Arrecadação da partida |
| idPartida | INT | Referência à partida |

O campo `idPartida` possui uma restrição `UNIQUE`, garantindo que uma partida tenha, no máximo, uma súmula oficial.

### 1.6. Escalacao

Armazena a participação dos jogadores nas partidas.

| Campo | Tipo | Descrição |
|---|---|---|
| idEscalacao | INT | Chave primária |
| titular | TINYINT(1) | Indica se o jogador foi titular |
| minutosJogados | INT | Tempo em campo |
| golsMarcados | INT | Quantidade de gols |
| cartoesTomados | INT | Quantidade de cartões |
| idPartida | INT | Referência à partida |
| idJogador | INT | Referência ao jogador |

A restrição `UNIQUE (idPartida, idJogador)` impede que um mesmo jogador seja registrado duas vezes na mesma partida.

## 2. Relacionamentos do Banco

O banco utiliza os três tipos principais de relacionamento estudados na disciplina.

### 2.1. Relacionamento 1:1

**Partida — SumulaOficial**

Uma partida pode possuir, no máximo, uma súmula oficial, e cada súmula está associada a uma única partida.

Esse relacionamento é implementado através de uma chave estrangeira com a restrição `UNIQUE` na tabela `SumulaOficial`.

### 2.2. Relacionamento 1:N

**Equipe — Jogador**

Uma equipe pode possuir vários jogadores, porém cada jogador pertence a uma única equipe.

O relacionamento é estabelecido pela chave estrangeira `idEquipe` na tabela `Jogador`.

Outros exemplos presentes no projeto são os relacionamentos entre estádio e partidas, e entre equipes e partidas.

### 2.3. Relacionamento N:M

**Jogador — Partida**

Um jogador pode participar de várias partidas, e uma partida pode possuir vários jogadores.

Para implementar esse relacionamento, foi utilizada a tabela intermediária `Escalacao`, que associa os jogadores às partidas e armazena informações sobre seu desempenho.

## 3. Inserção de Dados — INSERT

O comando `INSERT INTO` foi utilizado para cadastrar os registros iniciais do banco.

Foram inseridos dados fictícios para simular o funcionamento de um campeonato de futebol.

| Tabela | Quantidade inicial de registros |
|---|---:|
| Estadio | 5 |
| Equipe | 5 |
| Jogador | 10 |
| Partida | 5 |
| SumulaOficial | 5 |
| Escalacao | 10 |

**Exemplo:**

```sql
INSERT INTO Estadio (idEstadio, nome, capacidade, cidade)
VALUES (1, 'Mineirao', 62000, 'Belo Horizonte');
```

**Justificativa:** o `INSERT` é necessário para popular as tabelas com informações que serão utilizadas nas consultas e operações do sistema.

## 4. Manipulação de Dados — DML

Foram utilizados os comandos `INSERT`, `UPDATE` e `DELETE` para demonstrar as principais operações de manipulação de dados.

### 4.1. INSERT

Utilizado para cadastrar um novo estádio temporário.

```sql
INSERT INTO Estadio (nome, capacidade, cidade)
VALUES ('Estadio Temporario', 1000, 'Teste');
```

O objetivo foi demonstrar a inclusão de novos registros no banco.

### 4.2. UPDATE

Utilizado para atualizar a capacidade de um estádio já cadastrado.

```sql
UPDATE Estadio
SET capacidade = 62500
WHERE idEstadio = 1;
```

O comando altera a capacidade do estádio de código 1 de 62.000 para 62.500 espectadores.

**Justificativa:** o `UPDATE` permite corrigir ou modificar informações sem precisar excluir e cadastrar novamente o registro.

### 4.3. DELETE

Utilizado para excluir o estádio temporário criado anteriormente.

```sql
DELETE FROM Estadio
WHERE nome = 'Estadio Temporario'
AND cidade = 'Teste';
```

**Justificativa:** o `DELETE` permite remover registros desnecessários ou inseridos apenas para testes.

Antes desses comandos, foi utilizada a instrução:

```sql
SET SQL_SAFE_UPDATES = 0;
```

Esse comando desativa o modo de atualização segura da sessão, permitindo a exclusão pelo nome e pela cidade sem exigir uma condição baseada em chave.

### 4.4. SELECT

Também foram realizadas consultas para visualizar os dados cadastrados.

```sql
SELECT idEquipe, nome, cidadeOrigem
FROM Equipe
ORDER BY nome;
```

O `SELECT` pertence à DQL (Data Query Language) e foi utilizado para recuperar e organizar informações.

## 5. Controle de Acesso — DCL

Para demonstrar o gerenciamento de permissões, foi criada uma ROLE e dois usuários.

### 5.1. Criação da ROLE

```sql
CREATE ROLE IF NOT EXISTS 'papel_consulta';

GRANT SELECT ON campeonato_futebol.*
TO 'papel_consulta';
```

A ROLE `papel_consulta` possui permissão para consultar as tabelas do banco de dados.

### 5.2. Criação dos Usuários

```sql
CREATE USER IF NOT EXISTS 'analista_futebol'@'localhost'
IDENTIFIED BY '1234';

CREATE USER IF NOT EXISTS 'auditor_futebol'@'localhost'
IDENTIFIED BY '1234';
```

Foram criados dois usuários para representar diferentes profissionais que precisam consultar as informações do campeonato.

### 5.3. Associação da ROLE

```sql
GRANT 'papel_consulta'
TO 'analista_futebol'@'localhost',
   'auditor_futebol'@'localhost';

SET DEFAULT ROLE 'papel_consulta'
TO 'analista_futebol'@'localhost',
   'auditor_futebol'@'localhost';
```

**Justificativa:** a utilização de uma ROLE permite gerenciar permissões de maneira centralizada. Em vez de atribuir individualmente os mesmos privilégios a vários usuários, as permissões são definidas na ROLE e compartilhadas entre eles.

As senhas apresentadas são exclusivamente para fins acadêmicos e devem ser substituídas por senhas seguras em um ambiente real.

## 6. Consultas com JOIN

Foram desenvolvidas consultas envolvendo diferentes tabelas para demonstrar os relacionamentos do modelo relacional.

### 6.1. JOIN — Relacionamento 1:1

Consulta das partidas com suas respectivas súmulas oficiais.

```sql
SELECT p.idPartida, p.dataHora,
       s.relatorioArbitro,
       s.publicoPagante, s.rendaTotal
FROM Partida p
JOIN SumulaOficial s
ON s.idPartida = p.idPartida
ORDER BY p.dataHora;
```

**Objetivo:** apresentar as informações de cada partida juntamente com o relatório da arbitragem, o público pagante e a renda total.

### 6.2. JOIN — Relacionamento 1:N

Consulta dos jogadores de cada equipe.

```sql
SELECT e.nome AS equipe, j.nome AS jogador,
       j.posicao, j.numeroCamisa
FROM Equipe e
JOIN Jogador j
ON j.idEquipe = e.idEquipe
ORDER BY e.nome, j.numeroCamisa;
```

**Objetivo:** listar os jogadores cadastrados, identificando a equipe à qual pertencem.

### 6.3. JOIN — Relacionamento N:M

Consulta das escalações dos jogadores nas partidas.

```sql
SELECT p.idPartida, p.dataHora,
       j.nome AS jogador, e.nome AS equipe,
       es.titular, es.minutosJogados,
       es.golsMarcados
FROM Partida p
JOIN Escalacao es
ON es.idPartida = p.idPartida
JOIN Jogador j
ON j.idJogador = es.idJogador
JOIN Equipe e
ON e.idEquipe = j.idEquipe
ORDER BY p.idPartida, j.nome;
```

**Objetivo:** consultar a participação dos jogadores nas partidas, mostrando as equipes, os minutos jogados e os gols marcados.

A tabela `Escalacao` permite implementar o relacionamento muitos-para-muitos entre jogadores e partidas.

### 6.4. JOIN com Múltiplas Tabelas

Foi implementada uma consulta envolvendo as tabelas `Partida`, `Equipe`, `Estadio` e `SumulaOficial`.

Essa consulta permite visualizar mandante, visitante, estádio, cidade, público e arrecadação das partidas.

Ela utiliza dois JOINs com a tabela `Equipe`, diferenciando a equipe mandante da visitante por meio dos aliases `mand` e `vis`.

Também utiliza `LEFT JOIN` com `SumulaOficial`, permitindo que partidas sem súmula cadastrada apareçam no resultado.

### 6.5. JOIN com GROUP BY

Foi implementada uma consulta para gerar um ranking de artilheiros.

```sql
SELECT j.idJogador, j.nome,
       e.nome AS equipe,
       SUM(es.golsMarcados) AS totalGols
FROM Jogador j
JOIN Equipe e
ON e.idEquipe = j.idEquipe
LEFT JOIN Escalacao es
ON es.idJogador = j.idJogador
GROUP BY j.idJogador, j.nome, e.nome
ORDER BY totalGols DESC, j.nome;
```

**Objetivo:** somar os gols marcados por cada jogador e apresentar o resultado em ordem decrescente.

O `GROUP BY` agrupa os registros de cada jogador, enquanto `SUM` calcula o total de gols.

Jogadores sem registros de escalação também aparecem na consulta devido ao `LEFT JOIN`, podendo apresentar `NULL` no total de gols.

## 7. Objetos Programáveis

Foram implementados quatro objetos programáveis: uma View, uma Function, uma Trigger e uma Procedure.

### 7.1. VIEW — vw_resumo_partidas

A View `vw_resumo_partidas` reúne informações das partidas, das equipes participantes, dos estádios e das súmulas oficiais.

Ela foi criada utilizando `CREATE VIEW` e consultas com JOIN.

**Justificativa:** a View simplifica consultas frequentes, evitando a necessidade de escrever repetidamente os mesmos JOINs.

**Exemplo de utilização:**

```sql
SELECT *
FROM vw_resumo_partidas
ORDER BY dataHora;
```

Essa consulta retorna um resumo das partidas utilizando a View previamente criada.

### 7.2. FUNCTION — fn_total_gols_jogador

A função `fn_total_gols_jogador` recebe o código de um jogador e retorna a soma dos gols registrados em suas escalações.

Ela utiliza uma variável local, o comando `SELECT SUM()` e a instrução `RETURN`.

**Justificativa:** a Function permite reutilizar um cálculo em diferentes consultas, facilitando a obtenção de estatísticas dos jogadores.

**Exemplo de utilização:**

```sql
SELECT fn_total_gols_jogador(2)
AS gols_do_jogador_2;
```

Caso o jogador não possua registros na tabela `Escalacao`, o resultado da soma será `NULL`.

### 7.3. TRIGGER — trg_validar_escalacao

A Trigger `trg_validar_escalacao` é executada automaticamente antes de uma inserção na tabela `Escalacao`.

Ela utiliza `BEFORE INSERT` e `FOR EACH ROW` para consultar os dados relacionados ao novo registro.

Durante sua execução, são recuperados:

- O código da equipe do jogador.
- O código da equipe mandante.
- O código da equipe visitante.

Esses valores são armazenados em variáveis locais por meio de comandos `SELECT INTO`.

**Justificativa:** a Trigger demonstra a execução automática de comandos SQL quando uma operação de inserção ocorre em uma tabela.

**Observação:** na versão atual, a Trigger apenas recupera essas informações. Ela não realiza a comparação entre as equipes nem bloqueia uma escalação inválida. Essa validação pode ser acrescentada posteriormente.

### 7.4. PROCEDURE — sp_escalar_jogador

A Procedure `sp_escalar_jogador` foi criada para cadastrar novos registros de escalação por meio de parâmetros.

Ela recebe:

- Código da partida.
- Código do jogador.
- Indicação de titularidade.
- Minutos jogados.
- Gols marcados.
- Cartões recebidos.

Após receber os valores, executa um `INSERT` na tabela `Escalacao`.

**Justificativa:** a Procedure centraliza a operação de inserção de escalações, permitindo reutilizar o mesmo procedimento para diferentes jogadores e partidas.

**Exemplo de utilização:**

```sql
CALL sp_escalar_jogador(1, 4, 0, 20, 0, 0);
```

Esse comando registra a participação do jogador de código 4 na partida de código 1, como reserva, com 20 minutos jogados, nenhum gol e nenhum cartão.

## 8. Integridade dos Dados

Foram utilizadas diferentes restrições para manter a consistência das informações armazenadas.

| Restrição | Finalidade |
|---|---|
| PRIMARY KEY | Identificar unicamente cada registro |
| FOREIGN KEY | Garantir os relacionamentos entre tabelas |
| NOT NULL | Impedir campos obrigatórios vazios |
| UNIQUE | Evitar combinações de dados duplicadas |
| CHECK | Validar regras para os valores inseridos |
| DEFAULT | Definir valores padrão |
| AUTO_INCREMENT | Gerar identificadores automaticamente |

Também foi utilizado `ON DELETE CASCADE` nos relacionamentos entre `Partida` e as tabelas `SumulaOficial` e `Escalacao`.

Dessa forma, quando uma partida é excluída, os registros relacionados nessas tabelas são removidos automaticamente.

Na tabela `Jogador`, o campo `idMentor` utiliza `ON DELETE SET NULL`, permitindo que um jogador permaneça cadastrado mesmo que seu mentor seja excluído.

## 9. Consultas de Verificação

Ao final do script, foi implementada uma consulta para verificar a quantidade de registros em cada tabela.

```sql
SELECT 'Estadio' AS tabela,
       COUNT(*) AS registros FROM Estadio
UNION ALL
SELECT 'Equipe', COUNT(*) FROM Equipe
UNION ALL
SELECT 'Jogador', COUNT(*) FROM Jogador
UNION ALL
SELECT 'Partida', COUNT(*) FROM Partida
UNION ALL
SELECT 'SumulaOficial', COUNT(*) FROM SumulaOficial
UNION ALL
SELECT 'Escalacao', COUNT(*) FROM Escalacao;
```

Após a execução completa do script, incluindo a Procedure de demonstração, os resultados esperados são:

| Tabela | Registros |
|---|---:|
| Estadio | 5 |
| Equipe | 5 |
| Jogador | 10 |
| Partida | 5 |
| SumulaOficial | 5 |
| Escalacao | 11 |

Essa consulta permite verificar se os dados foram inseridos corretamente.

## 10. Considerações Finais

O desenvolvimento do banco de dados permitiu aplicar os principais conceitos de bancos de dados relacionais em um cenário de gerenciamento esportivo.

Foram implementadas tabelas com chaves primárias e estrangeiras, restrições de integridade, inserção e manipulação de registros, gerenciamento de permissões com usuários e roles, consultas com diferentes tipos de JOIN e objetos programáveis.

Os relacionamentos 1:1, 1:N e N:M foram representados e utilizados nas consultas, demonstrando como diferentes entidades podem ser relacionadas para obter informações mais completas.

A criação da View, Function, Trigger e Procedure também permitiu explorar recursos de organização, automação e reutilização de comandos SQL.

Assim, o projeto demonstra a aplicação prática dos conteúdos estudados na disciplina e estabelece uma estrutura básica para um sistema de gerenciamento de campeonatos de futebol.


