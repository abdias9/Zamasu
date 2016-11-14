# encoding: utf-8

module Zamasu
    # Classe para armazenamento de informações sobre a conexão com o Cliente.
    class ClientInfo
        # Variável estática para realizar o controle de cada conexão.
        @@count = 1

        # @return [Integer] ID do cliente.
        attr_accessor :id
        # @return [String] Hostname do Cliente
        attr_accessor :host 
        # @return [Integer] Porta do Cliente
        attr_accessor :port

        # Instancia ClientInfo
        # @param [String] host Hostname do Cliente
        # @param [Integer] port Porta do Cliente
        def initialize(host, port)
            @id = @@count
            @host, @port = host, port
            @@count += 1
        end

        # Realiza a comparação entre dois objetos ClientInfo e verifica se seus valores são iguais (exceto o membro id).
        # @return [true/false]
        def ==(client)
            return false if client == nil
            return (@host == client.host && @port == client.port)
        end
    end
end