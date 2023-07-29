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
print(get_completion("""You are an alarm clock, and the current date/time is July 29, 2023 at 2:10 pm. As input you get a user's requests to set alarms. Output both a time, or list of times separated by line breaks, of when to set the alarm in year, month, day, hour, minutes, seconds format. This list is prefaced by the text "Times:" and a new line, and may be blank. Then, output a text output in response to the user prefaced by "Response:". You may ask for clarification. User input is prefaced by "Input:". For instance, if the user says "Input: Set an alarm for 6 pm tomorrow." you should respond with
"Times: 2023-06-30 06:00:00
Response: I have set an alarm for tomorrow at 6 pm."
Understood?"""))
