FROM jupyter/minimal-notebook

USER root
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    git \
    cmake \
    libgmp-dev \
    libmpfr-dev \
    libgmpxx4ldbl \
    libboost-dev \
    libcgal-dev \
    libboost-thread-dev \
    swig && \
    apt-get clean
RUN pip install --no-cache numpy scipy
RUN LDFLAGS=-fno-lto pip install --no-cache pymesh2
RUN pip install --no-cache notebook pythreejs

RUN cd /tmp \
  && git clone https://github.com/AnIrishDuck/petrify.git \
  && cd petrify \
  && pip install -r requirements.txt \
  && python setup.py install

ARG NB_USER=notebook
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN mkdir -p ${HOME}/examples \
    && cp /tmp/petrify/examples/*.ipynb ${HOME}/examples \
    && cp /tmp/petrify/examples/*.svg ${HOME}/examples \
    && cp /tmp/petrify/examples/*.stl ${HOME}/examples
RUN chown -R ${NB_USER} ${HOME}
WORKDIR ${HOME}
USER ${NB_USER}
