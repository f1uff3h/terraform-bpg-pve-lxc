#!/bin/bash

source ./.init

echo "[INFO] -- Login to ${containerRegistry}"
podman login "${containerRegistry}"
podman container run --rm -it \
  -v go-nu:/root/.config/nushell \
  -v go-nv:/root/.local/share/nvim \
  -v persist-z:/root/.local/share/zoxide \
  -v "${HOME}"/repos/.init/:/init \
  -v "${HOME}"/.ssh/:/root/.ssh:ro \
  -v "${HOME}"/.gitconfig:/root/.gitconfig:ro \
  -v ./:/workspace \
  "${containerRegistry}/${containerImage}" nu
