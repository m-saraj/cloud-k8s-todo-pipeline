# ---------- Stage 1: Build Base ----------
FROM python:3.12-slim AS builder

# Set working directory
WORKDIR /app

# Install pip dependencies
COPY app/requirements.txt .
RUN pip install --upgrade pip && \
    pip install --user -r requirements.txt

# ---------- Stage 2: Final Runtime ----------
FROM python:3.12-slim

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /root/.local /root/.local

# Update PATH
ENV PATH=/root/.local/bin:$PATH

# Copy app code
COPY app/ .

# Expose port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
