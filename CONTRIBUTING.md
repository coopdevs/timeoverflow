Entorno de desarrollo aconsejado (para mac)
===========================================

iTerm2 - un terminal mucho más completo (<http://iterm2.com>). Especialmente recomendado activar
la opción "Working directory -> Reuse previous session's directory" para el perfil por defecto,
para jugar fácilmente con múltiples pestañas en la misma directory.

Homebrew - para instalar todo tipo de paquetes adicionales (<http://brew.sh>).

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

YADR - una biblioteca de shortcuts y mejoras para zsh y la línea de comando de ruby
(<https://github.com/skwp/dotfiles>). No hacen falta las opciones para `vim`, sobretodo si uno
no está acostumbrado a vim, la opción "vimification of command line tools" puede ser mortal!

    sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`" -s ask
    
Instalar varios paquetes por medio de homebrew

    brew install git rbenv ruby-build postgresql
    
Instalar ruby, y luego abrir otro terminal - para tener rbenv y yadr y todo activo.

    rbenv install 2.2.0
    rbenv global 2.2.0


Actualizar rubygems e instalar bundler

    gem update --system
    gem install bundler
    

    
