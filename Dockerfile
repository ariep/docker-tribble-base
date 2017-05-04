FROM debian:jessie
MAINTAINER Arie Peterson <ariep@xs4all.nl>

# Install app-specific requirements.
RUN apt-get update -y &&\
    apt-get install -y texlive-xetex libicu-dev
# Necessary for ghc and ghcjs.
RUN apt-get install -y libncurses5-dev happy alex nodejs nodejs-legacy

# Install stack.
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 575159689BEFB442
RUN echo 'deb http://download.fpcomplete.com/debian jessie main' | tee /etc/apt/sources.list.d/fpco.list
RUN apt-get update && apt-get install stack -y

# Add user ph.
RUN groupadd -g 9000 ph &&\
    useradd -mg 9000 ph &&\
    chown ph:ph /home/ph

# Run the rest of the statements as user ph.
USER ph
ENV PATH /home/ph/.local/bin:$PATH

# Install stack-local ghc.
COPY ghc.stack.yaml /home/ph/
RUN stack setup --stack-yaml /home/ph/ghc.stack.yaml

# Install stack-local ghcjs.
COPY ghcjs.stack.yaml /home/ph/
RUN stack setup --stack-yaml /home/ph/ghcjs.stack.yaml

