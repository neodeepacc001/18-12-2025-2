FROM python:3.10-slim

# 1. INSTALL ALL SYSTEM DEPENDENCIES FIRST
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    procps \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    libxshmfence1 \
    libxss1 \
    libxtst6 \
    lsb-release \
    --no-install-recommends

# 2. ADD CHROME REPOSITORY USING THE MODERN METHOD
RUN wget -q -O /usr/share/keyrings/google-chrome.gpg https://dl.google.com/linux/linux_signing_key.pub \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb stable main" > /etc/apt/sources.list.d/google-chrome.list

# 3. UPDATE APT AND INSTALL CHROME
RUN apt-get update \
    && apt-get install -y google-chrome-stable --no-install-recommends

# 4. INSTALL PLAYWRIGHT DEPENDENCIES
RUN apt-get install -y \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2

# 5. CLEAN UP APT CACHE TO REDUCE IMAGE SIZE
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# [REST OF THE FILE REMAINS UNCHANGED FROM YOUR ORIGINAL]
# Create working directory
WORKDIR /home/jovyan

# Copy requirements
COPY requirements.txt /tmp/requirements.txt

# Install Python packages
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Install Playwright browsers
RUN playwright install chromium

# Set up Jupyter environment
ENV JUPYTER_ENABLE_LAB=yes
ENV SHELL=/bin/bash

# Add user
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER=${NB_USER} \
    NB_UID=${NB_UID} \
    HOME=/home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

WORKDIR ${HOME}

CMD ["start-notebook.sh"]
