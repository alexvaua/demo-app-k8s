# Charts deployment script to k8s for the Flask-Redis Application

 This script illustrates a workflow that includes building, deploying, testing, and cleaning up an application, specifically tailored for a Flask application with a Redis dependency managed by Helm in Kubernetes.

## Script Overview

This script automates several key steps in the workflow of deploying an application to Kubernetes:

1. **Building** and testing the Docker image locally.
2. **Publishing** the Docker image to a registry.
3. **Deploying** the application using Helm to a Kubernetes cluster.
4. **Monitoring** the readiness of the Redis pod.
5. **Testing** the application's functionality after deployment.
6. **Cleaning up** resources after testing to maintain a clean environment.

### Functions Breakdown

#### `publish()`

- Logs into Docker.
- Tags the locally built Docker image with a predefined tag.
- Pushes the image to a Docker registry.

#### `deploy()`

- Updates Helm dependencies to ensure all chart dependencies are downloaded.
- Creates a dedicated namespace for the application deployment in Kubernetes.
- Deploys the application using Helm into the specified namespace.

#### `check()`

- Retrieves all resources in the application namespace to verify deployment.
- Forwards a local port to the deployed service's port to allow local access.
- Tests the application's functionality by setting and getting a value via `curl`.

#### `clean()`

- Deletes the Helm release, effectively removing deployed resources.
- Deletes the Kubernetes namespace used for the deployment.
- Cleans up local port forwarding setups and removes Helm chart dependencies and lock files.

#### `build()`

- Uses Docker Compose to build and run the application container locally.
- Tests the application's core functionality locally by setting and getting a value.
- If the local test passes, proceeds to publish the Docker image.
- Tears down the local Docker Compose setup.

#### `run()`

- Watches for the Redis pod to become ready by checking its `Ready` status condition.
- Once the Redis pod is ready, proceeds to run the `check` function to test the application's endpoints.
- Cleans up resources after testing by calling the `clean` function.

### How to Use This Script

1. **Prerequisites**:
   - Docker and Docker Compose installed.
   - Helm and kubectl configured with access to your Kubernetes cluster.
   - Access to a Docker registry where images can be published.

2. **Configuration**:
   - Set the `IMG` variable to your Docker image name and tag.
   - Modify the `APP` variable if you prefer a different application name.
   - Ensure your Helm chart and Kubernetes resources are correctly configured in the `${APP}` directory.

3. **Running the Script**:
   - Make sure that you are in a same directory with the`setup.sh`(root dir of the cloned repo)
   - Run the script: `./<script_name>.sh`
   - The script will automatically build, deploy, test, and clean up the application.

### Important Considerations

- **Helm Chart Dependencies**: This script assumes your Helm chart has dependencies, such as a Redis chart. Ensure these are correctly defined in your `Chart.yaml` and `values.yaml`.
- **For the testing only**: The script includes a cleanup step that deletes resources after testing.

This documentation provides an overview and detailed explanation of each step in the script, offering a comprehensive guide for automating the deployment and testing of containerized applications in Kubernetes.
