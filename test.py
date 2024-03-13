import requests

# 0.0.0.0:11434
# http://127.0.0.1:11434/ollama_chat

def test_ollama_chat():
    #url = 'http://localhost:5000/ollama_chat'
    url = 'https://promoted-yak-loosely.ngrok-free.app/ollama_chat'
    payload = {
        'messages': [
            {
                'role': 'user',
                'content': 'Guide me in a concentration meditation',
            }
        ]
    }
    
    try:
        response = requests.post(url, json=payload)
        print(f"Status Code: {response.status_code}")
        print(f"Response Body: {response.text}")  # Ensure response is printed
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == '__main__':
    test_ollama_chat()
