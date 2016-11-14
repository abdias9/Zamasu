# Zamasu
Zamasu é um pequeno conjunto de classes para o serviço de compartilhamento de Hashes via UDP. Através da classe Zamasu::Server será possível receber e transmitir informações através do protocolo UDP, sincronizando essas informações de maneira leve e ágil, dando acesso remoto e compartilhado a um Hash de informações recebidas pelos clientes.

# Documentação
Zamasu é 100% documentada em português. Você pode acessar através do nosso [Endereço Temporário](https://zamasu.000webhostapp.com/). 

# Requisitos
* Possuir o [Ruby](https://www.ruby-lang.org/) instalado (recomendo a versão 2.3).

# Exemplos
No diretório [Exemplos](https://github.com/abdias9/Zamasu/tree/master/Example), é possível encontrar exemplos síncronos da utilização do Zamasu, incluindo sua aplicação para o desenvolvimento de jogos utilizando a biblioteca [libgosu](https://www.libgosu.org/).

# Servidor
```ruby
require_relative 'ZamasuServer.rb'

# Cria uma nova instância do servidor que opera na porta 9009.
Zamasu::Server.new(9009)
```

# Cliente
```ruby
require_relative 'ZamasuClient.rb'

# Realiza uma conexão com o servidor através das informações fornecidas.
client = Zamasu::Client.new('localhost', 9009)
# Inicializa o Hash compartilhado.
client.initialize_attributes({'x' => 1, 'y' => 2})
# Seta individualmente um atributo no lado do servidor.
client.set_attrib('x', 8)
# Aguarda um segundo (tempo mais que necessário) para que já tenha recebido as informações atualizadas do hash remoto.
sleep(1)
# Exibe o valor do atributo 'x'. Exatamente a última versão que recebeu do servidor.
puts client.get_attrib('x')
```