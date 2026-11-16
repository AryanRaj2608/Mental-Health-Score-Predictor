FROM python:3.12-slim

# Create non-root user (Hugging Face Spaces requirement)
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

WORKDIR $HOME/app

# Install dependencies
COPY --chown=user requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Copy application files
COPY --chown=user . .

# Expose Hugging Face default port
EXPOSE 7860

# Run Uvicorn with fallback to port 7860
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-7860}"]
