import http.server
import socketserver

# Choose a port number for your server
PORT = 8000

# Define a custom request handler by subclassing BaseHTTPRequestHandler
class MyRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        # Send response status code
        self.send_response(200)

        # Set response headers (optional)
        self.send_header("Content-type", "text/html")
        self.end_headers()

        # Send the response content (HTML in this case)
        self.wfile.write(b"<html><body><h1>Hello, world!</h1></body></html>")

# Create an HTTP server using the custom request handler
with socketserver.TCPServer(("", PORT), MyRequestHandler) as server:
    print(f"Server started on port {PORT}")

    # Wait for incoming requests indefinitely
    server.serve_forever()
