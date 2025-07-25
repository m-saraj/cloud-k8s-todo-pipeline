# ======== STAGE 1: Build base =========
FROM python:3.12-slim as base

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install dependencies
COPY app/requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# ======== STAGE 2: Copy app and run =========
FROM base as final

WORKDIR /app

# Copy application code
COPY app/ .

# Expose port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
