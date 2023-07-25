import openai
with open("/Users/jasper/alarm_config.txt",'r') as content: # this file contains api key
    openai.api_key = content.read()[:-1] # remove \n
def get_completion(prompt, model="gpt-3.5-turbo"):
    messages = [{"role": "user", "content": prompt}]
    response = openai.ChatCompletion.create(
        model=model,
        messages=messages,
        temperature=0,
    )
    return response.choices[0].message["content"]
print(get_completion("Explain quantum computing in simple terms"))
