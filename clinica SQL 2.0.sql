-- ============================================================================
-- MÓDULO 2: IMPLEMENTAÇÃO DO BANCO DE DADOS CLINICA_CARE (DDL, DML, DQL)
-- Baseado no novo Diagrama ER
-- ============================================================================

DROP DATABASE IF EXISTS clinica_care;
CREATE DATABASE clinica_care;
USE clinica_care;

-- ============================================================================
-- 1. CRIAÇÃO DO BANCO DE DADOS E TABELAS (DDL)
-- ============================================================================

-- Criacao da tabela: Clinica
CREATE TABLE Clinica (
    id_clinica INT AUTO_INCREMENT PRIMARY KEY,
    cnpj VARCHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(150) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    site VARCHAR(100),
    funcionamento VARCHAR(100)
);

-- Criacao da tabela: Especialidade
CREATE TABLE Especialidade (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome_especialidade VARCHAR(100) NOT NULL UNIQUE
);

-- Criacao da tabela: Medico
CREATE TABLE Medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    crm VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100),
    telefone VARCHAR(20),
    endereco VARCHAR(255),
    idade INT
);

-- Criacao da tabela: Paciente
CREATE TABLE Paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    endereco VARCHAR(255),
    email VARCHAR(100),
    idade INT,
    genero VARCHAR(20)
);

-- Criacao da tabela: Consulta
CREATE TABLE Consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    id_clinica INT NOT NULL,
    dia DATE NOT NULL,
    horario TIME NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) NOT NULL,
    tipo_atendimento VARCHAR(50),
    categoria_consulta VARCHAR(50),
    CONSTRAINT fk_consulta_paciente FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    CONSTRAINT fk_consulta_medico FOREIGN KEY (id_medico) REFERENCES Medico(id_medico),
    CONSTRAINT fk_consulta_clinica FOREIGN KEY (id_clinica) REFERENCES Clinica(id_clinica)
);

-- Criacao da tabela: Pagamento
CREATE TABLE Pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    id_paciente INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    pago BOOLEAN NOT NULL DEFAULT TRUE,
    metodo_pagamento VARCHAR(30) NOT NULL, -- Dinheiro, Convenio, Debito, Credito
    CONSTRAINT fk_pagamento_consulta FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta) ON DELETE CASCADE,
    CONSTRAINT fk_pagamento_paciente FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)
);

-- Criacao da tabela: Prontuario
CREATE TABLE Prontuario (
    id_prontuario INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    id_paciente INT NOT NULL,
    diagnostico TEXT,
    exame TEXT,
    prescricao TEXT,
    sintoma TEXT,
    tipo_sanguineo VARCHAR(5),
    historico TEXT,
    CONSTRAINT fk_prontuario_consulta FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta) ON DELETE CASCADE,
    CONSTRAINT fk_prontuario_paciente FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)
);

-- Criacao das tabelas N:N (Relacionamentos)
CREATE TABLE Clinica_Medico (
    id_clinica INT NOT NULL,
    id_medico INT NOT NULL,
    PRIMARY KEY (id_clinica, id_medico),
    CONSTRAINT fk_cm_clinica FOREIGN KEY (id_clinica) REFERENCES Clinica(id_clinica) ON DELETE CASCADE,
    CONSTRAINT fk_cm_medico FOREIGN KEY (id_medico) REFERENCES Medico(id_medico) ON DELETE CASCADE
);

CREATE TABLE Clinica_Paciente (
    id_clinica INT NOT NULL,
    id_paciente INT NOT NULL,
    PRIMARY KEY (id_clinica, id_paciente),
    CONSTRAINT fk_cp_clinica FOREIGN KEY (id_clinica) REFERENCES Clinica(id_clinica) ON DELETE CASCADE,
    CONSTRAINT fk_cp_paciente FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente) ON DELETE CASCADE
);

CREATE TABLE Medico_Especialidade (
    id_medico INT NOT NULL,
    id_especialidade INT NOT NULL,
    PRIMARY KEY (id_medico, id_especialidade),
    CONSTRAINT fk_me_medico FOREIGN KEY (id_medico) REFERENCES Medico(id_medico) ON DELETE CASCADE,
    CONSTRAINT fk_me_especialidade FOREIGN KEY (id_especialidade) REFERENCES Especialidade(id_especialidade) ON DELETE CASCADE
);

