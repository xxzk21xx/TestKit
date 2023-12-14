FROM python:3.9

RUN apt-get update && apt-get install -y unixodbc unixodbc-dev
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17=17.2.0.1-1

WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8080
ENV NAME World
CMD ["python", "app.py"]
