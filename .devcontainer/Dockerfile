# Get arguments for python version (in this case, python 3.10 image is used)
ARG VARIANT="3.11-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

# linux settings
# `-y` option is used to automatically answer yes to all prompts
RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
    byobu \
    aria2 \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    build-essential \
    libgmp-dev \
    libmagick++-dev \
    libglpk-dev

# install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# update pip & install packages (including CWL tool)
# version update 2025-09-05
RUN pip install \
    --upgrade pip \
    jupyter==1.0.0 \
    retry==0.9.2 \
    ipykernel==6.30.1 \
    pandas==2.3.2 \
    pyarrow==21.0.0 \
    polars==1.33.0 \
    numpy==2.3.2 \
    matplotlib==3.10.6 \
    seaborn==0.13.2 \
    scipy==1.16.1 \
    statsmodels==0.14.5 \
    urllib3==2.5.0 \
    requests==2.32.5 \
    upsetplot==0.9.0 \
    papermill==2.6.0 \
    goatools==1.5.1 \
    langchain==0.3.27 \
    geofetch==0.12.8 \
    peppy==0.40.7 \
    PyYAML==6.0.2 \
    qrcode==8.2 \
    plotly==6.3.0 \
    cwltool==3.1.20250715140722 \
    cwltest==2.6.20250818005349 \
    cwl_runner==1.0 \
    pipx==1.7.1 \
    pytximport==0.12.0

RUN pip install langchain-core==0.3.56
RUN pip install langchain-community==0.3.22
RUN pip install google-genai==1.12.1
RUN pip install -q -U google-generativeai==0.8.5
RUN pip install -U langchain-google-genai==2.1.3
RUN pipx install benten==2021.1.5
RUN pip install text2term==4.5.0

# Jupyter Notebook settings
RUN python3 -m ipykernel install --user --name=python3
RUN jupyter notebook --generate-config