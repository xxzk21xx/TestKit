# Use Python 3.9 image from Docker Hub as the base image
FROM python:3.9

# Update the package list and install unixODBC and unixODBC development libraries
RUN apt-get update && apt-get install -y \
    unixodbc \
    unixodbc-dev \
    gnupg2 \
    curl \
    netcat-openbsd

# Set the working directory inside the container to /app
WORKDIR /app

# Copy the local directory contents to the /app directory inside the container
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
