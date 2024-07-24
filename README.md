# Fishbowl Inventory Ansible Playbook

Fishbowl is an Orem, Utah-based software company that develops and publishes inventory management software and related software.

## Initial settings

Install `ansible` and `make` in your system.
```bash
sudo apt -y install ansible make
```

## Vagrant settings

Install vagrant and virtualbox in your system.
```bash
sudo apt -y install vagrant virtualbox
```

To configure a ubuntu virtual machine with vagrant use the commands below.
```bash
make download                       # Download windows werver 2022 evaluation.
make init                           # Prepare your working directory for other command.
make key                            # Create SSH key and save to ~/.ssh folder.
make build                          # Build fishbowl image.
make box                            # Create fishbowl virtualbox box.
make settings                       # Copy default settings.
make up                             # Create vagrant ubuntu virtual machine for testing.
make provision                      # Provision vagrant ubuntu virtual machine.
make ssh                            # SSH into vagrant ubuntu virtual machine.
make destroy                        # Destroy vagrant ubuntu virtual machine.
```

> Make sure to adjust `.env` file with the settings for you needs.
