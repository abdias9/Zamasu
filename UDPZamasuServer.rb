# encoding: utf-8

require 'socket'
require_relative 'ClientInfo.rb'

# Tamanho máximo do pacote transmitido pela UDPSocket.
BUFF = 1024

# UDPZamasuServer é o servidor responsável por armazenar um Hash remoto e sincronizar seus valores através dos Clientes.
class UDPZamasuServer
    # Instancia um novo UDPZamasuServer e reserva a porta necessária para as operações de entrada. Inicia o loop de recebimento e as devidas operações de saída atavés de UDPSockets
    # @param [Integer] port Porta a ser usada.
    def initialize(port)
        @clients = Array.new
        @attributes = Hash.new nil
        @last_attributes = @attributes.clone
        @sock = UDPSocket.new
        @sock.bind nil, port
        @out = UDPSocket.new
        recv
    end


    def recv
        loop do 
            message, address = @sock.recvfrom(BUFF)
            _, port, host, _, = address
            puts "[RECV] #{message} from #{host}:#{port}"
            client = ClientInfo.new(host, 9010)
            append_client(client)
            process message
        end
    end

    def sync
        if !equal_attributes(@attributes, @last_attributes)
            send("[set-attrib] %#{@attributes}")
            @last_attributes = @attributes.clone
        end        
    end

    def send(message)
        @clients.each do |client|
            @out.connect client.host, client.port
            @out.send message, 0    
        end
    end

    def append_client(client)
        is = false 
        @clients.each do |c|
            if c == client
                return 
            end 
        end
        @clients.push client
        puts "[INFO] Cliente adicionado #{client.host}:#{client.port}"
    end

    def process(message)
        cmd = message.split
        case cmd[0]
        when '[set-attrib]'
            for i in 1...cmd.size
                name, value = cmd[i].split('=')
                @attributes[name] = eval(value)
            end        

        when '[increment-attrib]'
            for i in 1...cmd.size
                name, value = cmd[i].split('=')
                @attributes[name] += eval(value)
            end
        end

        if cmd[0] == '[set-attribs]'
            @attributes = eval(message.split('%')[1])
        end

        sync
    end

    def equal_attributes(at1, at2) 
        if at1.size == at2.size
            at1.each_key do |key|
                if at1[key] != at2[key]
                    return false
                end
            end
            return true
        end
        return false
    end

    private :recv, :sync, :equal_attributes, :process, :send, :append_client
end