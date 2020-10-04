{% set test_var = pillar['lxd-snapshot'] %}

test:
  cmd.run:
    - name: 'echo {{ test_var }}'
