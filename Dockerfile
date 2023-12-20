FROM python:3.9

# Set environment variables to non-interactive (this prevents some prompts)
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Copy only the requirements file first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt

# Install dependencies as root before switching to myuser
# First, install dependencies required for the rest of the build
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends gnupg curl \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update -y \
    && ACCEPT_EULA=Y apt-get install -y unixodbc unixodbc-dev msodbcsql17 telnet \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Now install the Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Add a user for running the application, switch to it
RUN useradd -m myuser
USER myuser

# Specify the port on which the container should listen
EXPOSE 8080

# Run the application
CMD ["python", "app.py"]
