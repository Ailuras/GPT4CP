import openai
import os
import sys
import json

openai.api_key = "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"
model_engine = "gpt-3.5-turbo" # GPT-4

type = sys.argv[1]
folder = ""
if type == "mzn":
    folder = "minizinc-3.5"
elif type == "py":
    folder = "python-3.5"
filenames = os.listdir('JSON')

for file in filenames:
    path = f'JSON/{file}'
    with open(path, 'r') as load_f:
        load_dict = json.loads(load_f.read())
        if type == 'mzn':
            prompt = "The "+load_dict['name']+" problem is: "+load_dict['prompt']+" Build a MiniZinc model for the "+load_dict['name']+" problem. Please only output the model, without any prompt or explanation."
        elif type == 'py':
            prompt = "The "+load_dict['name']+" problem is: "+load_dict['prompt']+" Model the "+load_dict['name']+" problem using the Python API of OR-Tools. Please only output the code, without any prompt or explanation."
        else:
            prompt = load_dict['prompt']
            
        response = openai.ChatCompletion.create(
            model = model_engine,
            messages = [{"role": "user", "content": prompt}]
        )
        message = response.choices[0].message.content.strip()
        begin = message.find('```')
        end = message.rfind('```')
        code = message[begin:end].strip("```").strip("python")
        
        with open(f'Prompts/{folder}/{file.split(".")[0]}.txt') as write_f:
            write_f.write(prompt)
        with open(f'Answers/{folder}/{file.split(".")[0]}.{type}') as write_f:
            write_f.write(code)
    print("write "+file+" done.")