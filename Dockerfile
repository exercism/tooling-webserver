FROM nimlang/nim

RUN apt-get install -y musl-dev musl-tools

WORKDIR /opt/local-tooling-webserver

# Install the dependencies
COPY exercism_local_tooling_webserver.nimble .
RUN nimble install -d -Y

# Build the application
COPY . .
RUN nimble build --passL='-static' --gcc.exe=musl-gcc --gcc.linkerexe=musl-gcc 
