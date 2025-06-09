CREATE DATABASE oficina;
USE oficina;

-- Tabela Cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    telefone VARCHAR(15),
    email VARCHAR(100),
    tipoCliente ENUM('PF', 'PJ') NOT NULL,
    CPF_CNPJ VARCHAR(20) UNIQUE NOT NULL
);

-- Tabela Veículo
CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    placa VARCHAR(10) UNIQUE NOT NULL,
    modelo VARCHAR(50),
    marca VARCHAR(50),
    ano INT,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- Tabela Serviço
CREATE TABLE Servico (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(255),
    preco DECIMAL(10,2)
);

-- Tabela Ordem de Serviço
CREATE TABLE OrdemServico (
    idOrdem INT AUTO_INCREMENT PRIMARY KEY,
    idVeiculo INT,
    dataEntrada DATE,
    dataSaida DATE,
    status ENUM('Em aberto', 'Em andamento', 'Concluída', 'Cancelada') DEFAULT 'Em aberto',
    FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo)
);

-- Itens da ordem (serviços prestados)
CREATE TABLE OrdemServicoItem (
    idOrdem INT,
    idServico INT,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (idOrdem, idServico),
    FOREIGN KEY (idOrdem) REFERENCES OrdemServico(idOrdem),
    FOREIGN KEY (idServico) REFERENCES Servico(idServico)
);

-- Tabela Mecânico
CREATE TABLE Mecanico (
    idMecanico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    especialidade VARCHAR(100)
);

-- Execução de serviço por mecânico
CREATE TABLE ExecucaoServico (
    idOrdem INT,
    idServico INT,
    idMecanico INT,
    dataExecucao DATE,
    PRIMARY KEY (idOrdem, idServico, idMecanico),
    FOREIGN KEY (idOrdem) REFERENCES OrdemServico(idOrdem),
    FOREIGN KEY (idServico) REFERENCES Servico(idServico),
    FOREIGN KEY (idMecanico) REFERENCES Mecanico(idMecanico)
);

-- Pagamento
CREATE TABLE Pagamento (
    idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    idOrdem INT,
    tipoPagamento ENUM('Dinheiro', 'Cartão', 'PIX', 'Transferência'),
    valor DECIMAL(10,2),
    dataPagamento DATE,
    FOREIGN KEY (idOrdem) REFERENCES OrdemServico(idOrdem)
);


-- Clientes
INSERT INTO Cliente (nome, telefone, email, tipoCliente, CPF_CNPJ) VALUES
('João Silva', '11988887777', 'joao@email.com', 'PF', '12345678900'),
('Oficina LTDA', '1133445566', 'contato@oficina.com.br', 'PJ', '11222333000199');

-- Veículos
INSERT INTO Veiculo (idCliente, placa, modelo, marca, ano) VALUES
(1, 'ABC1234', 'Gol', 'Volkswagen', 2015),
(2, 'XYZ9876', 'Fiorino', 'Fiat', 2020);

-- Serviços
INSERT INTO Servico (descricao, preco) VALUES
('Troca de óleo', 120.00),
('Alinhamento', 80.00),
('Revisão completa', 500.00);

-- Mecânicos
INSERT INTO Mecanico (nome, especialidade) VALUES
('Carlos Souza', 'Motor'),
('Ana Beatriz', 'Suspensão');

-- Ordens de Serviço
INSERT INTO OrdemServico (idVeiculo, dataEntrada, dataSaida, status) VALUES
(1, '2025-06-01', '2025-06-02', 'Concluída'),
(2, '2025-06-05', NULL, 'Em andamento');

-- Itens da OS
INSERT INTO OrdemServicoItem (idOrdem, idServico, quantidade) VALUES
(1, 1, 1),
(1, 2, 1),
(2, 3, 1);

-- Execução dos serviços
INSERT INTO ExecucaoServico (idOrdem, idServico, idMecanico, dataExecucao) VALUES
(1, 1, 1, '2025-06-01'),
(1, 2, 2, '2025-06-02');

-- Pagamentos
INSERT INTO Pagamento (idOrdem, tipoPagamento, valor, dataPagamento) VALUES
(1, 'PIX', 200.00, '2025-06-02');

-- Recuperação simples (SELECT)
SELECT nome, email FROM Cliente;

-- Filtro com WHERE
SELECT * FROM Servico WHERE preco > 100;

-- Expressão para atributo derivado
SELECT 
    idOrdem, 
    SUM(s.preco * osi.quantidade) AS totalEstimado
FROM OrdemServicoItem osi
JOIN Servico s ON osi.idServico = s.idServico
GROUP BY idOrdem;

-- Ordenação com ORDER BY
SELECT nome, especialidade FROM Mecanico ORDER BY nome ASC;

-- Agrupamento com HAVING
SELECT idMecanico, COUNT(*) AS totalServicos
FROM ExecucaoServico
GROUP BY idMecanico
HAVING COUNT(*) > 1;

-- Junção para perspectiva mais complexa
-- Quais serviços cada mecânico executou por OS
SELECT 
    m.nome AS mecanico, 
    s.descricao AS servico, 
    os.idOrdem, 
    es.dataExecucao
FROM ExecucaoServico es
JOIN Mecanico m ON es.idMecanico = m.idMecanico
JOIN Servico s ON es.idServico = s.idServico
JOIN OrdemServico os ON os.idOrdem = es.idOrdem;
