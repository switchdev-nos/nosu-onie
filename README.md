# nosu-onie
Build scripts for NOSU ONIE image

Create ONIE installer image from NOSU rootfs tarball.

This tool can be used to create a specialized [ONIE installer](https://opencomputeproject.github.io/onie/overview/index.html) for whitebox switches.

## Usage

`./build.sh [-i installer] nosu-rootfs`

**installer** - is a script in `installers` directory, which will handle OS installation from Linux rootfs tarball when it is launched by ONIE environment on a switch.
Default installer: `ubuntu18xx-rootfs`

## Examples

### Creating ONIE installer from Ubuntu Server ISO image

* Clone this repo: `git clone https://github.com/switchdev-nos/nosu-onie`
* `cd nosu-onie`
* Prepare NOSU rootfs: https://github.com/switchdev-nos/nosu-rootfs
* Pack it into ONIE installer: `./build.sh <nosu-rootfs.xz>`
* ONIE installer is ready: `onie-installer-x86_64-<date>.bin`

### Installing OS on a switch

* Boot to ONIE Rescue shell
* `onie-nos-install http://<ip>/onie-installer-x86_64-<date>.bin`
* Wait until OS is installed
* `ssh admin@<switch_ip>`