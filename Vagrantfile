
Vagrant.require_version ">= 1.6.2"

Vagrant.configure("2") do |config|
  config.env.enable

  config.vm.define "fishbowl.ubuntu" do |node|
    node.vm.box = ENV["BOX"]
    node.vm.hostname = ENV["HOSTNAME"]

    node.vm.network ENV["NETWORK"],
      ip: ENV["IP_ADDRESS"],
      bridge: ENV["BRIDGE"],
      gateway: ENV["GATEWAY"],
      netmask: ENV["NETMASK"]

    node.vm.provider "virtualbox" do |vm|
      vm.name = "fishbowl.ubuntu"
      vm.cpus = ENV["CPUS"]
      vm.memory = ENV["MEMORY"]
    end

    node.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/vagrant-ubuntu.yml"
      ansible.compatibility_mode = "1.8"
    end
  end

  config.vm.define "fishbowl.windows" do |node|
    node.vm.box = "brino/fishbowl"
    node.vm.hostname = "fishbowl"

    # Configure SSH
    node.vm.communicator = "ssh"
    node.ssh.username = "administrator"
    node.ssh.private_key_path = ".ssh/fishbowl"
    # node.ssh.shell = "powershell" # TODO: shell crashing and destroying when creating virtual machine.
    node.ssh.connect_timeout = 15

    node.vm.guest = :windows

    node.vm.network "public_network",
      bridge: ['eno1']

    # Configure the VM
    node.vm.provider :virtualbox do |v|
      v.name = "fishbowl.windows"
      v.customize ["modifyvm", :id, "--memory", 8192]
      v.customize ["modifyvm", :id, "--cpus", 4]
      v.customize ["modifyvm", :id, "--vram", 128]
      v.customize ["modifyvm", :id, "--graphicscontroller", "vboxsvga"]
      v.customize ["modifyvm", :id, "--accelerate3d", "on"]
      v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      v.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end

    # Provisioning script to set the default gateway and DNS settings
    node.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/vagrant-windows.yml"
      ansible.compatibility_mode = "1.8"
      ansible.extra_vars = {
        ip_address: ENV["WINDOWS_IP_ADDRESS"],
        default_gateway: ENV["GATEWAY"],
        prefix_length: ENV["LENGTH"]
      }
    end
  end
end
