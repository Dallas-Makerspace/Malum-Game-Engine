FROM mattiascibien/godot-docker:latest
ARG PLATFORM="Windows Desktop"
ENV TARGET $PLATFORM
COPY . /src
RUN godot -export "${TARGET}" /src
