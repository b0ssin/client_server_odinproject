require 'socket'               # Get sockets from stdlib
require 'json'

server = TCPServer.new('localhost', 2003)  # Socket to listen on port 2000
loop do
  Thread.start(server.accept) do |socket|
    puts 'client accepted'
    request = socket.read_nonblock(256)
    header, body = request.split("\r\n\r\n", 2)
    request_header = header.split(" ")
    request_type = request_header[0]
    path = request_header[1]
    puts "header: #{header}"
    puts "request_header: #{request_header}"
    puts "request_type: #{request_type}"
    puts "path: #{path}"
    puts "body: #{body.to_s}"
  
    if request_type == "GET" && File.exist?(path)
      puts 'inside the if statement'
      response_body = File.read(path)
      response_head = "HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n"
    elsif request_type == "POST" && File.exist?(path)
      puts 'Inside the PATH elsif statement'
      params = JSON.parse(body)
      puts 'parsed JSON' 
      puts params.to_s
      list_elements = ""
      params["viking"].each do |key, value|
        list_elements += "<li>#{key}: #{value}</li>\n      "
      end
      puts 'list_elements: #{list_elements}'
      response_body = (File.read(path)).gsub("<%= yield %>", list_elements)
      puts 'read the file and gsubbed'
      response_head = "HTTP/1.0 200 OK\nContent-Length: #{response_body.length}\r\n\r\n"
      puts 'response_head saved'
    else
      puts 'Inside the else statement'
      response_body = "Not Found"
      response_head = "HTTP/1.0 404"
    end
  # start printing header and body response
  socket.print(response_head)
  puts 'printed the response_head'
  socket.print(response_body)
  puts 'printed the reponse_body'
  socket.close
  end
end
