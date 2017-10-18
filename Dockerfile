FROM node:8

# Install ffmpeg & clvc to perform the transcoding.
RUN apt-get update && apt-get install -y debian-keyring && \
    gpg --keyserver pgpkeys.mit.edu --recv-key  5C808C2B65558117 && \
    gpg -a --export 5C808C2B65558117 | apt-key add - && \
    echo "deb http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
    deb-multimedia-keyring \
    ffmpeg \
    vlc \
 && rm -rf /var/lib/apt/lists/*

# Run to be able to start cvlc as root
RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc
RUN yarn global add pm2


WORKDIR /app

CMD ["pm2-docker", "index.js"]
