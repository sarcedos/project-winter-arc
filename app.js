require('dotenv').config()

const express = require('express');

const app = express()
const port = 8008; 

app.get('/', (req, res) => {
    res.send('hello world');
});

app.listen(port, () => {
    console.log(`Winter Arc is Go on ${port}`);
});
