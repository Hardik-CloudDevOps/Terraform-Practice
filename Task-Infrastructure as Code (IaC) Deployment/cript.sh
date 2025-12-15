#!/bin/bash
# Redirect logs so you can debug if needed
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# 1. Update and Install Tools
yum update -y
yum install -y git

# 2. Add Swap Memory (Prevents t2.micro crashes)
dd if=/dev/zero of=/swapfile bs=128M count=16
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

# 3. Install Node.js 18
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# 4. Create Project Directory
mkdir -p /var/www/fullstack
cd /var/www/fullstack

# 5. Initialize & Install Dependencies
npm init -y
npm install express mysql2 cors dotenv
npm install --save-dev nodemon

# 6. Create Backend (server.js)
# We use 'EOF' so Shell ignores the backticks in SQL
cat <<'EOF' > server.js
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const path = require('path');
const app = express();

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Database Connection
const db = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Init Table
db.query(`CREATE TABLE IF NOT EXISTS todos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  task VARCHAR(255),
  completed BOOLEAN DEFAULT false
)`, (err) => {
  if (err) console.error(err);
  else console.log("Table created/verified");
});

// API Routes
app.get('/api/todos', (req, res) => {
  db.query('SELECT * FROM todos', (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});

app.post('/api/todos', (req, res) => {
  const { task } = req.body;
  db.query('INSERT INTO todos (task) VALUES (?)', [task], (err, result) => {
    if (err) return res.status(500).json(err);
    res.json({ id: result.insertId, task, completed: 0 });
  });
});

// Serve Frontend
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(80, () => {
  console.log('Server running on port 80');
});
EOF

# 7. Create Frontend (index.html)
mkdir public
# IMPORTANT: We use $${t.task} here so Terraform ignores it
cat <<'EOF' > public/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Full Stack App</title>
    <style>
        body { font-family: sans-serif; max-width: 600px; margin: 2rem auto; padding: 0 1rem; }
        .input-group { display: flex; gap: 10px; margin-bottom: 20px; }
        input { flex: 1; padding: 10px; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; cursor: pointer; }
        ul { list-style: none; padding: 0; }
        li { background: #f4f4f4; padding: 10px; margin-bottom: 5px; display: flex; justify-content: space-between; }
    </style>
</head>
<body>
    <h1>🚀 My AWS Full Stack Project</h1>
    <div class="input-group">
        <input type="text" id="taskInput" placeholder="Add a new task...">
        <button onclick="addTask()">Add</button>
    </div>
    <ul id="taskList"></ul>

    <script>
        const API_URL = '/api/todos';

        async function loadTasks() {
            const res = await fetch(API_URL);
            const tasks = await res.json();
            const list = document.getElementById('taskList');
            // FIX: Double $$ tells Terraform to treat this as literal text
            list.innerHTML = tasks.map(t => `<li>$${t.task}</li>`).join('');
        }

        async function addTask() {
            const input = document.getElementById('taskInput');
            if (!input.value) return;
            await fetch(API_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ task: input.value })
            });
            input.value = '';
            loadTasks();
        }

        loadTasks();
    </script>
</body>
</html>
EOF

# 8. Create Service
# We use standard EOF here (no quotes) because we WANT Terraform to inject the DB variables
cat <<EOF > /etc/systemd/system/nodeapp.service
[Unit]
Description=Node.js Full Stack App
After=network.target

[Service]
ExecStart=/usr/bin/node /var/www/fullstack/server.js
Restart=always
User=root
Environment=DB_HOST=${db_endpoint}
Environment=DB_USER=${db_user}
Environment=DB_PASSWORD=${db_pass}
Environment=DB_NAME=${db_name}

[Install]
WantedBy=multi-user.target
EOF

# 9. Start App
systemctl daemon-reload
systemctl enable nodeapp
systemctl start nodeapp