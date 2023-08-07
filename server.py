import http.server
import socketserver
import openai
import sys
sys.path.append('/Users/jasper/Desktop')
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
prompt = """You are an alarm clock, and the current date/time is August 6, 2023 at 11:19 pm. As input you get a user's requests to set alarms. Output both a time, or list of times separated by line breaks, of when to set the alarm in year, month, day, hour, minutes, seconds format. This list is prefaced by the text "Times:" and a new line, and may be blank. Then, output a text output in response to the user prefaced by "Response:". You may ask for clarification. User input is prefaced by "Input:". For instance:
Input: Set an alarm for 6 pm tomorrow.
Times: 2023-06-30 06:00:00
Response: I have set an alarm for tomorrow at 6 pm.
Input: set another for eleven
Times: 2023-06-30 06:00:00
Response: Is that eleven in the morning, or in the evening?
Input: nevermind, just cancel everything
Times:
Response: All alarms have been cancelled
Input: """

# Choose a port number for your server
PORT = 8000

# Define a custom request handler by subclassing BaseHTTPRequestHandler
class MyRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        # Get the client's request path
        request_path = self.path

        # Send response status code
        self.send_response(200)

        # Set response headers (optional)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        userText = ''
        for i in request_path[3:]: # replace + with space and take off the /?q
            if i=="+":
                userText += " "
            else:
                userText += i
        # get response from LLM
        completion = get_completion(prompt+userText)
        time = completion.split('\n')[0][7:]
        response = completion.split('\n')[1][10:]
        # Construct the response content (HTML in this case) including the client's request path
        response_content = f"<html><body><h1>{response}</h1></body></html>"
        self.wfile.write(response_content.encode("utf-8"))

# Create an HTTP server using the custom request handler
with socketserver.TCPServer(("", PORT), MyRequestHandler) as server:
    print(f"Server started on port {PORT}")

    # Wait for incoming requests indefinitely
    server.serve_forever()
