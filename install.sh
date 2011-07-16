#!/bin/bash

function isargv
{
    for arg in $ARGV
    do
        if [ $arg == $1 ]
        then
            return 0
        fi
    done
    return 1
}

function error
{
    echo "ERRO: $1"
    exit 1
}

function download_vim
{
    hg clone https://vim.googlecode.com/hg/ vim
    if [ $? != 0 ]
    then
        error "An error occurred while downloading vim source"
    fi
}

function update_vim
{
    cd vim
    hg pull
    if [ $? != 0 ]
    then
        error "An error occurred while updating vim repository"
    fi
    hg update
    if [ $? != 0 ]
    then
        error "An error occurred while updating vim repository"
    fi
    cd ..
}

function install_vim
{
    cd vim
    ./configure --enable-pythoninterp --enable-rubyinterp
    if [ $? != 0 ]
    then
        error "An error occurred while installing vim"
    fi
    make
    if [ $? != 0 ]
    then
        error "An error occurred while installing vim"
    fi
    cd ..
}

function git_submodules
{
    git submodule init
    if [ $? != 0 ]
    then
        error "An error occurred while trying init submodules"
    fi
    git submodule update
    if [ $? != 0 ]
    then
        error "An error occurred while trying update submodules"
    fi
}

function copy_important_files
{
    if [ -d $HOME/.vimutopia ]; then rm -Rf $HOME/.vimutopia; fi
    if [ $? != 0 ]
    then
        error "Can't remove .vimutopia folder"
    fi
    mkdir $HOME/.vimutopia
    if [ $? != 0 ]
    then
        error "Can't create .vimutopia folder"
    fi
    cp vimrc.vim $HOME/.vimutopia
    if [ $? != 0 ]
    then
        error "Can't copy vimrc file"
    fi
    cp -R vim $HOME/.vimutopia
    if [ $? != 0 ]
    then
        error "Can't copy vim folder"
    fi
    if [ ! -d $HOME/bin ]; then mkdir $HOME/bin; fi
    if [ $? != 0 ]
    then
        error "Can't create bin folder"
    fi
    if [ ! -f $HOME/bin/vimu ]
    then
        ln -s $HOME/.vimutopia/vim/src/vim $HOME/bin/vimu
        if [ $? != 0 ]
        then
            error "Can't create symbolic link to vimu"
        fi
    fi
    mkdir $HOME/.vimutopia/scripts
    if [ $? != 0 ]
    then
        error "Can't create scripts folder"
    fi
    mkdir $HOME/.vimutopia/doc
    if [ $? != 0 ]
    then
        error "Can't create doc folder"
    fi
    cp src/scripts/scripts_generic.py $HOME/.vimutopia/scripts
    if [ $? != 0 ]
    then
        error "Can't copy a script"
    fi
    cp -R autoload $HOME/.vimutopia/autoload
    if [ $? != 0 ]
    then
        error "Can't copy autoload folder"
    fi
    cp -R bundle $HOME/.vimutopia/bundle
    if [ $? != 0 ]
    then
        error "Can't copy bundle folder"
    fi
}

function install_python_dependencies
{
    cp src/vimrc-py.vim $HOME/.vimutopia/vimrc-py.vim
    if [ $? != 0 ]
    then
        error "Can't copy a script"
    fi
    cp doc/help-py.man $HOME/.vimutopia/doc/help-py.man
    if [ $? != 0 ]
    then
        error "Can't copy a doc"
    fi
    cp src/scripts/scripts_python.py $HOME/.vimutopia/scripts
    if [ $? != 0 ]
    then
        error "Can't copy a script"
    fi
    echo "autocmd BufNewFile,BufRead *.py source $HOME/.vimutopia/vimrc-py.vim" >> $HOME/.vimrc
    if [ $? != 0 ]
    then
        error "Can't append line in .vimrc file"
    fi
}

function install_c_dependencies
{
    wget "http://downloads.sourceforge.net/project/igcc/igcc-0.1.tar.bz2"
    if [ $? != 0 ]
    then
        error "An error occurred during download of igcc"
    fi
    tar -xjf "igcc-0.1.tar.bz2"
    if [ $? != 0 ]
    then
        error "An error occurred during unpack igcc"
    fi
    rm igcc-0.1.tar.bz2
    if [ $? != 0 ]
    then
        error "Can't remove igcc-0.1.tab.bz2"
    fi
    mv igcc-0.1 $HOME/.vimutopia/igcc
    if [ $? != 0 ]
    then
        error "Can't move igcc folder"
    fi
    cp src/vimrc-c.vim $HOME/.vimutopia/vimrc-c.vim
    if [ $? != 0 ]
    then
        error "Can't copy a script"
    fi
    cp doc/help-c.man $HOME/.vimutopia/doc/help-c.man
    if [ $? != 0 ]
    then
        error "Can't copy a doc"
    fi
    echo "autocmd BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp source $HOME/.vimutopia/vimrc-c.vim" >> $HOME/.vimrc
    if [ $? != 0 ]
    then
        error "Can't append line in .vimrc file"
    fi
}

function install_specific_dependencies
{
    for package in $packages
    do
        if [ $package == "Python" ]
        then
            install_python_dependencies
        fi
        if [ $package == "C" ]
        then
            install_c_dependencies
        fi
    done
}

function main
{
    if [ ! -d vim ]
    then
        download_vim
    fi
    if ! isargv "--no-update-vim"
    then
        update_vim
    fi
    install_vim
    git_submodules
    copy_important_files
    if isargv "--no-c"
    then
        packages="Python"
    else
        packages="Python C"
    fi
    install_specific_dependencies
}

ARGV=$*
main