-- ============================================================================
-- 2. INSERÇÃO DE DADOS REALISTAS (DML) - 12 REGISTROS POR TABELA
-- ============================================================================

-- Insercao na tabela: Clinica
INSERT INTO Clinica (cnpj, nome, endereco, telefone, email, site, funcionamento) VALUES
('11111111000101', 'Clinica Care Central', 'Av. Brasil, 1000', '8330000001', 'contato@carecentral.com', 'www.carecentral.com', '07:00 as 19:00'),
('22222222000102', 'Clinica Care Norte', 'Rua das Flores, 200', '8330000002', 'norte@carecentral.com', 'www.carenorte.com', '08:00 as 18:00'),
('33333333000103', 'Clinica Care Sul', 'Av. Epitacio Pessoa, 500', '8330000003', 'sul@carecentral.com', 'www.caresul.com', '07:00 as 20:00'),
('44444444000104', 'Clinica Care Leste', 'Rua dos Bananeiros, 40', '8330000004', 'leste@carecentral.com', 'www.careleste.com', '08:00 as 17:00'),
('55555555000105', 'Clinica Care Oeste', 'Av. Pedro II, 300', '8330000005', 'oeste@carecentral.com', 'www.careoeste.com', '07:00 as 18:00'),
('66666666000106', 'Clinica Care Praia', 'Av. Cabo Branco, 150', '8330000006', 'praia@carecentral.com', 'www.carepraia.com', '08:00 as 22:00'),
('77777777000107', 'Clinica Care Centro', 'Rua Maciel Pinheiro, 80', '8330000007', 'centro@carecentral.com', 'www.carecentro.com', '07:00 as 19:00'),
('88888888000108', 'Clinica Care Infantil', 'Rua das Criancas, 12', '8330000008', 'pediatria@carecentral.com', 'www.careinfantil.com', '08:00 as 18:00'),
('99999999000109', 'Clinica Care Mulher', 'Av. Manais, 99', '8330000009', 'mulher@carecentral.com', 'www.caremulher.com', '08:00 as 18:00'),
('10101010000110', 'Clinica Care Coracao', 'Rua dos Cardiologistas, 5', '8330000010', 'coracao@carecentral.com', 'www.carecoracao.com', '07:00 as 17:00'),
('12121212000111', 'Clinica Care Trauma', 'Av. Principal, 1010', '8330000011', 'trauma@carecentral.com', 'www.caretrauma.com', '24 Horas'),
('13131313000112', 'Clinica Care Olhos', 'Rua da Visao, 77', '8330000012', 'olhos@carecentral.com', 'www.careolhos.com', '08:00 as 17:00');

-- Insercao na tabela: Especialidade
INSERT INTO Especialidade (nome_especialidade) VALUES
('Pediatria'), ('Cardiologia'), ('Oftalmologia'), ('Dermatologia'), 
('Psiquiatria'), ('Pneumologia'), ('Ortopedia'), ('Ginecologia'),
('Neurologia'), ('Endocrinologia'), ('Gastroenterologia'), ('Urologia');

