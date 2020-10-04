provider "lxd" {
  version = "~> 1.3"
  generate_client_certificates = true
  accept_remote_certificate    = true

  lxd_remote {
    name    = "master-zone"
    scheme  = "https"
    default = true
  }

  lxd_remote {
    name 	= "zone-1"
    scheme  	= "https"
    address 	= "10.0.10.5"
    password 	= "password"
  }

  lxd_remote {
    name 	= "zone-2"
    scheme  	= "https"
    address 	= "10.0.20.5"
    password 	= "password"
  }

  lxd_remote {
    name 	= "zone-3"
    scheme  	= "https"
    address 	= "10.0.30.5"
    password 	= "password"
  }

  lxd_remote {
    name 	= "zone-4"
    scheme  	= "https"
    address 	= "10.0.40.5"
    password 	= "password"
  }
}

# Images
resource "lxd_container" "zone-1" {
  name      = "zone-1"
  image     = "ubuntu:18.04"
  profiles  = ["default", lxd_profile.zone-1.name]
  ephemeral = false

  config = {
    "boot.autostart" = true
	"security.nesting" 	= true
  }

  file {
    source = "./configs/ssh_key"
    target_file = "/root/.ssh/authorized_keys"
	create_directories = true
  }

  file {
    source = "./configs/minion"
    target_file = "/etc/salt/minion"
    create_directories = true
  }

  file {
    source 	= "./scripts/minion.sh"
    target_file = "/root/minion.sh"
	create_directories = true
  }

  provisioner "local-exec" {
    command = <<EXEC
      lxc exec ${lxd_container.zone-1.name} -- sh /root/minion.sh &
    EXEC
  }

  provisioner "local-exec" {
    command = <<EXEC
      sudo ovs-vsctl set bridge zone-1 protocols=OpenFlow10,OpenFlow11,OpenFlow12,OpenFlow13,OpenFlow14,OpenFlow15
	  sudo ovs-vsctl set-controller zone-1 tcp:10.0.0.5:6633
    EXEC
  }

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = lxd_network.zone-1.name
      "ipv4.address" = "10.0.10.5"
	}
  }
}


resource "lxd_container" "zone-2" {
  name      = "zone-2"
  image     = "ubuntu:18.04"
  profiles  = ["default", lxd_profile.zone-2.name]
  ephemeral = false

  config = {
    "boot.autostart" = true
	"security.nesting" 	= true
  }

  file {
    source = "./configs/ssh_key"
    target_file = "/root/.ssh/authorized_keys"
	create_directories = true
  }

  file {
    source = "./configs/minion"
    target_file = "/etc/salt/minion"
    create_directories = true
  }

  file {
    source 	= "./scripts/minion.sh"
    target_file = "/root/minion.sh"
    create_directories = true
  }

  provisioner "local-exec" {
    command = <<EXEC
      lxc exec ${lxd_container.zone-2.name} -- sh /root/minion.sh &
    EXEC
  }

  provisioner "local-exec" {
    command = <<EXEC
      sudo ovs-vsctl set bridge zone-2 protocols=OpenFlow10,OpenFlow11,OpenFlow12,OpenFlow13,OpenFlow14,OpenFlow15
	  sudo ovs-vsctl set-controller zone-2 tcp:10.0.0.5:6633
    EXEC
  }

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = lxd_network.zone-2.name
      "ipv4.address" = "10.0.20.5"
	}
  }
}

