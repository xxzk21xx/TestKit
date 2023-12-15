FROM python:3.7-stretch

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    unixodbc \
    unixodbc-dev \
    gpg \
    wget \
    libc6 \
    libstdc++6 \
    libkrb5-3 \
    libcurl3 \
    openssl \
    debconf

# Add Microsoft repository key and repository for Ubuntu 16.04
# This is not needed if you are manually installing the driver
# But it is left here in case you are installing other packages from this repo
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Copy the .deb file from your build context into the image
COPY msodbcsql_13.1.9.2-1_amd64.deb /tmp/msodbcsql_13.1.9.2-1_amd64.deb

# Install the .deb package
RUN ACCEPT_EULA=Y dpkg -i /tmp/msodbcsql_13.1.9.2-1_amd64.deb || apt-get install -f

WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080
ENV NAME World
CMD ["python", "app.py"]
