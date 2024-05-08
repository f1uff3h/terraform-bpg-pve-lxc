FROM rust:latest as builder

RUN apt update && apt install -y cmake

RUN cargo install nu starship

FROM debian:12-slim

COPY --from=builder /usr/local/cargo/bin/nu /usr/local/cargo/bin/starship /usr/local/bin/

RUN mkdir -p /root/.config/nushell/ && \
  echo "mkdir ~/.cache/starship\nstarship init nu | save -f ~/.cache/starship/init.nu" > /root/.config/nushell/env.nu && \
  echo "use ~/.cache/starship/init.nu" > /root/.config/nushell/config.nu

RUN apt update && \
  apt upgrade -y

RUN apt install -y vim curl wget gpg git

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com bookworm main" | tee /etc/apt/sources.list.d/hashicorp.list && \
  apt update && \
  apt install -y terraform

ENTRYPOINT [ "/usr/local/bin/nu" ]