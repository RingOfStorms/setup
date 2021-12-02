# zsh shell
`echo $SHELL` to check current shell
`chsh -s /bin/zsh` to switch to zsh on macos

- Install powerlevel 10k https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
	- Install font files first https://github.com/romkatv/powerlevel10k#user-content-manual-font-installation
	- Install oh my zsh https://ohmyz.sh/
		- `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
	- Install powerlevel 10k https://github.com/romkatv/powerlevel10k#oh-my-zsh (dont forget to edit .zshrc for step 2)
	- Start new terminal, verify fonts
		- Classic, unicode, dark, no time, angled, sharp, flat, two lines, dotted, full, compact, many icons, concise, yes transient, verbose, apply yes
	- Install `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting`
	- Install `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`
	- open ~/.zshrc
	  - plugins=(git npm macos zsh-syntax-highlighting zsh-autosuggestions)
# Default Applications

## Mac
- [iTerm2](https://iterm2.com/downloads/stable/latest)
  - Preferences:
    - Appearance: General Theme: Compact
    - Keys: Remove move tab right/left, Previous Tab: ↑⌘←, Next Tab: ↑⌘→
    - Keys:Navigation Shortcuts:Shortcut to select a tab: No Shortcut
    - Profiles: Default: Text: Font: MesloLGS NF
    - Profiles: Default: Colors: Basic Colors: Background: 212121
