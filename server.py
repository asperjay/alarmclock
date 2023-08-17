import http.server
import socketserver
import openai
import sys
import json
sys.path.append('/Users/jasper/Desktop')
import datetime
import alarm_config
openai.api_key = alarm_config.API_KEY
def get_completion(prompt, model="gpt-3.5-turbo"):
    messages = [{"role": "user", "content": prompt}]
    response = openai.ChatCompletion.create(
        model=model,
        messages=messages,
        temperature=0,
    )
    return response.choices[0].message["content"]
current_date_time = datetime.datetime.now()
formatted_date_time = current_date_time.strftime("%Y-%m-%d %H:%M:%S")
prompt1 = "The current date and time is 10:08pm august 16 2023"+""".
Convert the following message into a list of precise dates and times:
"""
prompt2 = """
Assume that the user asks for a single alarm unlesss they specify otherwise. Please return this information in JSON format as a single dictionary with two keys. The first key should be “times” and the value a JSON array of ISO 8601 formatted date+times. The second key should be “response” and the value a message summarizing the dates."""

# Choose a port number for your server
PORT = 8001
# Define a custom request handler by subclassing BaseHTTPRequestHandler
class MyRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        # Get the client's request path
        request_path = self.path

        # Send response status code
        self.send_response(200)

        # Set response headers for JSON
        self.send_header("Content-type", "application/json")
        self.end_headers()

        userText = ''
        for i in request_path[3:]: # replace + with space and take off the /?q
            if i == "+":
                userText += " "
            else:
                userText += i

        # get response from LLM
        completion = get_completion(prompt1 + userText + prompt2)
        print(completion)
        # Write the JSON response
        self.wfile.write(completion.encode("utf-8"))

# Create an HTTP server using the custom request handler
with socketserver.TCPServer(("", PORT), MyRequestHandler) as server:
    print(f"Server started on port {PORT}")

    # Wait for incoming requests indefinitely
    server.serve_forever()
