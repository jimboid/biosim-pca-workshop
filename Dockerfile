# Start with BioSim base image.
ARG BASE_IMAGE=hub-5.2.1-2025-01-15
FROM harbor.stfc.ac.uk/biosimulation-cloud/biosim-jupyter-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

RUN conda install mdtraj matplotlib numpy -y
RUN conda install ipywidgets -c conda-forge -y
RUN conda install nglview

# Python Dependencies for the md_workshop
RUN pip3 install mdplus
RUN pip3 install jupyterhub-tmpauthenticator

# Copy lab workspace
COPY --chown=1000:100 default-37a8.jupyterlab-workspace /home/jovyan/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace

# Get workshop files and move them to jovyan directory.
RUN git clone https://github.com/CCPBioSim/pca-workshop.git && \
    mv pca-workshop/* . && \
    mv pca-workshop/.PCA_analysis_of_MD_simulations-1.ipynb . && \
    mv pca-workshop/.PCA_analysis_of_MD_simulations-2.ipynb . && \
    mv utilities.py /opt/conda/lib/python3.10/site-packages/utilities.py && \
    rm -r AUTHORS LICENSE README.md pca-workshop

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER
