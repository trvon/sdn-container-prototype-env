#!yaml|jinja

statreg:
  status.reg

snapshot:
  lxd.snapshots_create:
    - container: "test-node"
    - name: "test-node-1"
