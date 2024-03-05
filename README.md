# Flask-Redis Application Documentation

## Overview

This guide covers the setup, deployment, and testing of a simple Flask application that interacts with Redis for storing and retrieving data. The application provides two endpoints: one for setting a value associated with a key in Redis, and another for getting the value of a given key from Redis.

### Prerequisites

Before you start, ensure you have the following installed on your machine:

- Docker
- Docker Compose
- `curl` (for testing)

### Application Structure

- `app.py`: The Flask application.
- `Dockerfile`: Instructions for Docker to build the application's image.
- `docker-compose.yml`: Configuration to run both the Flask application and Redis service locally.

### Setup Instructions

1. **Clone the Repository**

   Clone the repository to your local machine and navigate into the project directory.

2. **Build and Run with Docker Compose**

   Run the following command to build the Flask application image and start the services defined in `docker-compose.yml`:

   ```bash
   docker-compose up --build
   ```

   This command starts the Flask application and Redis service. The application will be accessible on `http://localhost:5000`.

### Testing the Application

You can test the application using `curl` to ensure that the set and get functionalities are working as expected.

1. **Setting a Value in Redis**

   To set a key-value pair in Redis, replace `<key>` with your desired key and `<value>` with the value you want to store:

   ```bash
   curl -X POST -d "<value>" http://localhost:5000/set/<key>
   ```

   Example:

   ```bash
   curl -X POST -d "hello World" http://localhost:5000/set/1
   ```

   This command sets the value "hello World" for the key "1".

2. **Getting a Value from Redis**

   To retrieve a value for a given key from Redis, use the following command:

   ```bash
   curl http://localhost:5000/get/<key>
   ```

   Example:

   ```bash
   curl http://localhost:5000/get/1
   ```

   This command gets the value for the key "1", which should return "hello World" if the previous set operation was successful.

### Troubleshooting

- **Application Cannot Connect to Redis**: Ensure that the `REDIS_HOST` environment variable in `docker-compose.yml` is correctly set to the service name of Redis (`redis`).
- **Data Not Persisting**: Remember that data stored in Redis through this setup is not persistent and will be lost when the Docker containers are stopped. To persist data, configure Redis with a volume in `docker-compose.yml`.

## Conclusion

This documentation provides a basic overview of deploying and testing a simple Flask-Redis application with Docker and Docker Compose. For more complex scenarios or production deployments, consider additional configurations for security, data persistence, and performance optimization.
