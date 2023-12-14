FROM python:3.9
RUN apt-get update && apt-get install -y unixodbc unixodbc-dev
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8080
ENV NAME World
CMD ["python", "app.py"]
