from flask import Flask, request, jsonify
import ollama

app = Flask(__name__)

@app.route('/ollama_chat', methods=['POST'])
def ollama_chat():
    data = request.json
    messages = data.get('messages')  # Ensure 'messages' key exists and is a list
    if not isinstance(messages, list):
        return jsonify({'error': 'Invalid message format'}), 400

    try:
        response = ollama.chat(model='llama2', messages=messages)
    except Exception as e:
        # Log the error and return a 500 error response
        app.logger.error(f"Failed to get response from Ollama: {e}")
        return jsonify({'error': 'Failed to get response from Ollama', 'details': str(e)}), 500

    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

