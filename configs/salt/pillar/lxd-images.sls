lxd:
  images:
    local:
      ubuntu:
        name: Ubuntu
        source:
          name: ubuntu/xenial/amd64 
          remote: images_linuxcontainers_org
        running: True
        auto_update: True
