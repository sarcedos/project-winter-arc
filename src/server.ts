import express from 'express';
import dotenv from 'dotenv';

dotenv.config()
const app = express()
const port = process.env.PORT || 8008; 
app.use(express.json());

app.get('/', (req, res) => {
    res.send('hello world');
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(port, () => {
    console.log(`Winter Arc is Go on ${port}`);
});
