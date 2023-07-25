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
print(get_completion("Explain quantum computing in simple terms"))
