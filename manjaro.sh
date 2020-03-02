#!/bin/bash

data="/media/DATA"

echo -n "0. Add removable disk? [y/N]:"
read arg
case $arg in
    Y|y)
        echo "/dev/nvme0n1p3 ${data} ntfs defaults 0 0" | sudo tee -a /etc/fstab
    ;;
esac

echo -n "1. Switch new mirrors? [y/N]:"
read arg
case $arg in
    Y|y)
        sudo pacman-mirrors -c China
        echo -e "\n[archlinuxcn]\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch" | sudo tee -a /etc/pacman.conf
        sudo pacman -Syu --noconfirm archlinuxcn-keyring
    ;;
esac

echo -n "2. Install common pkg? [y/N]:"
read arg
case $arg in
    Y|y)
        sudo pacman -Syu --noconfirm \
            google-chrome \
            otf-fira-code \
            supervisor \
            net-tools \
            nodejs \
            cmake \
            code \
            npm
    ;;
esac

echo -n "3. Install sublime v3? [y/N]:"
read arg
case $arg in
    Y|y)
        wget https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
        echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
        sudo pacman -Syu --noconfirm sublime-text
    ;;
esac

echo -n "4. Install input pkgs? [y/N]:"
read arg
case $arg in
    Y|y)
        sudo pacman -Syu --noconfirm fcitx-im fcitx-configtool
        echo -e "QT_IM_MODULE=fcitx\nGTK_IM_MODULE=fcitx\nXMODIFIERS=@im=fcitx" >> ~/.pam_environment
    ;;
esac

echo -n "5. Install wps office? [y/N]:"
read arg
case $arg in
    Y|y)
        sudo pacman -Syu --noconfirm wps-office ttf-wps-fonts
    ;;
esac

echo -n "6. Install teamviewer? [y/N]:"
read arg
case $arg in
    Y|y)
        sudo pacman -Syu --noconfirm teamviewer
    ;;
esac

echo -n "7. Install mini conda? [y/N]:"
read arg
case $arg in
    Y|y)
        echo "channels:" >> ~/.condarc
        echo "  - defaults" >> ~/.condarc
        echo "always_copy: true" >> ~/.condarc
        echo "show_channel_urls: true" >> ~/.condarc
        echo "default_channels:" >> ~/.condarc
        echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main" >> ~/.condarc
        echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free" >> ~/.condarc
        echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r" >> ~/.condarc
        echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro" >> ~/.condarc
        echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2" >> ~/.condarc
        echo "custom_channels:" >> ~/.condarc
        echo "  fastai: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc
        echo "  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc
        echo "  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc
        echo "  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc

        mkdir -p ~/.config/pip
        echo "[global]" >> ~/.config/pip/pip.conf
        echo "timeout = 6000" >> ~/.config/pip/pip.conf
        echo "index-url = https://pypi.tuna.tsinghua.edu.cn/simple" >> ~/.config/pip/pip.conf

        wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
        mkdir -p ~/.conda && chmod +x ~/miniconda.sh && ~/miniconda.sh -b -p ~/conda && rm -rf ~/miniconda.sh
        ~/conda/bin/conda init bash && ~/conda/bin/conda update -y conda
        ~/conda/bin/conda clean   -y -f
    ;;
esac

echo -n "8. Install pytorch ev? [y/N]:"
read arg
case $arg in
    Y|y)
        ~/conda/bin/conda create  -y -n pytorch python=3.7
        ~/conda/bin/conda install -y -n pytorch fire ptvsd tqdm plotly jupyterlab -c conda-forge
        ~/conda/bin/conda install -y -n pytorch numba pandas openpyxl xgboost scikit-learn -c conda-forge
        ~/conda/bin/conda install -y -n pytorch imageio nibabel simpleitk opencv scikit-image -c simpleitk -c conda-forge
        ~/conda/bin/conda install -y -n pytorch pytorch torchvision cpuonly -c pytorch
        ~/conda/bin/conda install -y -n pytorch fastprogress fastai -c fastai
        ~/conda/bin/conda clean   -y -f
    ;;
esac

echo -n "9. Copy custom config? [y/N]:"
read arg
case $arg in
    Y|y)
        cd ${data}/Apps/settings
        cp -r .jupyter .ssh frp ~ && cp -r Code sublime-text-3 ~/.config
        cp .gitconfig .git-credentials ~ && chmod 700 ~/.ssh && chmod 600 ~/.ssh/*
        sudo ln -s ${data}/Workspace ~/workspace
        sudo ln -s ~/frp/frpc.conf /etc/supervisor/conf.d/frpc.conf
        sudo ln -s ~/.jupyter/jupyter.conf /etc/supervisor/conf.d/jupyter.conf
    ;;
esac
