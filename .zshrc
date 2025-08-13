export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=agnoster
# ZSH_THEME=robbyrussell

HIST_STAMPS="dd/mm/yyyy"

plugins=(
	git
	docker
	docker-compose
	python
	dotnet
	nvm
	sudo
	yarn
	zsh-ssh
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

ANACONDA_INSTALL_PATH="/opt/anaconda/bin"

export HSA_OVERRIDE_GFX_VERSION=10.3.0
export AMD_SERIALIZE_KERNEL=3
export PATH=$PATH:/opt/rocm/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PATH="$HOME/VMs/quickemu:$PATH"export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"