resource "lxd_container" "zone-3" {
  name      = "zone-3"
  image     = "ubuntu:18.04"
  profiles  = ["default", lxd_profile.zone-3.name]
  ephemeral = false

  config = {
    "boot.autostart" = true
	"security.nesting" 	= true
  }

  file {
    source = "./configs/ssh_key"
    target_file = "/root/.ssh/authorized_keys"
	create_directories = true
  }

  file {
    source = "./configs/minion"
    target_file = "/etc/salt/minion"
    create_directories = true
  }

  file {
    source 	= "./scripts/minion.sh"
    target_file = "/root/minion.sh"
	create_directories = true
  }

  provisioner "local-exec" {
    command = <<EXEC
      lxc exec ${lxd_container.zone-3.name} -- sh /root/minion.sh &
    EXEC
  }

  provisioner "local-exec" {
    command = <<EXEC
      sudo ovs-vsctl set bridge zone-3 protocols=OpenFlow10,OpenFlow11,OpenFlow12,OpenFlow13,OpenFlow14,OpenFlow15
	  sudo ovs-vsctl set-controller zone-3 tcp:10.0.0.5:6633
    EXEC
  }

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = lxd_network.zone-3.name
      "ipv4.address" = "10.0.30.5"
	}
  }
}

resource "lxd_container" "zone-4" {
  name      = "zone-4"
  image     = "ubuntu:18.04"
  profiles  = ["default", lxd_profile.zone-4.name]
  ephemeral = false

  config = {
    "boot.autostart" = true
	"security.nesting" 	= true
  }

  file {
    source = "./configs/ssh_key"
    target_file = "/root/.ssh/authorized_keys"
	create_directories = true
  }

  file {
    source = "./configs/minion"
    target_file = "/etc/salt/minion"
    create_directories = true
  }

  file {
    source 	= "./scripts/minion.sh"
    target_file = "/root/minion.sh"
	create_directories = true
  }

  provisioner "local-exec" {
    command = <<EXEC
      lxc exec ${lxd_container.zone-4.name} -- sh /root/minion.sh &
    EXEC
  }

  provisioner "local-exec" {
    command = <<EXEC
      sudo ovs-vsctl set bridge zone-4 protocols=OpenFlow10,OpenFlow11,OpenFlow12,OpenFlow13,OpenFlow14,OpenFlow15
	  sudo ovs-vsctl set-controller zone-4 tcp:10.0.0.5:6633
    EXEC
  }

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = lxd_network.zone-4.name
      "ipv4.address" = "10.0.40.5"
    }
  }
}

resource "lxd_container" "master" {
  name      = "master"
  image     = "ubuntu:18.04"
  profiles  = ["default", lxd_profile.master.name]
  ephemeral = false

  config = {
    "boot.autostart" 	= true
    "security.nesting" 	= true
  }

  file {
    source = "./scripts/master.sh"
    target_file = "/root/master.sh"
  }

  file {
    source = "./configs/master"
    target_file = "/root/master"
  }

  file {
    source = "./configs/ssh_key"
    target_file = "/root/.ssh/authorized_keys"
    create_directories = true
  }

  file {
    source = "./configs/snort.lua"
    target_file = "/usr/local/snort/etc/snort/snort.lua"
    create_directories = true
  }

  provisioner "local-exec" {
    command = <<EXEC
      lxc file push ./configs/salt/* -r ${lxd_container.master.name}/srv/
      lxc file push ./controller -r ${lxd_container.master.name}/opt/
      lxc exec ${lxd_container.master.name} -- sh /root/master.sh &
      sudo ovs-vsctl set bridge zone-4 protocols=OpenFlow10,OpenFlow11,OpenFlow12,OpenFlow13,OpenFlow14,OpenFlow15
      sudo ovs-vsctl set-controller master tcp:10.0.0.5:6633
    EXEC
  }

 provisioner "local-exec" {
   command = <<EXEC
   	sudo ovs-vsctl -- set Bridge master mirrors=@m \
   	-- --id=@zone-1 get Port zone-1 \
   	-- --id=@zone-2 get Port zone-2 \
   	-- --id=@zone-3 get Port zone-3 \
   	-- --id=@zone-4 get Port zone-4 \
   	-- --id=@m create Mirror name=master-mirror select-dst-port=$(sudo ovs-vsctl list Bridge master | head -n 1 | awk '{print $3}')

   EXEC
 }

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = lxd_network.master.name
      "ipv4.address" = "10.0.0.5"
    }
  }
}

