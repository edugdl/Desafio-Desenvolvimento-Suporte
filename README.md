# RELATÓRIO DO DESAFIO

O SQL está fragmentado em 3 partes principais (em ordem) : Criação, Alimentação e Consulta das tabelas. Cada trecho da alimentação é brevemente comentado para uma compreensão melhor do código e cada consulta possuí seu título e filtros variáveis. (os drops no começo do sql servem para resetar as tabelas de maneira mais rápida : Descomentar, Executar o trecho do código, Recomentar, e Rodar novamente).

Ao ler o desafio, optei por criar 5 tabelas: `Cliente, Pedido, Item de Pedido, Produto, Categoria`.

A tabela de Item de pedido serviu com o propósito de intermediar a de Pedido e Produto. Sem a mesma, um produto participaria de vários pedidos, assim como um pedido possuiria vários produtos. Criando-a, um Produto poderá participar de vários Itens de Pedido, porém um Item de pedido terá somente um produto. Igualmente, um Pedido possuirá vários Itens de Pedido, porém um Item de Pedido pertencerá a somente um Pedido. Essa lógica da tabela adicional evita relações do tipo 0 ou 1..* -> 0 ou 1..*, que acabam criando linhas extras com informações repetidas. Segue exemplo: 

## Sem tabela adicional

`PEDIDO`

| ID | ID_CLIENTE | ID_PRODUTO |         ENDERECO         |
|----|------------|------------|--------------------------|
| 1  |     1      |      3     | Rua Lauro Linhares, 2055 |
| 1  |     1      |      33    | Rua Lauro Linhares, 2055 |
| 1  |     1      |      4     | Rua Lauro Linhares, 2055 |

## Com tabela adicional

`PEDIDO`

| ID | ID_CLIENTE |         ENDERECO         |
|----|------------|--------------------------|
| 1  |     1      | Rua Lauro Linhares, 2055 |

`ITEM_PEDIDO`

| ID | ID_PRODUTO | ID_PEDIDO |
|----|------------|-----------|
| 1  |      3     |     1     |           
| 2  |      33    |     1     | 
| 3  |      4     |     1     |


É observável uma diferença no endereço e id_cliente por exemplo, onde as linhas foram repetidas desnecessariamente. Ao projetar a seguinte lógica em um banco de dados do tamanho das aplicações da Bridge, obteríamos um ganho de desempenho.

Optei também por colocar o campo de endereço de entrega no pedido, visto que um cliente poderia realizar um pedido em vários locais diferentes, como um Ifood por exemplo.

O script para alimentar as tabelas foi feito de forma automática, podendo gerar N linhas nas tabelas desejadas, apenas alterando variáveis. Para isso, utilizei laços de repetição,  criando Produtos de 1 até N, Categorias de 1 até N, Cliente de 1 até N e Pedidos de 1 até N. Já no caso de Itens de Pedido, usei a função RANDOM() para gerar um número aleatório de até no máximo N produtos por pedido, e também randomizar o prazo de entrega. Nunca havia utilizado tais funções no PostgreSQL e achei super interessante aprender sobre elas. 

Além do mais, o código foi feito pensando na empresa contratada, incluindo comentários explicando o que cada parte do código realiza, e também como modificar os filtros para um melhor uso. É evidenciada essa característica em um trecho do SQL, onde o filtro do cliente é feito pelo nome, e não pelo id (que seria o mais correto e objetivo a se fazer), pois pensa-se que o usuário não saiba consultar o id dos clientes e pesquisar pelo início do nome seja mais simples. 

Achei o desafio uma ótima oportunidade de testar meus conhecimentos e aprofundá-los na área. Fico a disposição para esclarecer qualquer dúvida acerca do código.

Sites consultados ->
- https://www.postgresqltutorial.com/postgresql-plpgsql/plpgsql-for-loop/
- https://www.mssqltips.com/sqlservertip/7296/random-date-generator-sql-server/
