Entorno de desarrollo aconsejado (para mac)
===========================================

Homebrew - para instalar todo tipo de paquetes adicionales (<http://brew.sh>).

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

iTerm2 - un terminal mucho más completo (<http://iterm2.com>). Especialmente recomendado activar
la opción "Working directory -> Reuse previous session's directory" para el perfil por defecto,
para jugar fácilmente con múltiples pestañas en la misma directory.

    brew cask install iterm2

Atom (<https://atom.io>)

    brew cask install atom

fish - una shell mucho más avanzada que bash, y menos enredada que zsh.

    brew install fish

Instalar varios paquetes por medio de homebrew

    brew install git rbenv ruby-build postgresql

Instalar ruby

    rbenv install 2.2.0
    rbenv global 2.2.0
    
Añadir la siguiente línea al fichero `.profile` para tener rbenv activado) y reiniciar
el terminal.

    eval "$(rbenv init -)"


Actualizar rubygems e instalar bundler

    gem update --system
    gem install bundler
    

How to install docker and containers in OS X (work in progress)
===============================================================

1. Install compiler and dependencies (which boils down to be
   the same as the `build-essential` package on debian systems):

  > Run `pkgutil --pkg-info=com.apple.pkg.CLTools_Executables` in terminal.
    If it complains that `No receipt for 'com.apple.pkg.CLTools_Executables'`,
    than install Xcode from <https://developer.apple.com/xcode/>

2. Install `pip`: `sudo easy_install pip` (for system python)
3. Install `ansible`: `sudo pip install ansible`
4. Execute:

  >  ansible-playbook -i provisioning/hosts provisioning/development-osx.yml --ask-become-pass

   This will install a number of local packages that should allow parallel
   lightweight containers in OS X.


Troubleshooting OS X
====================

If you have YADR installed, or another giant dotfile collection, then it may
be forcing your rubygems to take a local Gemfile into account. This behavior
is not working as intended, so to remove it, look for a

    > `export RUBYGEMS_GEMDEPS="-"`

and comment it out, in any dotfile:

- `.bashrc`
- `.zshrc`
- `.zprofile`
- `.profile`
- `.bash_profile`
- `.zlogin`
- `.my_init_var_script`
- ...
