Ao ler o desafio, optei por criar 5 tabelas: Cliente, Pedido, Item de Pedido, Produto, Categoria.

A tabela de Item de pedido serviu com o propósito de intermediar a de Pedido e Produto. Sem a mesma, um produto participaria de vários pedidos, assim como um pedido possuiria vários produtos. Criando-a, um Produto poderá participar de vários Itens de Pedido, porém um Item de pedido terá somente um produto. Igualmente, um Pedido possuirá vários Itens de Pedido, porém um Item de Pedido pertencerá a somente um Pedido. Essa lógica da tabela adicional evita relações do tipo 0 ou 1..* -> 0 ou 1..*, que acabam criando linhas extras com informações repetidas. Segue exemplo: 
Sem tabela adicional

PEDIDO
ID      ID_CLIENTE      ID_PRODUTO                ENDERECO
1           1               3             Rua Lauro Linhares, 2055
ID      ID_CLIENTE      ID_PRODUTO                ENDERECO
1           1               33             Rua Lauro Linhares, 2055
ID      ID_CLIENTE      ID_PRODUTO                ENDERECO
1           1               4              Rua Lauro Linhares, 2055

Com tabela adicional
PEDIDO
ID     ID_CLIENTE           ENDERECO
1          1          Rua Lauro Linhares, 2055
ITEM_PEDIDO
ID           ID_PRODUTO             ID_PEDIDO
1               3                       1
1               33                      1
1               4                       1

É observável uma diferença no endereço e id_cliente por exemplo, onde as linhas foram repetidas desnecessariamente. Ao projetar a seguinte lógica em um banco de dados do tamanho das aplicações da Bridge, obteríamos um ganho de desempenho.

Optei também por colocar o campo de endereço de entrega no pedido, visto que um cliente poderia realizar um pedido em vários locais diferentes, como um Ifood por exemplo.

O script para alimentar as tabelas foi feito de forma automática, podendo gerar N linhas nas tabelas desejadas, apenas alterando variáveis. Para isso, utilizei laços de repetição,  criando Produtos de 1 até N, Categorias de 1 até N, Cliente de 1 até N e Pedidos de 1 até N. Já no caso de Itens de Pedido, usei a função RANDOM() para gerar um número aleatório de até no máximo N produtos por pedido, e também randomizar o prazo de entrega. Nunca havia utilizado tais funções no PostgreSQL e achei super interessante aprender sobre elas. 

Achei o desafio uma ótima oportunidade de testar meus conhecimentos e aprofundá-los na área. Fico a disposição para esclarecer qualquer dúvida acerca do código.

Sites consultados:
https://www.postgresqltutorial.com/postgresql-plpgsql/plpgsql-for-loop/
