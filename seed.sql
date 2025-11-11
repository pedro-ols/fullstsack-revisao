CREATE DATABASE pizzaria;
\c pizzaria

CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100),
  email VARCHAR(100) UNIQUE NOT NULL,
  senha VARCHAR(50) NOT NULL,
  tipo VARCHAR(20) DEFAULT 'comum'
);

CREATE TABLE pizzas (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  preco DECIMAL(10,2) NOT NULL,
  estoque INTEGER DEFAULT 0
);

CREATE TABLE vendas (
  id SERIAL PRIMARY KEY,
  usuario_id INTEGER REFERENCES usuarios(id),
  pizza_id INTEGER REFERENCES pizzas(id),
  quantidade INTEGER NOT NULL,
  data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserindo dados iniciais
INSERT INTO usuarios (nome, email, senha, tipo) VALUES
('Admin Pizzaria', 'admin@pizzaria.com', '123', 'admin'),
('Funionario 1', 'funionario1@pizzaria.com', '123', 'comum');

INSERT INTO pizzas (nome, preco, estoque) VALUES
('Margheritta', 66.50, 10),
('4 Queijos', 64.00, 15),
('Chocolate', 75.00, 12);

INSERT INTO vendas (usuario_id, pizza_id, quantidade) VALUES
(2, 1, 2),
(2, 3, 1),

UPDATE pizzas SET estoque = estoque - ( 
  SELECT COALESCE(SUM(quantidade), 0) 
  FROM vendas 
  WHERE vendas.pizza_id = pizzas.id
);