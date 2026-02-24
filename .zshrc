export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=agnoster
# ZSH_THEME=robbyrussell

# Agnoster colors tuned for VS Code Dark+ terminal palette
DEFAULT_USER=mihai                     # hide user@host when local
AGNOSTER_STATUS_BG=236                 # dark gray (#303030) - visible against #1f1f1f bg
AGNOSTER_CONTEXT_BG=236                # match status segment
AGNOSTER_CONTEXT_FG=cyan               # cyan accent for user@host
AGNOSTER_DIR_BG=blue                   # keep blue for cwd
AGNOSTER_DIR_FG=white                  # white on #2472c8 for readability
AGNOSTER_GIT_CLEAN_BG=green
AGNOSTER_GIT_CLEAN_FG=black
AGNOSTER_GIT_DIRTY_BG=yellow
AGNOSTER_GIT_DIRTY_FG=black

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

# Force Electron apps to use native Wayland
export ELECTRON_OZONE_PLATFORM_HINT=wayland

# AMD GPU / ROCm
export HSA_OVERRIDE_GFX_VERSION=10.3.0
export AMD_SERIALIZE_KERNEL=3
export PATH=$PATH:/opt/rocm/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/VMs/quickemu:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$HOME/.cargo/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

export JAVA_HOME=/usr/lib/jvm/temurin-25-jdk-amd64

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

alias orca-slicer="flatpak run com.softfever.OrcaSlicer"

# Override oh-my-zsh git plugin alias to use GitKraken CLI
unalias gk 2>/dev/null
alias gk='/usr/bin/gk'
