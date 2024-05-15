const express = require("express");
const axios = require("axios");
const dotenv = require("dotenv");
const { createAlchemyWeb3 } = require("@alch/alchemy-web3");

dotenv.config();

const app = express();
const port = 3000;

app.use(express.json());

app.post("/jsonrpc", async (req, res) => {
  const { jsonrpc, method, params, id } = req.body;

  try {
    const rpcURL = process.env.ALCHEMY_RPC_URL;
    const response = await axios.post(rpcURL, {
      jsonrpc,
      method,
      params,
      id,
    });

    res.json(response.data);
  } catch (error) {
    console.error(error);
    res.status(500).sendStatus({
      error: `An error occurred while processing your request: ${error}`,
    });
  }
});

app.get("/generate-account", async (req, res) => {
  try {
    const web3 = createAlchemyWeb3(process.env.ALCHEMY_RPC_URL);
    const { privateKey, address } = web3.eth.accounts.create();
    res.json({ address });
  } catch (error) {
    console.error(error);
    res.status(500).send("Error generating account");
  }
});

app.post("/broadcast-transaction", async (req, res) => {
  try {
    const { transaction } = req.body;

    const response = await axios.post("some-rpc-url", {
      jsonrpc: "2.0",
      method: "eth_sendRawTransaction",
      params: [transaction],
      id: 1,
    });

    // Return the transaction hash
    res.json({
      transactionHash: response.data.result,
      status: "Transaction broadcasted successfully",
    });
  } catch (error) {
    console.error(error);
    res.status(500).send("Error broadcasting transaction");
  }
});

app.listen(port, () => {
  console.log(`listening on ${port}`);
});
