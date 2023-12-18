FROM python:3.9

# Update and install necessary packages
RUN apt-get update && apt-get install -y unixodbc unixodbc-dev \
    && apt-get install -y --no-install-recommends gnupg2 \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
    && apt-get install -y netcat-openbsd  # Install netcat

WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080
ENV NAME World
CMD ["python", "app.py"]
