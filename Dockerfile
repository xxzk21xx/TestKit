FROM python:3.9

# Update and install necessary packages
RUN apt-get update && apt-get install -y unixodbc unixodbc-dev gpg wget

# Add Microsoft repository key and repository for Ubuntu 16.04
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install ODBC Driver 13 for SQL Server
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql13 mssql-tools

# Optional: Install the unixODBC development headers
RUN apt-get install -y unixodbc-dev

WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080
ENV NAME World
CMD ["python", "app.py"]
