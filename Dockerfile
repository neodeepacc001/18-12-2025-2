# Use the official browser-use Docker image as the foundation.
FROM browseruse/browseruse:latest

# 0. EXPLICITLY SWITCH TO ROOT to gain permissions for system commands.
USER root

# 1. Install system packages needed for Jupyter.
RUN apt-get update && apt-get install -y \
    procps \
    fonts-liberation \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Create a non-root user (standard for Binder/Jupyter).
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER=${NB_USER} \
    NB_UID=${NB_UID} \
    HOME=/home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# 3. Set up the Jupyter environment.
ENV JUPYTER_ENABLE_LAB=yes
ENV SHELL=/bin/bash

# 4. Switch to the user's home directory and copy your project files.
WORKDIR ${HOME}
USER ${NB_USER}
COPY --chown=${NB_USER}:${NB_USER} . ${HOME}

# 5. Install your Python packages from requirements.txt.
# The browser-use and Playwright are already installed in the base image.
RUN pip install --no-cache-dir -r requirements.txt

# 6. Default command to start Jupyter Lab for Binder.
CMD ["start-notebook.sh"]
