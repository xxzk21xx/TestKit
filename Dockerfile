FROM python:3.9

# Install unixODBC and the required Microsoft ODBC 18 Driver for SQL Server
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg \
    unixodbc \
    unixodbc-dev \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get install -y netcat

EXPOSE 8080
CMD ["python", "app.py"]
