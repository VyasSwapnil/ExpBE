# Use the official Node.js image as the base
FROM node:18-bullseye-slim

# Install OpenJDK (Java) which is required for Liquibase to run
RUN apt-get update && \
    apt-get install -y default-jre-headless && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port your Express app runs on
EXPOSE 3000

# Run Liquibase update using environment variables, then start the Express server
CMD npx liquibase update --url="${LIQUIBASE_URL}" --username="${LIQUIBASE_USERNAME}" --password="${LIQUIBASE_PASSWORD}" --changelog-file=db/changelog/db.changelog-master.xml && npm start