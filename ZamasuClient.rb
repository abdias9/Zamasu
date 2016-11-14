# encoding: utf-8

require 'socket'
require_relative 'ClientInfo.rb'

# Tamanho máximo do pacote transmitido pela UDPSocket.
BUFF = 1024

module Zamasu
    # Zamasu::Client é em sua teoria, uma classe remota e sincronizada constantemente através de uma conexão com um Zamasu::Server.
    class Client
        # Instancia um novo Zamasu::Client e se conecta ao Zamasu::Server
        # @param [String] host Endereço do Zamasu::Server
        # @param [Integer] port Porta do Zamasu::Server
        def initialize(host, port)
            @attributes = Hash.new
            @sout = UDPSocket.new
            @sout.connect host, port
            @sin = UDPSocket.new
            @sin.bind nil, 9010
            @sping = UDPSocket.new 
            @sping.bind nil, 9011
        end
        
        # Seta o valor de um atributo através da sua chave
        # @param [String] name Chave do atributo
        # @param [Object] value Novo valor do atributo
        # @return [nil]
        def set_attrib(name, value)
            @sout.send "[set-attrib] #{name}=#{value}", 0
        end

        # Incrementa o valor de um atributo através de sua chave
        # @param [String] name Chave do atributo
        # @param [Object] value Valor do incremento
        # @return [nil]
        def increment_attrib(name, value)
            @sout.send "[increment-attrib] #{name}=#{value}", 0
        end

        # Envia todo o hash local de atributos para o Zamasu::Server
        # @param [Hash] attribs Hash de atributos
        # @return [nil]
        def set_attributes(attribs)
            @sout.send "[set-attribs] %#{attribs}", 0
        end

        # Inicializa o Hash de atributos enviando para o Zamasu::Server e setando os valores padrões na instância local
        # @param [Hash] attribs Hash de atributos
        # @return [nil]
        def initialize_attributes(attribs)
            @attributes = attribs
            set_attributes(attribs)
        end

        # Retorna o valor de um atributo contido no Hash
        # @param [String] name Chave do atributo
        # @return [Object] Valor do atributo
        def get_attrib(name)
            return @attributes[name]
        end

        # Retorna o Hash de atributos
        # @return [Hash] Hash de atributos
        def get_attributes
            return @attributes
        end

        def recv
            loop do 
                message, address = @sin.recvfrom(BUFF)
                _, port, host, _, = address
                puts "[RECV] #{message} from #{host}:#{port}"
                process(message)
            end
        end

        # Inicia o loop de recebimento de dados numa nova Thread
        # @return [nil]
        def start_recv_thread
            Thread.new do recv end
        end

        # Checa se já ocorreu o primeiro recebimento de atributos
        # @return [true/false]
        def attributes_loaded?
            return (@attributes.size != 0)
        end

        def process(message)
            cmd = message.split
            if cmd[0] == '[set-attrib]'
                @attributes = eval(message.split('%')[1])
            end
        end

        private :recv, :process
    end
end
#Zamasu::Client.new('localhost', 9009)