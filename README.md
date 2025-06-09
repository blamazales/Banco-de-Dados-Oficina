# 🔧 Sistema de Gestão de Oficina Mecânica

Este projeto tem como objetivo a modelagem e implementação de um banco de dados relacional para o gerenciamento de uma oficina mecânica. O sistema permite o controle de clientes, veículos, serviços prestados, ordens de serviço, execução dos serviços por mecânicos e os respectivos pagamentos.

---

## 📐 Esquema Lógico

A modelagem segue o paradigma relacional, com tabelas interligadas por chaves primárias e estrangeiras. Abaixo está a descrição das entidades e seus atributos com respectivos tipos de dados:

### Entidades e Atributos

#### 🧑 Cliente
- `idCliente INT AUTO_INCREMENT PRIMARY KEY`
- `nome VARCHAR(100)`
- `telefone VARCHAR(15)`
- `email VARCHAR(100)`
- `tipoCliente ENUM('PF','PJ')`
- `CPF_CNPJ VARCHAR(20) UNIQUE`

#### 🚗 Veículo
- `idVeiculo INT AUTO_INCREMENT PRIMARY KEY`
- `idCliente INT` (FK)
- `placa VARCHAR(10) UNIQUE`
- `modelo VARCHAR(50)`
- `marca VARCHAR(50)`
- `ano INT`

#### 🛠️ Serviço
- `idServico INT AUTO_INCREMENT PRIMARY KEY`
- `descricao VARCHAR(255)`
- `preco DECIMAL(10,2)`

#### 📋 Ordem de Serviço
- `idOrdem INT AUTO_INCREMENT PRIMARY KEY`
- `idVeiculo INT` (FK)
- `dataEntrada DATE`
- `dataSaida DATE`
- `status ENUM('Em aberto', 'Em andamento', 'Concluída', 'Cancelada')`

#### 📦 Itens da Ordem de Serviço
- `idOrdem INT` (FK)
- `idServico INT` (FK)
- `quantidade INT DEFAULT 1`

#### 👨‍🔧 Mecânico
- `idMecanico INT AUTO_INCREMENT PRIMARY KEY`
- `nome VARCHAR(100)`
- `especialidade VARCHAR(100)`

#### ⛏️ Execução do Serviço
- `idOrdem INT` (FK)
- `idServico INT` (FK)
- `idMecanico INT` (FK)
- `dataExecucao DATE`

#### 💰 Pagamento
- `idPagamento INT AUTO_INCREMENT PRIMARY KEY`
- `idOrdem INT` (FK)
- `tipoPagamento ENUM('Dinheiro', 'Cartão', 'PIX', 'Transferência')`
- `valor DECIMAL(10,2)`
- `dataPagamento DATE`
