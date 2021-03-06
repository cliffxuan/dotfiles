FROM ubuntu:18.04
MAINTAINER cliff xuan

# do ssh in case it fails, fails early
WORKDIR /root
RUN mkdir -p .ssh
ADD id_rsa /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa
RUN echo "Host github.com\\n\\tStrictHostKeyChecking no" >> .ssh/config
RUN echo "Host gitlab.com\\n\\tStrictHostKeyChecking no" >> .ssh/config

RUN apt-get update

# install git
RUN apt-get -y install git

# dotfiles
RUN mkdir -p bin
RUN mkdir -p dev
RUN git clone git@github.com:cliffxuan/dotfiles dev/dotfiles

# install basic tools
RUN apt-get install -y sudo
RUN apt-get install -y build-essential zsh patch silversearcher-ag curl

# install python
RUN apt-get install -y python-dev python3-dev libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

# install lxml deps
RUN apt-get install -y libxml2-dev libxslt-dev

# install openssl deps
RUN apt-get install -y libssl-dev libffi-dev

# install python 2.7.11
RUN cd /tmp; curl -O https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz; tar -xf Python-2.7.11.tgz
RUN cd /tmp/Python-2.7.11; ./configure; make; make install

# install python 3.6.2
RUN cd /tmp; curl -O https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tgz; tar -xf Python-3.6.2.tgz
RUN cd /tmp/Python-3.6.2; ./configure; make; make install

# install vim
RUN cd /tmp; git clone https://github.com/vim/vim.git
RUN cd /tmp/vim; ./configure --enable-pythoninterp --enable-multibyte --disable-nls --with-python-config-dir=/usr/local/lib/python2.7/config; make; make install

# install pip, virtualenv, virtualenvwrapper, ipython ptpython
RUN cd /tmp; curl -O https://bootstrap.pypa.io/get-pip.py; python /tmp/get-pip.py; pip install virtualenv virtualenvwrapper ipython ptpython pdbpp flake8
RUN /bin/zsh -c "source /usr/local/bin/virtualenvwrapper.sh"
RUN mkdir /root/.ptpython
RUN pip3 install ipython ptpython ipdb

# tmux
RUN apt-get install -y automake libevent-dev libncurses5-dev
RUN git clone https://github.com/tmux/tmux.git /tmp/tmux
RUN cd /tmp/tmux; sh autogen.sh; ./configure; make; make install

# install ghc, cabal
RUN apt-get install -y ghc cabal-install

# install node, npm
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

# Set the locale
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN /root/dev/dotfiles/kickoff.sh

# user cliff
RUN useradd cliff -s /bin/zsh -G sudo --home /home/cliff
RUN mkdir /home/cliff
RUN chown cliff:cliff /home/cliff
RUN echo "cliff ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

CMD ["/bin/zsh"]
