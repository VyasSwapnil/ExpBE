# Use the official Node.js image as the base
FROM node:18-bullseye-slim

# Install OpenJDK (Java) which is required for Liquibase to run
RUN apt-get update && \
    apt-get install -y default-jre-headless && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all project files into /app
COPY . .

# Expose port 3000
EXPOSE 3000

# Run Liquibase update with the correct folder path, then start Express
CMD npx liquibase --search-path=. update \
    --changelog-file=liquibase/db.changelog-master.xml \
    --url="${LIQUIBASE_URL}" \
    --username="${LIQUIBASE_USERNAME}" \
    --password="${LIQUIBASE_PASSWORD}" && \
    npm start