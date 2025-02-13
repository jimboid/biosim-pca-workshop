# Start with BioSim base image.
ARG BASE_IMAGE=latest
FROM ghcr.io/jimboid/biosim-jupyter-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"
LABEL org.opencontainers.image.source=https://github.com/jimboid/biosim-pca-workshop
LABEL org.opencontainers.image.description="A repository containing the build steps for the ccpbiosim workshop on PCA."
LABEL org.opencontainers.image.licenses=MIT

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

# Install workshop deps
RUN conda install mdtraj matplotlib numpy -y
RUN conda install ipywidgets -c conda-forge -y
RUN conda install nglview
RUN pip install mdplus

# Copy lab workspace
COPY --chown=1000:100 default-37a8.jupyterlab-workspace /home/jovyan/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace

# Get workshop files and move them to jovyan directory.
RUN git clone https://github.com/CCPBioSim/pca-workshop.git && \
    mv pca-workshop/* . && \
    mv utilities.py /opt/conda/lib/python3.12/site-packages/utilities.py && \
    rm -r AUTHORS LICENSE README.md pca-workshop

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER
