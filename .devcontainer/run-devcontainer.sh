#!/bin/bash

source ./.init

podman container run --rm -it \
  -v tf-nu-hist:/root/.config/nushell \
  -v tf-nv:/root/.local/share/nvim \
  -v persist-z:/root/.local/share/zoxide \
  -v "${HOME}"/.cache/nvim/codeium:/root/.cache/nvim/codeium \
  -v "${HOME}"/repos/.init/:/init \
  -v "${HOME}"/.ssh/:/root/.ssh:ro \
  -v "${HOME}"/.gitconfig:/root/.gitconfig:ro \
  -v ./:/workspace \
  "${containerRegistry}/${containerImage}" nu
