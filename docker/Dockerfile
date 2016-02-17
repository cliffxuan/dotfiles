FROM ubuntu:14.04
MAINTAINER cliff xuan

# install git
RUN apt-get -y install git

# do ssh in case it fails, fails early
WORKDIR /root
RUN mkdir -p .ssh
ADD id_rsa /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa
RUN echo "Host github.com\\n\\tStrictHostKeyChecking no" >> .ssh/config

RUN apt-get update

# dotfiles
RUN mkdir -p bin
RUN mkdir -p dev
RUN git clone git@github.com:cliffxuan/dotfiles dev/dotfiles

# install basic tools
RUN apt-get install -y build-essential tmux zsh patch silversearcher-ag curl

# install python
RUN apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

# install lxml deps
RUN apt-get install -y libxml2-dev libxslt-dev

# install openssl deps
RUN apt-get install -y libssl-dev libffi-dev

# install python 2.7.11
RUN cd /tmp; curl -O https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz; tar -xf Python-2.7.11.tgz
RUN cd /tmp/Python-2.7.11; ./configure; make; make install

# install python 3.5.1
RUN cd /tmp; curl -O https://www.python.org/ftp/python/3.5.1/Python-3.5.1.tgz; tar -xf Python-3.5.1.tgz
RUN cd /tmp/Python-3.5.1; ./configure; make; make install

# install vim
RUN cd /tmp; curl -O ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2; tar -xjf vim-7.4.tar.bz2
RUN cd /tmp/vim74;./configure --enable-pythoninterp --enable-multibyte --disable-nls --with-python-config-dir=/usr/local/lib/python2.7/config; make; make install

# install pip, virtualenv, virtualenvwrapper, ipython ptpython
RUN cd /tmp; curl -O https://bootstrap.pypa.io/get-pip.py; python /tmp/get-pip.py; pip install virtualenv virtualenvwrapper ipython ptpython ipdb flake8
RUN /bin/zsh -c "source /usr/local/bin/virtualenvwrapper.sh"
RUN mkdir /root/.ptpython
RUN pip3 install ipython ptpython ipdb flake8

# install ghc, cabal
RUN apt-get install -y ghc cabal-install

# Set the locale
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
