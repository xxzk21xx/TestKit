FROM python:3.9

# Update and install necessary packages
RUN apt-get update && apt-get install -y unixodbc unixodbc-dev gpg wget

# Add Microsoft repository key and repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update

# Download and install Microsoft ODBC Driver 13 for SQL Server
RUN wget https://download.microsoft.com/download/4/9/5/4956849c-f4f7-4c2c-8c01-4c2f946a6d17/msodbcsql_13.1.9.2-1_amd64.deb \
    && ACCEPT_EULA=Y dpkg -i msodbcsql_13.1.9.2-1_amd64.deb \
    && rm msodbcsql_13.1.9.2-1_amd64.deb

WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080
ENV NAME World
CMD ["python", "app.py"]
