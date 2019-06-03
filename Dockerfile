FROM wentzell/docker_base:latest

RUN sudo pip install gdbgui

# Install relevant additional packages
RUN sudo apt-get update && \
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends \
	subversion \
	nodejs \
	npm \
	g++-6 \
	g++-7 \
	g++-8 \
	g++-9 \
	clang-6.0 \
	clang-7 && \
    sudo apt-get autoremove --purge -y && \
    sudo apt-get autoclean -y && \
    sudo rm -rf /var/cache/apt/* /var/lib/apt/lists/*

# Copy the Debugging Samples
ADD samples /home/docker/samples
RUN sudo chown -R docker /home/docker/samples

# Setup Compiler Explorer with various gcc and clang versions
RUN wget https://api.github.com/repos/mattgodbolt/compiler-explorer/tarball/master -O /tmp/compiler-explorer.tar.gz
RUN tar xzf /tmp/compiler-explorer.tar.gz --one-top-level --strip-components=1 && rm /tmp/compiler-explorer.tar.gz
RUN (cd compiler-explorer; make dist)
COPY c++.local.properties compiler-explorer/etc/config
RUN sudo chown docker compiler-explorer/etc/config/c++.local.properties

EXPOSE 5000 10240
CMD ["/usr/bin/zsh", "-l"]
#CMD ["cd compiler_explorer; make EXTRA_ARGS='--language c++'"]
#CMD ["gdbgui -r"]
