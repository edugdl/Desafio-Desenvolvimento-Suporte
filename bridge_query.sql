-- drop table item_pedido;
-- drop table pedido;
-- drop table produto;
-- drop table cliente;
-- drop table categoria;

CREATE TABLE CLIENTE (
	id SERIAL PRIMARY KEY,
	nome varchar(255),
	telefone varchar(255),
	email varchar(255)
);

CREATE TABLE PEDIDO (
	id SERIAL PRIMARY KEY,
	id_cliente int,
	FOREIGN KEY (id_cliente) REFERENCES CLIENTE (id),
	data_entrega date,
	endereco varchar(255)
);

CREATE TABLE CATEGORIA (
	id SERIAL PRIMARY KEY,
	nome varchar(255)
);

CREATE TABLE PRODUTO (
	id SERIAL PRIMARY KEY,
	id_categoria int,
	FOREIGN KEY (id_categoria) REFERENCES CATEGORIA (id),
	nome varchar(255),
	descricao varchar(255),
	preco float
);

CREATE TABLE ITEM_PEDIDO (
	id SERIAL PRIMARY KEY,
	id_produto int,
	id_pedido int,
	FOREIGN KEY (id_produto) REFERENCES PRODUTO (id),
	FOREIGN KEY (id_pedido) REFERENCES PEDIDO (id)
);

DO $$
-- É POSSÍVEL CONTROLAR OS PARÂMETROS DE QUANTIDADE DE DADOS A SEREM INSERIDOS NAS TABELAS ABAIXO
DECLARE quantidade_categorias integer := 120;
DECLARE quantidade_produtos integer := 500;
DECLARE quantidade_clientes integer := 220;
DECLARE quantidade_pedidos integer := 1500;
DECLARE quantidade_maxima_produtos_por_pedido integer := 30;
DECLARE prazo_maximo_aleatorio_das_entregas interval := '90 days';

-- NÃO ALTERAR ATRIBUIR VALOR A LINHA ABAIXO
DECLARE r integer;

-- CODIGO PARA ALIMENTAR A TABELA DE CATEGORIAS
BEGIN
	FOR i IN 1..quantidade_categorias LOOP
		INSERT INTO CATEGORIA (nome) VALUES ('Categoria '|| i);
	END LOOP;

-- CODIGO PARA ALIMENTAR A TABELA DE PRODUTOS
	FOR j IN 1..quantidade_produtos LOOP
		INSERT INTO PRODUTO (id_categoria, nome, descricao, preco) VALUES (FLOOR(RANDOM()*(quantidade_categorias) + 1),'Nome Produto '||j, 'Descricao Produto '||j, j*4);
	END LOOP;

-- CODIGO PARA ALIMENTAR A TABELA DE CLIENTES
	FOR k IN 1..quantidade_clientes LOOP
		INSERT INTO CLIENTE (nome, telefone, email) VALUES ('Nome Cliente '||k,'Telefone Cliente '||k, 'Email Cliente '||k);
	END LOOP;

-- CODIGO PARA ALIMENTAR A TABELA DE PEDIDOS E CONSECUTIVAMENTE A TABELA DE ITEM_PEDIDO
	FOR l IN 1..quantidade_pedidos LOOP
		INSERT INTO PEDIDO (id_cliente, data_entrega, endereco) VALUES (FLOOR(RANDOM()*(quantidade_clientes) + 1),NOW()+(RANDOM()*(prazo_maximo_aleatorio_das_entregas)), 'Endereco Pedido '||l);
		r := FLOOR(RANDOM()*(quantidade_maxima_produtos_por_pedido)+1);
		WHILE r > 0 LOOP
			INSERT INTO ITEM_PEDIDO (id_produto, id_pedido) VALUES (FLOOR(RANDOM()*(quantidade_produtos) + 1), l); 
			r := r - 1;
		END LOOP;
	END LOOP;
	
-- CODIGO PARA INSERIR PRODUTOS REPETIDOS PROPOSITALMENTE A FIM DE TESTAR AS QUERYS
	INSERT INTO PRODUTO (id_categoria,nome,descricao,preco) VALUES (1,'Nome Produto 1','Descricao Produto 1',4);
	INSERT INTO PRODUTO (id_categoria,nome,descricao,preco) VALUES (1,'Nome Produto 1','Descricao Produto 1',4);
	INSERT INTO PRODUTO (id_categoria,nome,descricao,preco) VALUES (1,'Nome Produto 1','Descricao Produto 1',4);
	INSERT INTO PRODUTO (id_categoria,nome,descricao,preco) VALUES (1,'Nome Produto 3','Descricao Produto 3',12);
	
END $$;

-- Listar todos os produtos com nome, descrição e preço em ordem alfabética
-- crescente;

SELECT nome, descricao, preco FROM PRODUTO ORDER BY nome ASC;

-- Listar todas as categorias com nome e número de produtos associados, em ordem
-- alfabética crescente;

SELECT c.nome, COUNT(p) AS numero_produtos
FROM CATEGORIA c
LEFT JOIN PRODUTO p
ON p.id_categoria = c.id
GROUP BY c.id
ORDER BY c.nome ASC;

-- Listar todos os pedidos com data, endereço de entrega e total do pedido (soma dos
-- preços dos itens), em ordem decrescente de data;

SELECT pe.data_entrega, pe.endereco, SUM(pr.preco) AS total_pedido
FROM PEDIDO pe
INNER JOIN ITEM_PEDIDO ip
ON ip.id_pedido = pe.id
INNER JOIN PRODUTO pr
ON ip.id_produto = pr.id
GROUP BY pe.id
ORDER BY pe.data_entrega DESC;

-- Listar todos os produtos que já foram vendidos em pelo menos um pedido, com
-- nome, descrição, preço e quantidade total vendida, em ordem decrescente de
-- quantidade total vendida;

SELECT p.nome, p.descricao, p.preco, COUNT(p) as quantidade_total_vendida
FROM PRODUTO p
INNER JOIN ITEM_PEDIDO ip
ON p.id = ip.id_produto
GROUP BY p.id
ORDER BY quantidade_total_vendida DESC;

-- Listar todos os pedidos feitos por um determinado cliente, filtrando-os por um
-- determinado período, em ordem alfabética crescente do nome do cliente e ordem
-- crescente da data do pedido;

SELECT c.nome, c.telefone, c.email, pe.data_entrega, pe.endereco, SUM(pr.preco) as total_pedido
FROM PEDIDO pe
INNER JOIN CLIENTE c
ON pe.id_cliente = c.id
INNER JOIN ITEM_PEDIDO ip
ON ip.id_pedido = pe.id
INNER JOIN PRODUTO pr
ON ip.id_produto = pr.id
-- Para utilizar o filtro de periodo, basta alterar e descomentar a linha a seguir ex: BETWEEN '2023-03-25' AND '2023-04-16'
-- WHERE pe.data_entrega BETWEEN 'PERIODO INICIAL (yyyy-mm-dd)' AND 'PERIODO FINAL (yyyy-mm-dd)'
WHERE pe.data_entrega BETWEEN '2023-03-25' AND '2023-04-26'
GROUP BY pe.id, c.id
ORDER BY c.nome ASC, pe.data_entrega ASC;

-- Listar possíveis produtos com nome replicado e a quantidade de replicações, em
-- ordem decrescente de quantidade de replicações;

SELECT p.nome, COUNT(p.nome) AS quantidade_replicacoes
FROM PRODUTO p
GROUP BY p.nome
HAVING COUNT(p.nome) > 1
ORDER BY quantidade_replicacoes DESC;