
.DEFAULT_GOAL = help

help: # Show a list of commands available.
	@echo "List of commands."
	@echo "usage: make <command>\n"
	@echo "Commands:\n"
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

download: # Download windows werver 2022 evaluation.
	@wget https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso -O ./images/SERVER_EVAL_x64FRE_en-us.iso

init: # Install Packer plugins.
	@packer init .

key: # Create SSH key and save to ~/.ssh folder.
	@ssh-keygen -t ed25519 -C "fishbowl" -f .ssh/fishbowl -N ''

build: # Build fishbowl image.
	@packer init fishbowl.pkr.hcl
	@packer build -force fishbowl.pkr.hcl

box: # Create fishbowl virtualbox box.
	@vagrant box add virtualbox.json --force

settings: # Copy default settings.
	@cp .env.example .env

up: # Create virtual machine on virtualBox.
	@vagrant up fishbowl.windows

network: # Provision virtual machine on virtualbox.
	@vagrant provision fishbowl.windows --provision network

provision: # Provision virtual machine on virtualbox.
	@vagrant provision fishbowl.windows --provision setup

ssh: # SSH into vagrant ubuntu virtual machine.
	@vagrant ssh fishbowl.windows

destroy: # Destroy vagrant ubuntu virtual machine.
	@vagrant destroy -f fishbowl.windows
