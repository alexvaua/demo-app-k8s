FROM python:3-slim

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir flask redis

EXPOSE 5000

ENV REDIS_HOST=redis

CMD ["python", "./app.py"]
