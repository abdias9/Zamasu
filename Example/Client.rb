# encoding: utf-8

# Initializes the NetworkClient connection with the server.
client = NetworkClient.new 'localhost', 9009

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