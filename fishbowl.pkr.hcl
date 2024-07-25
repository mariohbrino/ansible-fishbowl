packer {
  required_version = ">= 1.8.3"

  required_plugins {
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }

    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = "~> 1"
    }
  }
}

variable "cpus" {
  type    = number
  default = 2
}

variable "disk_size" {
  type    = string
  default = "61440"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"
}

variable "iso_url" {
  type    = string
  default = "./images/SERVER_EVAL_x64FRE_en-us.iso"
}

variable "manually_download_iso_from" {
  type    = string
  default = "https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022"
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "restart_timeout" {
  type    = string
  default = "5m"
}

variable "ssh_key_path" {
  type    = string
  default = ".ssh/fishbowl"
}

variable "ssh_timeout" {
  type    = string
  default = "15m"
}

source "virtualbox-iso" "windows-2022" {
  boot_wait    = "2m"
  communicator = "ssh"
  cpus         = "${var.cpus}"
  disk_size    = "${var.disk_size}"
  floppy_files = [
    "./answer/autounattend.xml",
    "./scripts/configure.ps1",
    "./scripts/settings.ps1",
    "./.ssh/fishbowl.pub"
  ]
  guest_additions_mode = "disable"
  guest_os_type        = "Windows2019_64"
  headless             = "${var.headless}"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  memory               = "${var.memory}"
  shutdown_command     = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  vm_name              = "fishbowl.windows"
  ssh_username         = "administrator"
  ssh_private_key_file = "${var.ssh_key_path}"
  ssh_timeout          = "${var.ssh_timeout}"
  output_directory     = "box"
}

build {
  sources = ["source.virtualbox-iso.windows-2022"]

  post-processor "vagrant" {
    keep_input_artifact  = false
    output               = "fishbowl-virtualbox.box"
    vagrantfile_template = "vagrantfile-fishbowl.template"
  }
}
