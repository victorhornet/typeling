FROM ubuntu:22.04
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt update


# Packages needed to run on fedora, I keep them for future reference
# RUN ["dnf", "install", "-y", "neovim", "llvm14", "llvm14-devel", "llvm14-libs", "llvm14-static", "clang14-devel", "clang", "cmake", "libffi-devel", "make", "gcc-c++", "lld", "zlib-devel", "zstd", "llvm", "llvm-devel", "llvm-libs", "llvm-static", "lld-libs", "llvm-static"]


RUN ["apt", "install", "-y", "curl", "llvm-14-dev", "llvm-14-linker-tools", "clang-14", "llvm-14-tools", "gcc", "g++", "zlib1g-dev"]
WORKDIR /usr/src/app


RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-install.sh
RUN chmod +x rustup-install.sh
RUN ./rustup-install.sh -y
RUN source "/root/.cargo/env"
ENV PATH="/root/.cargo/bin:${PATH}"
COPY . ./
RUN ["cargo", "install", "--path", "."]

ENTRYPOINT ["typeling"]