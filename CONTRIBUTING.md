Development setup (for mac)
===========================

- XCode - it's needed to compile things, dependencies, gems etc. Install it from the App Store.
- homebrew - the only other thing you'll ever need. Everything else will be managed with homebrew.
  Run the following in a terminal.
  ```shell
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ```

- homebrew extensions - enable homebrew to install GUI, fonts, older versions... etc (as needed)
  ```shell
  brew tap caskroom/cask
  brew tap caskroom/fonts
  ```

- iTerm2 (optional but recommended - more advanced terminal app than OS X default one)
  ```shell
  brew cask install iterm2
  ```
  Activate the "Working directory -> Reuse previous session's directory" option for the default profile,
  so new tabs keep the curent directory, very useful.

- fish shell (optional but recommended - more advanced shell. Much more than bash. More than zsh.)
  ```shell
  brew install fish
  ```
  version 2.2 has a bug in saving prompts, it's solved in 2.3 that's about to be published
  
- Install various packages through homebrew:
  ```shell
  brew install git rbenv postgresql git-flow-avh
  brew services start postgresql
  ```
  
- Install ruby version and needed global gems
  ```shell
  rbenv install 2.3.0
  rbenv global 2.3.0
  rbenv init
  ```
  (follow instructions to activate rbenv in the current shell, before continuing)
  ```
  gem install bundler
  bundle config path vendor/bundle
  ```
  the project's gems won't be installed in the global space, but only in the `vendor/bundle` subdirectory.
  