-- Insercao na tabela: Medico
INSERT INTO Medico (nome, cpf, crm, email, telefone, endereco, idade) VALUES
('Dr. Carlos Eduardo', '11111111101', 'CRM-PB 1001', 'carlos@medico.com', '83991110001', 'Rua A, 1', 46),
('Dra. Ana Maria', '11111111102', 'CRM-PB 1002', 'ana@medico.com', '83991110002', 'Rua B, 2', 41),
('Dr. Roberto Alves', '11111111103', 'CRM-PB 1003', 'roberto@medico.com', '83991110003', 'Rua C, 3', 51),
('Dra. Juliana Paes', '11111111104', 'CRM-PB 1004', 'juliana@medico.com', '83991110004', 'Rua D, 4', 35),
('Dr. Marcos Vinicius', '11111111105', 'CRM-PB 1005', 'marcos@medico.com', '83991110005', 'Rua E, 5', 44),
('Dra. Beatriz Costa', '11111111106', 'CRM-PB 1006', 'beatriz@medico.com', '83991110006', 'Rua F, 6', 38),
('Dr. Fernando Dias', '11111111107', 'CRM-PB 1007', 'fernando@medico.com', '83991110007', 'Rua G, 7', 47),
('Dra. Camila Pitanga', '11111111108', 'CRM-PB 1008', 'camila@medico.com', '83991110008', 'Rua H, 8', 34),
('Dr. Lucas Lima', '11111111109', 'CRM-PB 1009', 'lucas@medico.com', '83991110009', 'Rua I, 9', 42),
('Dra. Patricia Pillar', '11111111110', 'CRM-PB 1010', 'patricia@medico.com', '83991110010', 'Rua J, 10', 50),
('Dr. Gabriel Medina', '11111111111', 'CRM-PB 1011', 'gabriel@medico.com', '83991110011', 'Rua K, 11', 35),
('Dra. Sofia Alcantara', '11111111112', 'CRM-PB 1012', 'sofia@medico.com', '83991110012', 'Rua L, 12', 39);

-- Insercao na tabela: Paciente
INSERT INTO Paciente (nome, cpf, telefone, endereco, email, idade, genero) VALUES
('Joao da Silva', '22222222201', '83988880001', 'Rua A, 10', 'joao@paciente.com', 36, 'Masculino'),
('Maria Oliveira', '22222222202', '83988880002', 'Rua B, 20', 'maria@paciente.com', 31, 'Feminino'),
('Pedro Santos', '22222222203', '83988880003', 'Rua C, 30', 'pedro@paciente.com', 41, 'Masculino'),
('Ana Lucia Souza', '22222222204', '83988880004', 'Rua D, 40', 'analucia@paciente.com', 26, 'Feminino'),
('Lucas Ferreira', '22222222205', '83988880005', 'Rua E, 50', 'lucasf@paciente.com', 48, 'Masculino'),
('Carla Rocha', '22222222206', '83988880006', 'Rua F, 60', 'carla@paciente.com', 34, 'Feminino'),
('Rafael Lima', '22222222207', '83988880007', 'Rua G, 70', 'rafael@paciente.com', 38, 'Masculino'),
('Fernanda Torres', '22222222208', '83988880008', 'Rua H, 80', 'fernandat@paciente.com', 61, 'Feminino'),
('Bruno Gagliasso', '22222222209', '83988880009', 'Rua I, 90', 'bruno@paciente.com', 44, 'Masculino'),
('Juliana Paiva', '22222222210', '83988880010', 'Rua J, 100', 'jpaiva@paciente.com', 27, 'Feminino'),
('Thiago Lacerda', '22222222211', '83988880011', 'Rua K, 110', 'thiago@paciente.com', 50, 'Masculino'),
('Vanessa Giacomo', '22222222212', '83988880012', 'Rua L, 120', 'vanessa@paciente.com', 36, 'Feminino');

-- Insercao na tabela: Consulta
INSERT INTO Consulta (id_paciente, id_medico, id_clinica, dia, horario, valor, status, tipo_atendimento, categoria_consulta) VALUES
(1, 1, 1, '2026-08-01', '08:30:00', 250.00, 'Realizada', 'Presencial', 'Especialista'),
(2, 2, 2, '2026-08-02', '14:00:00', 200.00, 'Realizada', 'Presencial', 'Rotina'),
(3, 3, 3, '2026-08-03', '09:00:00', 300.00, 'Realizada', 'Telemedicina', 'Retorno'),
(4, 4, 4, '2026-08-04', '15:00:00', 180.00, 'Cancelada', 'Presencial', 'Rotina'),
(5, 5, 5, '2026-08-05', '10:00:00', 220.00, 'Realizada', 'Presencial', 'Urgencia'),
(6, 6, 6, '2026-08-06', '16:00:00', 280.00, 'Agendada', 'Presencial', 'Especialista'),
(7, 7, 7, '2026-08-07', '11:00:00', 250.00, 'Realizada', 'Presencial', 'Rotina'),
(8, 8, 8, '2026-08-08', '14:30:00', 190.00, 'Realizada', 'Telemedicina', 'Retorno'),
(9, 9, 9, '2026-08-09', '08:00:00', 350.00, 'Realizada', 'Presencial', 'Especialista'),
(10, 10, 10, '2026-08-10', '13:30:00', 400.00, 'Agendada', 'Presencial', 'Exame Completo'),
(11, 11, 11, '2026-08-11', '09:30:00', 210.00, 'Realizada', 'Presencial', 'Urgencia'),
(12, 12, 12, '2026-08-12', '15:30:00', 260.00, 'Realizada', 'Presencial', 'Rotina');

