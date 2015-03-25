FROM ubuntu:14.04
MAINTAINER cliff xuan

RUN apt-get update

# install basic tools
RUN apt-get install -y build-essential vim git tmux zsh patch silversearcher-ag curl

# install python
RUN apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

RUN cd /tmp; curl -O https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz; tar -xf Python-2.7.9.tgz
RUN cd /tmp/Python-2.7.9; ./configure; make; make install


# install pip, virtualenv, virtualenvwrapper
RUN cd /tmp; curl -O https://bootstrap.pypa.io/get-pip.py; python /tmp/get-pip.py; pip install virtualenv virtualenvwrapper

# user cliff
RUN useradd cliff -s /bin/zsh -G sudo --home /home/cliff
RUN mkdir /home/cliff
RUN chown cliff:cliff /home/cliff
RUN echo "cliff ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


# switch user
USER cliff

# ssh
WORKDIR /home/cliff
RUN mkdir -p .ssh
ADD id_rsa .ssh/id_rsa
RUN sudo chown cliff:cliff .ssh/id_rsa
RUN echo "Host github.com\\n\\tStrictHostKeyChecking no" >> .ssh/config

# dotfiles
RUN mkdir -p bin
RUN mkdir -p dev
RUN git clone git@github.com:cliffxuan/dotfiles dev/dotfiles
RUN dev/dotfiles/kickoff.sh

CMD ["/bin/zsh"]