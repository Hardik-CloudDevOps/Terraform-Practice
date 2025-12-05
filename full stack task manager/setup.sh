#!/bin/bash
# Save this as setup.sh and run: bash setup.sh

# Create structure
mkdir -p backend/{config,controllers,middleware,routes}
mkdir -p frontend/src/{components,pages,services,utils}

# Create starter files
echo '{"name":"task-manager-backend","version":"1.0.0","main":"server.js","scripts":{"start":"node server.js","dev":"nodemon server.js"},"dependencies":{"express":"^4.18.2","mysql2":"^3.6.5","dotenv":"^16.3.1","cors":"^2.8.5","bcryptjs":"^2.4.3","jsonwebtoken":"^9.0.2"},"devDependencies":{"nodemon":"^3.0.2"}}' > backend/package.json

echo "PORT=5000
DB_HOST=localhost  
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=task_manager
JWT_SECRET=your_secret" > backend/.env.example

# Add more files here...
echo "✅ Basic structure created! Add remaining files from artifacts."