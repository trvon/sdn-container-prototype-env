# SDN Lab via Terraform
This repository is an SDN enabled LXD environment that drives our prototype environemnt.

## Dependencies
- Terraform 
- https://github.com/sl1pm4t/terraform-provider-lxd

## Technologies
- Terraform
- Ryu SDN Controller
- SaltStack

## Getting Started
- Pull submodules
```
git submodule update --init --recursive
```

- Generate an ssh-key
- Copy the public key '*.pub' to ./configs/ssh_key
- Run run the following
```
./setup.sh
terraform init
terraform plan
terraform apply 
```

## TODO Fixes
- [x] sudo is required for terraform and bricks when not provided (this cannot be seen)
- [ ] Auto configure lxd
- [ ] Dangerous permissions are added to sudoers to reduce complexity

## Resources
- [OpenVSwitch Port Mirroring](https://n40lab.wordpress.com/2013/02/23/openvswitch-port-mirroring/)
- [Snort 3 Documentation](https://snort-org-site.s3.amazonaws.com/production/document_files/files/000/001/196/original/Snort_3.0.3_build_1_on_CentOS_8.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIXACIED2SPMSC7GA%2F20201003%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201003T031749Z&X-Amz-Expires=172800&X-Amz-SignedHeaders=host&X-Amz-Signature=64105cf7dbf5a12082b32a37a66b930cd9af7a5683fa8580df4334b77a8af7a3)

