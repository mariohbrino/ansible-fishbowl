# Fishbowl Inventory Ansible Playbook

Fishbowl is an Orem, Utah-based software company that develops and publishes inventory management software and related software.

## Initial settings

Install `ansible` and `make` in your system.
```bash
sudo apt -y install ansible make
```

## Vagrant settings

Install `vagrant` and `virtualbox` in your system.
```bash
sudo apt -y install vagrant virtualbox
vagrant plugin install vagrant-env
```

To configure a ubuntu virtual machine with vagrant use the commands below.
```bash
make setup                          # Initial setup for host machine.
make download                       # Download windows werver 2022 evaluation.
make init                           # Prepare your working directory for other command.
make key                            # Create SSH key and save to ~/.ssh folder.
make build                          # Build fishbowl image.
make box                            # Create fishbowl virtualbox box.
make settings                       # Copy default settings.
make up                             # Create vagrant ubuntu virtual machine for testing.
make network                        # Network provision virtual machine on virtualbox.
make provision                      # Setup provision vagrant ubuntu virtual machine.
make ssh                            # SSH into vagrant ubuntu virtual machine.
make destroy                        # Destroy vagrant ubuntu virtual machine.
```

> Make sure to adjust `.env` file with the settings for you needs.

> [!NOTE]
> Ignore error when creating `fishbowl.windows` virtual machine.

## Ansible Lint

To validate and enforce ansible conventions use ansible-lint, please check the documentation for more information [here](https://ansible.readthedocs.io/projects/lint/).

```bash
pip3 install ansible-dev-tools
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
source ~/.profile
```

## Ansible Windows Tips

List all installed applications with `IdentifyingNumber` (product_id).
```bash
Get-WmiObject Win32_Product
```

When working with installation of applications it will require to know the `product_id` to keep the the playbook idempotente. Then make the installation and get the product_id from regdit or powershell.
```bash
Get-WmiObject Win32_Product | Where Name -eq '<ProductName>' | Format-Table IdentifyingNumber, Name
```

> [!NOTE]
> HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
> HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall
> HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
> HKCU\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall
