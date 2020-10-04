# Profiles
resource "lxd_profile" "zone-1" {
  name = "zone-1"

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "default"
      path = "/"
    }
  }
}

resource "lxd_profile" "zone-2" {
  name = "zone-2"

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "default"
      path = "/"
    }
  }
}

resource "lxd_profile" "zone-3" {
  name = "zone-3"

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "default"
      path = "/"
    }
  }
}

resource "lxd_profile" "zone-4" {
  name = "zone-4"

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "default"
      path = "/"
    }
  }
}

resource "lxd_profile" "master" {
  name = "master"

  device {
    name = "root"
    type = "disk"
    properties = {
      pool = "default"
      path = "/"
    }
  }
}

# Networking Configurations
resource "lxd_network" "zone-1" {
  name = "zone-1"

  config = {
    "bridge.driver" = "openvswitch"
    "ipv4.address"  = "10.0.10.1/24"
    "ipv6.address"  = "none"
    "ipv4.nat"      = "true"
  }
}

resource "lxd_network" "zone-2" {
  name = "zone-2"

  config = {
    "bridge.driver" = "openvswitch"
    "ipv4.address"  = "10.0.20.1/24"
    "ipv6.address"  = "none"
    "ipv4.nat"      = "true"
  }
}

resource "lxd_network" "zone-3" {
  name = "zone-3"

  config = {
    "bridge.driver" = "openvswitch"
    "ipv4.address"  = "10.0.30.1/24"
    "ipv6.address"  = "none"
    "ipv4.nat"      = "true"
  }
}

resource "lxd_network" "zone-4" {
  name = "zone-4"

  config = {
    "bridge.driver" = "openvswitch"
    "ipv4.address"  = "10.0.40.1/24"
    "ipv6.address"  = "none"
    "ipv4.nat"      = "true"
  }
}

resource "lxd_network" "master" {
  name = "master"

  config = {
    "bridge.driver" = "openvswitch"
    "ipv4.address"  = "10.0.0.1/24"
    "ipv6.address"  = "none"
    "ipv4.nat"      = "true"
  }
}
