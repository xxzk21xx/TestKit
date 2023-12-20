FROM python:3.9

# Use a specific user to avoid using root
RUN useradd -m myuser
USER myuser

# Set environment variables to non-interactive (this prevents some prompts)
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Copy only the requirements file first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt

# Install dependencies in a single RUN layer to keep the image clean and small
RUN set -ex; \
    # Update the package list
    apt-get update; \
    # Install unixODBC, unixODBC-dev and telnet with no recommended extras
    apt-get install -y --no-install-recommends unixodbc unixodbc-dev telnet; \
    # Add Microsoft's repository
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list; \
    # Install specific Microsoft ODBC 17 Driver for SQL Server
    apt-get update; \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17; \
    # Clean up the apt cache to reduce image size
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    # Install Python dependencies
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . /app

# Specify the port on which the container should listen
EXPOSE 8080

# Run the application
CMD ["python", "app.py"]
