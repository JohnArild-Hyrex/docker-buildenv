FROM ubuntu:mantic

RUN apt-get update
RUN apt-get install -y python3-full
RUN apt-get install -y g++ cmake ssh git g++
RUN apt-get install -y libprotobuf-dev protobuf-compiler-grpc libgrpc++-dev 
RUN apt-get install -y libgtest-dev libspdlog-dev
RUN apt-get install -y fish neovim nano sudo
RUN apt-get install -y kmod iproute2 can-utils
RUN apt-get install -y openssh-server

# Setup user
RUN useradd -rm -g root -G sudo -s /usr/bin/fish -p "$(openssl passwd -1 docker)" docker
RUN echo "docker ALL=(ALL:ALL) NOPASSWD: /etc/init.d/ssh" > /etc/sudoers.d/sshd
USER docker
WORKDIR /home/docker
RUN ssh-keygen -A

CMD ["sudo", "/etc/init.d/ssh", "start", "-D"]