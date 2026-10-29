FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario ansible con password ansible
RUN useradd -m -s /bin/bash ansible \
    && echo "ansible:ansible" | chpasswd

# Sudo sin password
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible \
    && chmod 0440 /etc/sudoers.d/ansible

# Configurar SSH
RUN mkdir -p /var/run/sshd \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]