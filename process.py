import openai
import os
import sys
import json

# Set up your OpenAI API key and model
openai.api_key = "YOUR-API-KEY"
model_engine = "gpt-3.5-turbo"  # Choose your preferred model
model_engine = "GPT-4"

# get file
typename = sys.argv[1]
filenames = os.listdir('Questions/'+typename+'/')

for file in filenames:
    path = 'Questions/' + typename + '/' + file
    with open(path, 'r') as load_f:
        load_dict = json.loads(load_f.read())
        # print(load_dict)

        # Define your prompt
        prompt = load_dict['prompt']
        # print(prompt)

        # Set up the OpenAI API request
        response = openai.ChatCompletion.create(
            model = model_engine,
            messages = [{"role": "user", "content": prompt}],
            # temperature = 1,
            # top_p = 1,
            # n = 1,
            # stream = false,
            # stop = None,
            # max_tokens = 1024,
            # presence_penalty = 0,
            # presence_penalty = 0,
            # logit_bias = None,
            # user = ""
        )

        # print(response)
        message = response.choices[0].message.content.strip()

        # ```
        begin = message.find('```')
        end = message.rfind('```')
        code = message[begin+3:end]
        # print(code)

        with open('Answers/'+typename+'/'+file.split('.')[0]+'.'+typename, 'w') as write_f:
            write_f.write(code)
        print("write "+file+" done.")