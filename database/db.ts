import dotenv from 'dotenv';
import { Pool } from 'pg';

dotenv.config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    password: process.env.DB_PASSWORD || "moonball9",
    database: process.env.DB_NAME,
    port: parseInt(process.env.DB_PORT || '5432', 10)
});

pool.on('connect', () =>{
    console.log("We're struggling in the DATABASE! DATABASE!")
});

pool.on('error', (err) => {
    console.error("Mission Failed! We'll get em next time.", err);
    process.exit(-1);
});

export default pool;