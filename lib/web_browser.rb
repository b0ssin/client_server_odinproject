require 'json'
require 'socket'

host = 'localhost'     # The web server
port = 2003                        # Default HTTP port
puts "Enter GET or POST"
request_type = gets.chomp
if request_type == "GET"
  request = "GET index.html HTTP/1.0\r\n\r\n"

elsif request_type == "POST"
  viking_data = {:viking => {:name => '', :email => ''}}
  puts "Enter your name"
  name = gets.chomp
  puts "Enter your email address"
  email = gets.chomp
  viking_data[:viking][:name] = name
  viking_data[:viking][:email] = email
  viking_json = viking_data.to_json
  request = "POST thanks.html HTTP/1.0\n" +
            "Content-Length: #{viking_json.length.to_s}\r\n\r\n" +
            "#{viking_json}"
else
  puts "Enter a valid request"
  request_type = gets.chomp
end

# This is the HTTP request we send to fetch a file


socket = TCPSocket.open(host,port)  # Connect to server
puts 'socket open' 
socket.print(request)               # Send request
puts 'request printed'
response = socket.read              # Read complete response
puts 'reading response'
# Split response at first blank line into headers and body
headers,body = response.split("\r\n\r\n", 2)
puts 'response read'
print body                          # And display it
