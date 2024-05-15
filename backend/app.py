from flask import Flask, request
from dotenv import load_dotenv
from moralis import evm_api
import json
import os

load_dotenv()

app = Flask(__name__)
api_key = os.getenv('API_KEY')


@app.route('/get_token_balance', methods=['GET'])
def get_tokens():
    chain = request.args.get('chain')
    address = request.args.get('address')

    params = {
    "chain": chain,
    "address": address,
    }

    result = evm_api.balance.get_native_balance(
    api_key=api_key,
    params=params,
    )

    return (result)

@app.route('/get_user_nfts', methods=['GET'])
def get_nfts():
    chain = request.args.get('chain')
    address = request.args.get('address')
    params = {
    "chain": chain,
    "format": "decimal",
    "media_items": False,
    "address": address
    }

    result = evm_api.nft.get_wallet_nfts(
    api_key=api_key,
    params=params)

    response = json.dumps(result, indent=4)

    return(response)

if __name__ == '__main__':
    app.run(host = "0.0.0.0", port=5002, debug=True)