-- Insercao na tabela: Pagamento
INSERT INTO Pagamento (id_consulta, id_paciente, valor, pago, metodo_pagamento) VALUES
(1, 1, 250.00, TRUE, 'Dinheiro'),
(2, 2, 200.00, TRUE, 'Debito'),
(3, 3, 300.00, TRUE, 'Credito'),
(4, 4, 180.00, FALSE, 'Convenio'),
(5, 5, 220.00, TRUE, 'Debito'),
(6, 6, 280.00, FALSE, 'Credito'),
(7, 7, 250.00, TRUE, 'Dinheiro'),
(8, 8, 190.00, TRUE, 'Convenio'),
(9, 9, 350.00, TRUE, 'Credito'),
(10, 10, 400.00, FALSE, 'Debito'),
(11, 11, 210.00, TRUE, 'Debito'),
(12, 12, 260.00, TRUE, 'Dinheiro');

-- Insercao na tabela: Prontuario
INSERT INTO Prontuario (id_consulta, id_paciente, diagnostico, exame, prescricao, sintoma, tipo_sanguineo, historico) VALUES
(1, 1, 'Hipertensao Arterial', 'Ecocardiograma', 'Losartana 50mg', 'Dor de cabeca, tontura', 'O+', 'Sem comorbidades graves'),
(2, 2, 'Amigdalite Aguda', 'Hemograma Completo', 'Amoxicilina 500mg', 'Dor de garganta, febre', 'A+', 'Alergia a Dipirona'),
(3, 3, 'Dermatite de Contato', 'Nenhum', 'Dexametasona Creme', 'Coceira na pele, vermelhidao', 'B-', 'Hipertenso'),
(4, 4, 'Ansiedade Generalizada', 'Nenhum', 'Sertralina 50mg', 'Insonia, taquicardia', 'AB+', 'Sem historico previo'),
(5, 5, 'Asma Bronquica', 'Espirometria', 'Salbutamol Spray', 'Falta de ar, chiado no peito', 'O-', 'Asmatico desde a infancia'),
(6, 6, 'Miopia', 'Exame de Refracao', 'Oculos de grau', 'Dificuldade para enxergar longe', 'A-', 'Sem historico'),
(7, 7, 'Entorse no Tornozelo', 'Raio-X de Tornozelo', 'Ibuprofeno 600mg', 'Dor e inchaco no pe direito', 'O+', 'Nenhum'),
(8, 8, 'Rotina Ginecologica', 'Papanicolau', 'Multivitaminico', 'Check-up anual', 'B+', 'Sem alteracoes'),
(9, 9, 'Enxaqueca Cronica', 'Ressonancia Magnetica', 'Sumatriptana 50mg', 'Dor pulsatil forte', 'AB-', 'Enxaqueca familiar'),
(10, 10, 'Diabetes Tipo 2', 'Glicemia em Jejum', 'Metformina 850mg', 'Sede excessiva, fadiga', 'O+', 'Obesidade grau 1'),
(11, 11, 'Gastrite Aguda', 'Endoscopia Digestiva', 'Omeprazol 20mg', 'Dor no estomago, azia', 'A+', 'Fumante'),
(12, 12, 'Calculo Renal', 'Ultrassom Renal', 'Cetonofeno 100mg', 'Dor lombar intensa', 'O+', 'Historico de calculos');

-- Insercoes nas Tabelas Associativas N:N
INSERT INTO Clinica_Medico (id_clinica, id_medico) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12);

INSERT INTO Clinica_Paciente (id_clinica, id_paciente) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12);

INSERT INTO Medico_Especialidade (id_medico, id_especialidade) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12);

