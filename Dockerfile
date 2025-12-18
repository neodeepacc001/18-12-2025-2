# Use the official browser-use Docker image as the foundation.
# It contains Chrome, Playwright, and browser-use pre-installed.
FROM browseruse/browseruse:latest

# Install system packages needed for Jupyter and general utilities.
RUN apt-get update && apt-get install -y \
    procps \
    fonts-liberation \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up the Jupyter environment.
ENV JUPYTER_ENABLE_LAB=yes
ENV SHELL=/bin/bash

# Create a non-root user (standard practice for Binder/Jupyter).
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER=${NB_USER} \
    NB_UID=${NB_UID} \
    HOME=/home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Switch to the user's home directory and copy your project files.
WORKDIR ${HOME}
USER ${NB_USER}
COPY . ${HOME}

# Install your Python packages from requirements.txt.
# The browser-use and Playwright are already installed in the base image.
RUN pip install --no-cache-dir -r requirements.txt

# Default command to start Jupyter Lab for Binder.
CMD ["start-notebook.sh"]
