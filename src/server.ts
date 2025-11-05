import express from 'express';
import dotenv from 'dotenv';
import pool from '../database/db.js';

dotenv.config()
const app = express()
const port = process.env.PORT || 8008; 
app.use(express.json());

app.get('/', (req, res) => {
    res.send('hello world');
});

app.get('/dbhealth', async (req, res) => {
    try {
        const result = await pool.query('SELECT NOW()');
        res.json({
            success: true,
            timestamp: result.rows[0].now
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error instanceof Error ? error.message: 'Unknown Error'
        });
    }
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(port, () => {
    console.log(`Winter Arc is Go on ${port}`);
});
