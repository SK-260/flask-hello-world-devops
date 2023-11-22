FROM python:3-alpine as test

WORKDIR /app

# Copy the source code into the container.
COPY  requirements.txt .

RUN pip install -r requirements.txt --target /packages

COPY app.py test.py .

FROM gcr.io/distroless/python3-debian12
COPY --from=test /app /app
COPY --from=test /packages /packages

ENV PYTHONPATH=/packages

# Expose the port that the application listens on.
EXPOSE 5000

# Run the application.
CMD [ "/app/app.py" ]
