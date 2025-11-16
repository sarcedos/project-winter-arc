import express from 'express';
import dotenv from 'dotenv';
import pool from '../database/db.js';
import bcrypt from "bcrypt";
import cron from 'node-cron';

dotenv.config()
const app = express()
const port = process.env.PORT || 8008; 
app.use(express.json());


//these are mostly testing, feel like they'll be obsolete eventually
app.get('api/dbhealth', async (req, res) => {
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

app.get('api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});


//USER MANAGEMENT APIs
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

app.post('/api/users/adduser', async (req, res) => {
    
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

app.get('/api/users/pullusers', async (req, res) => {
  try {
    const results = await pool.query('SELECT * FROM goaltracker.users');
    res.status(200).json(results.rows);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Failed to fetch users' });
  }
});

//GOAL INTERACT APIs
app.get('/api/goals/getgoals/:user_id', async (req,res) => {
    try {
        const { user_id } = req.params;

        if (!user_id) {    
            res.status(400).json({error: "Must provide a user ID"});
        }

        const result = await pool.query(
            "SELECT id, user_id, title, description, status FROM goaltracker.goals WHERE user_id = $1",
            [user_id]
        )
        if (result.rows.length === 0) {
            res.status(400).json({error: "No goals ere M'lord"})
        } else {
            const goals = result.rows;
            res.status(200).json(goals);
        }
    } catch {
        res.status(500).json({message: "No idea bruv, is busted"})
    }
});

app.post('/api/goals/addgoal', async (req, res) => {
    try {
        const { user_id, title, description} = req.body

        if (!user_id || !title || !description) {
            res.status(500).json({error: "Missing required fields"})
        }

        const result = await pool.query(
            "INSERT INTO goaltracker.goals (user_id, title, description) VALUES ($1 ,$2, $3) RETURNING *",
            [user_id, title, description]
        );

        const newGoal = result.rows[0];

        res.status(200).json(newGoal);

    } catch (error) {
        console.error('It appears the scribes were asleep:', error)
        res.status(500).json({ error: "caught the scribes napping"})
    }
});

app.get('/api/goals/getgoal/:goal_id', async (req, res) => {
    
    try {
    const { goal_id } = req.params;

    if (!goal_id) {
        res.status(400).json({message: "You must sepcify a goal"});
    }
    const result = await pool.query(
        "SELECT * FROM goaltracker.goals WHERE goal_id = $1 RETURNING *",
        [goal_id]
    );

    if (result.rows.length === 0) {
        res.status(400).json({message: "The Goal is empty"})
    }
    const goal = result.rows;
    res.status(200).json(goal);

    } catch {
        res.status(500).json({message: "Caught the scribes napping"});
    }
});



//TASK INTERACT APIs
app.get('/api/tasks/gettasks/:goal_id', async (req, res) => {
    try {
        const { goal_id } = req.params;
        
        if (!goal_id) {
            res.status(404).json({error: "Goal not found"})
        }

        const result = await pool.query(
        "SELECT id, title, description, due_date FROM goaltracker.tasks WHERE goal_id = $1",
        [goal_id]
        );

        if (result.rows.length === 0){
            res.status(404).json({error: "No tasks ere M'lord"})
        } else {
        res.status(200).json(result.rows)
        }

    } catch {
        res.status(500).json({message: "issue with request"});
    }
})

app.post('/api/tasks/addtask/', async (req, res) => {
    const { goal_id, title, description, due_date } = req.body;

    try {
        if (!goal_id || !title || !description || !due_date) {
            res.status(500).json({error: "missing required fields"})
        }

        const result = await pool.query(
            "INSERT INTO goaltracker.tasks (goal_id, title, description, due_date) VALUES ($1, $2, $3, $4) RETURNING *",
            [goal_id, title, description, due_date]
        )

        const newTask = result.rows[0];
        res.status(200).json(newTask);

    } catch (error) {
        console.error("Error has occured: ", error)
        res.status(500).json({ error: "Caught the scribes sleeeping" })
    }
});

//This was just a test ot make sure I was understanding how to build a thing, plz ignore.
app.get("/api/tasks/gettasks", async (req, res) => {
    try {
        const { switchOn } = req.query;
        let query = "";

        if (switchOn === 'on'){
            query = "SELECT * FROM goaltracker.goals"
        } else {
            query = "SELECT * FROM goaltracker.tasks"
        }

        const result = await pool.query(query);

        res.status(200).json(result)
    } catch (error) {
        console.error("It appears we have erred", error);
        res.status(500).json({message: "Looks like we fucked up."})
    }
});

app.put("/api/tasks/modify", async (req, res) => {
    console.log("not built yet")
})

//LISTENING POSTS
app.listen(port, () => {
    console.log(`Winter Arc is Go on ${port}`);
});

//CRON JOBS
cron.schedule('0 0 * * * *', async () =>{
    console.log('Running cron job test')
});