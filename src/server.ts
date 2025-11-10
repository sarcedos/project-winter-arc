import express from 'express';
import dotenv from 'dotenv';
import pool from '../database/db.js';
import bcrypt from "bcrypt";

dotenv.config()
const app = express()
const port = process.env.PORT || 8008; 
app.use(express.json());

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

app.get('/api/pullusers', async (req, res) => {
  try {
    const results = await pool.query('SELECT * FROM goaltracker.users');
    res.status(200).json(results.rows);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Failed to fetch users' });
  }
});

app.get('/api/getgoals', async (req,res) => {
    const { userid } = req.body
    try {
        if (!userid) {
            res.status(404).json({error: "User not found"})
        }

        const result = await pool.query(
            "SELECT id, userid, title, description, status FROM goaltracker.goals WHERE userid = $1",
            [userid]
        )
        if (result.rows.length === 0) {
            res.status(404).json({error: "No goals ere M'lord"})
        } else {
            res.status(200).json(result);
        }
    } catch {
        res.status(500).json({message: "No idea bruv, is busted"})
    }
});

app.get('/api/gettask', async (req, res) => {
    console.log("You discovered task getter!");
})

app.post('/api/adduser', async (req, res) => {
    
    try {
        const { email, username, password} = req.body;

        if (!email || !username || !password) {
            return res.status(400).json({ error: "Missing required fields"});
        }

        const password_hash = await bcrypt.hash(password, 10);

        const result = await pool.query(
            'INSERT INTO goaltracker.users(email, username, password_hash) VALUES ($1, $2, $3) RETURNING *',
            [email, username, password_hash]
            );
    
        const newUser = result.rows[0];
        delete newUser.password_hash;

        res.status(200).json(newUser);
    
    } catch (error) {
        console.error('Not letting this guy in cause:', error)
        res.status(500).json({ error: "no can do chief" });
    }
});

app.post('/api/addtask', async (req, res) =>{
    console.log("you've found add task!");
});

app.post('/api/addgoal', async (req, res) => {
    console.log("you've hit add goal!");
});

//pausing on this for now
app.post('/api/login', async (req, res) => {
    const {username, password} = req.body

    if (!username || !password) {
        return res.status(400).json({message: "you forgettin something?"})
    }

    try {
        const result = await pool.query(
            'SELECT id, email, username, password_hash FROM goaltracker.users WHERE username = $1',
            [username]
        )

        if (result.rows.length == 0) {
            return res.status(401).json({error: "invalid credentials"});
        }

        const user = result.rows[0];
        
        const isValid = await bcrypt.compare(password, user.password_hash);
        
        if (isValid) {
            delete user.password_hash;
            res.status(200).json({message: 'login successful', user:user});
        } else {
            res.status(401).json({error: 'not on the list"'})
        }             
    } catch {
        res.status(500).json({ answer: "login failure"});
    }
});

app.listen(port, () => {
    console.log(`Winter Arc is Go on ${port}`);
});