-- ============================================================================
-- 2.1 OPERAÇÕES DE UPDATE (MÍNIMO 3 EXIGIDAS)
-- ============================================================================

-- Update 1: Atualizar o status de uma consulta agendada para 'Realizada'
UPDATE Consulta 
SET status = 'Realizada' 
WHERE id_consulta = 6;

-- Update 2: Atualizar o valor de uma consulta específica
UPDATE Consulta 
SET valor = 230.00 
WHERE id_consulta = 5;

-- Update 3: Atualizar endereco e telefone de um paciente
UPDATE Paciente 
SET endereco = 'Rua Nova, 500', telefone = '83999999999' 
WHERE id_paciente = 1;

-- ============================================================================
-- 3. CONSULTAS E ANÁLISES (DQL)
-- ============================================================================

-- 3.1 Consultas de Agregação / Agrupamento (COUNT, SUM, AVG, MAX, MIN)

-- Agregação 1: Média do valor das consultas agendadas por Especialidade Médica (AVG)
SELECT e.nome_especialidade, AVG(c.valor) AS media_valor_consulta
FROM Consulta c
JOIN Medico m ON c.id_medico = m.id_medico
JOIN Medico_Especialidade me ON m.id_medico = me.id_medico
JOIN Especialidade e ON me.id_especialidade = e.id_especialidade
GROUP BY e.nome_especialidade;

-- Agregação 2: Total de faturamento (SUM) acumulado por Médico em pagamentos confirmados
SELECT m.nome AS medico, SUM(p.valor) AS total_faturado
FROM Pagamento p
JOIN Consulta c ON p.id_consulta = c.id_consulta
JOIN Medico m ON c.id_medico = m.id_medico
WHERE p.pago = TRUE
GROUP BY m.nome;

-- Agregação 3: Quantidade total de pacientes associados a cada Clínica (COUNT)
SELECT cl.nome AS clinica, COUNT(cp.id_paciente) AS qtd_pacientes
FROM Clinica cl
LEFT JOIN Clinica_Paciente cp ON cl.id_clinica = cp.id_clinica
GROUP BY cl.nome;

-- Agregação 4: Maior e menor valor de consulta praticado no sistema (MAX e MIN)
SELECT MAX(valor) AS maior_valor_consulta, MIN(valor) AS menor_valor_consulta 
FROM Consulta;


-- 3.2 Consultas com Operações de JOIN (INNER, LEFT, RIGHT)

-- JOIN 1: INNER JOIN - Pacientes com histórico de consultas e o nome do médico correspondente
SELECT p.nome AS paciente, c.dia, c.horario, m.nome AS medico, c.status
FROM Consulta c
INNER JOIN Paciente p ON c.id_paciente = p.id_paciente
INNER JOIN Medico m ON c.id_medico = m.id_medico;

-- JOIN 2: INNER JOIN - Consultas consolidadas com clínica, médico, paciente e dados de pagamento
SELECT c.id_consulta, cl.nome AS clinica, m.nome AS medico, p.nome AS paciente, pg.metodo_pagamento, pg.pago
FROM Consulta c
INNER JOIN Clinica cl ON c.id_clinica = cl.id_clinica
INNER JOIN Medico m ON c.id_medico = m.id_medico
INNER JOIN Paciente p ON c.id_paciente = p.id_paciente
INNER JOIN Pagamento pg ON c.id_consulta = pg.id_consulta;

-- JOIN 3: LEFT JOIN - Médicos e suas respectivas especialidades vinculadas
SELECT m.nome AS medico, m.crm, e.nome_especialidade
FROM Medico m
LEFT JOIN Medico_Especialidade me ON m.id_medico = me.id_medico
LEFT JOIN Especialidade e ON me.id_especialidade = e.id_especialidade;

-- JOIN 4: RIGHT JOIN - Prontuários médicos vinculados às informações de identificação do paciente
SELECT p.nome AS paciente, pr.diagnostico, pr.prescricao, pr.sintoma, pr.tipo_sanguineo
FROM Prontuario pr
RIGHT JOIN Paciente p ON pr.id_paciente = p.id_paciente;clinica_paciente