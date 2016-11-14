# encoding: utf-8

require '../ZamasuClient.rb'

# Initializes the Zamasu::Client connection with the server.
client = Zamasu::Client.new 'localhost', 9009

# Intialize all attributes of the Hash.
client.initialize_attributes {
    'v1' => 10, 
    'v2' => 15, 
    'v3' => 20
} 

for i in 0...10 do 
    client.increment_attrib('v1', 1)
    client.increment_attrib('v2', -1)
    client.increment_attrib('v3', 2)
end