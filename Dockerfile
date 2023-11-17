FROM ubuntu:mantic

RUN apt-get update
RUN apt-get install -y g++ cmake ssh libspdlog-dev git g++ cmake pkg-config libsystemd-dev libssl-dev openssl libgtest-dev
RUN \
    cd $(mktemp -d) && \
    WORK_PATH=$(pwd) && \
    git clone -c advice.detachedHead=false --recurse-submodules --depth 1 --shallow-submodules -b v1.51.1 https://github.com/grpc/grpc "${WORK_PATH}/grpc" && \
    cmake -S "${WORK_PATH}/grpc" -B "${WORK_PATH}/grpc/build-grpc-host" -DCMAKE_BUILD_TYPE=Release -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DgRPC_SSL_PROVIDER=package -DCMAKE_RULE_MESSAGES=OFF -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -w" -Wno-dev && \
    cmake --build "${WORK_PATH}/grpc/build-grpc-host" --parallel 8 && \
    cmake --install "${WORK_PATH}/grpc/build-grpc-host" && \
    rm -rf "${WORK_PATH}/grpc"
RUN apt-get install -y fish neovim nano
RUN useradd -ms /usr/bin/fish john

USER john
WORKDIR /home/john