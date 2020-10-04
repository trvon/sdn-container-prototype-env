{% set postdata = data.get('post', {}) %}

test:
  lxd-snapshot:
    lxd.snapshots_create:
      - container: Ubuntu
      - name: test-snapshot
