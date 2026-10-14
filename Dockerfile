# Container layout
#/workspace/
#├── edk2/
#│   └── ...
#│
#└── UefiLogInApp/
#    ├── compile_flags.txt      <-- Points to /workspace/edk2/...
#    └── ...

FROM ubuntu:26.04 AS builder
# Disabling interactive requests tzdata in installing process 
ENV DEBIAN_FRONTEND=noninteractive

# build-essential - default tooling & compilers
# gettext-base - for envsubst tool(generating compile_flags.txt)
# nasm, uuid-dev, python3 - for edk2
# ca-certificates for git clone
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    make \
    git \
    bash \
    gettext-base \
    nasm \
    python3 \
    uuid-dev \
    clang-22 \
    clang-tidy-22 \
    clang-format-22 \
    llvm-22-dev \
    libclang-22-dev \
    ca-certificates \
    gcc-16 \
    g++-16 \
    && rm -rf /var/lib/apt/lists/*
    
WORKDIR /workspace
RUN ln -sf /usr/bin/clang-22 /usr/bin/clang \
    && ln -sf /usr/bin/clang++-22 /usr/bin/clang++ \
    && ln -sf /usr/bin/clang-tidy-22 /usr/bin/clang-tidy \
    && ln -sf /usr/bin/clang-format-22 /usr/bin/clang-format \
    && ln -sf /usr/bin/gcc-16 /usr/bin/gcc \
    && ln -sf /usr/bin/gcc-16 /usr/bin/cc \
    && ln -sf /usr/bin/g++-16 /usr/bin/g++ \
    && ln -sf /usr/bin/g++-16 /usr/bin/c++
RUN git clone --depth 1 -b edk2-stable202608 https://github.com/tianocore/edk2.git \
    && cd edk2 \
    && git submodule update --init --recursive --depth 1 \
    && make -C BaseTools -j$(nproc)


ENV WORKSPACE_DIR_V=/workspace
WORKDIR /workspace/UefiLogInApp
CMD ["bash", "-c", "cp -r /host_code/. /workspace/UefiLogInApp && make deep-clean init hook-check"]