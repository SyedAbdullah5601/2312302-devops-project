FROM python:3.12-slim

# Set working directory
WORKDIR /workspace

# Install system dependencies if required by your app dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files first to exploit Docker layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create a non-root user and assign permissions
RUN useradd -m devopsuser && chown -R devopsuser:devopsuser /workspace
USER devopsuser

# Copy application code
COPY --chown=devopsuser:devopsuser app/ ./app/

# Expose FastAPI's default port
EXPOSE 8000

# Start application pointing to app.main:app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
