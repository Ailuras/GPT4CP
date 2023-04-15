# GPT4CP
It is a CLI for generating mzn/py file via ChatGPT python API.

requirements:
    openai: pip install openai
    network: use proxy
        my experience: in WSL (version 1), I just write the following lines into ~/.bashrc and `source ~/.bashrc`:
            export http_proxy=http://127.0.0.1:your_proxy_port
            export https_proxy=socks5://127.0.0.1:your_proxy_port

To use it,
    1. put your json file into corresponding directory
    2. generate your own API key and add to process.py (line 7)
        openai.api_key = "YOUR-API-KEY"
    3. run process.py 
        a. for mzn file:    $ python process.py mzn
        b. for py file:     $ python process.py py
    4. the result files will be generated automatically to Answers