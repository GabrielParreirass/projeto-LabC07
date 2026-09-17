# Sistema de Gestão de Torneio de Futebol
> Projeto Integrador de Banco de Dados Relacional

---

## 👥 Integrantes do Grupo

- **Nome do Integrante 1** - RA / Matrícula
- **Nome do Integrante 2** - RA / Matrícula
- **Nome do Integrante 3** - RA / Matrícula
- **Nome do Integrante 4** - RA / Matrícula
- **Nome do Integrante 5** - RA / Matrícula

---

## ⚽ Tema do Projeto

**Sistema de Gestão e Monitoramento de Torneios de Futebol**

### Breve Explicação do Tema
O projeto consiste em um sistema de banco de dados relacional projetado para automatizar e organizar o gerenciamento completo de campeonatos de futebol. A solução abrange desde o cadastro institucional dos clubes, atletas e praças esportivas até o registro operacional detalhado dos confrontos diretos, suas respectivas súmulas e escalações.

O sistema permite registrar o histórico de partidas, controlar o desempenho individual dos atletas em cada jogo (minutos jogados, gols, cartões), catalogar locais de jogos e formalizar o relatório oficial do árbitro para cada evento esportivo.

---

## 🗄️ Modelagem do Banco de Dados

O modelo relacional foi estruturado no **MySQL Workbench** respeitando os requisitos acadêmicos estipulados:

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

---

## 🛠️ Tecnologias Utilizadas

- **SGBD**: MySQL
- **Ferramenta de Modelagem**: MySQL Workbench (EER Diagram)
- **Linguagem SQL**: DDL / DML
