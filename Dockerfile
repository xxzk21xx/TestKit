FROM python:3.9

# Update and install necessary packages
RUN apt-get update && apt-get install -y unixodbc unixodbc-dev gpg wget

# Add Microsoft repository key and repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update

# Install necessary libraries for Microsoft ODBC Driver 18
RUN apt-get install -y apt-transport-https

# Add Microsoft's SQL Server repository
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install ODBC Driver 18 for SQL Server
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18

WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080
ENV NAME World
CMD ["python", "app.py"]
