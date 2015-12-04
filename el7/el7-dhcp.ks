#Centos Kickstart for net install
#version=<VERSION>

install
url --url http://mirror.centos.org/centos/7/os/x86_64
lang en_US.UTF-8
keyboard us
#text
cmdline
network --onboot yes --device eth0 --bootproto dhcp --noipv6 --hostname centostemplate.example.com
rootpw password
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
timezone --utc Etc/UTC
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"

zerombr
clearpart --all --drives=sda --initlabel

part /boot --fstype=ext4 --size=500
part pv.008002 --grow --size=200

volgroup vg_template --pesize=4096 pv.008002
logvol /home --fstype=ext4 --name=lv_home --vgname=vg_template --size=15000
logvol / --fstype=ext4 --name=lv_root --vgname=vg_template --size=5000
logvol swap --name=lv_swap --vgname=vg_template --size=4096
logvol /usr --fstype=ext4 --name=lv_usr --vgname=vg_template --size=15000
logvol /var --fstype=ext4 --name=lv_var --vgname=vg_template --size=15000

repo --name="base" --baseurl=http://mirror.centos.org/centos/7/os/x86_64 --cost=100

%packages --nobase
# Add these
@core
ntpdate
ntp
wget
screen
git
perl
openssh-clients
open-vm-tools
man
mlocate
bind-utils
traceroute
mailx

# Remove these
-iwl5000-firmware-8.83.5.1_1-1.el6_1.1.noarch
-ivtv-firmware-20080701-20.2.noarch
-xorg-x11-drv-ati-firmware-7.1.0-3.el6.noarch
-atmel-firmware-1.3-7.el6.noarch
-iwl4965-firmware-228.61.2.24-2.1.el6.noarch
-iwl3945-firmware-15.32.2.9-4.el6.noarch
-rt73usb-firmware-1.8-7.el6.noarch
-iwl5150-firmware-8.24.2.2-1.el6.noarch
-iwl6050-firmware-41.28.5.1-2.el6.noarch
-iwl6000g2a-firmware-17.168.5.3-1.el6.noarch
-iwl6000-firmware-9.221.4.1-1.el6.noarch
-ql2400-firmware-7.00.01-1.el6.noarch
-ql2100-firmware-1.19.38-3.1.el6.noarch
-libertas-usb8388-firmware-5.110.22.p23-3.1.el6.noarch
-ql2500-firmware-7.00.01-1.el6.noarch
-zd1211-firmware-1.4-4.el6.noarch
-rt61pci-firmware-1.2-7.el6.noarch
-ql2200-firmware-2.02.08-3.1.el6.noarch
-ipw2100-firmware-1.3-11.el6.noarch
-ipw2200-firmware-3.1-4.el6.noarch
-bfa-firmware-3.2.21.1-2.el6.noarch
-iwl100-firmware-39.31.5.1-1.el6.noarch
-aic94xx-firmware-30-2.el6.noarch
-iwl1000-firmware-39.31.5.1-1.el6.noarch

%end

%post --log=/root/ks-post.log

rpm -ivh https://yum.puppetlabs.com/el/7/PC1/x86_64/puppetlabs-release-pc1-1.0.0-1.el7.noarch.rpm
yum -y install puppet
yum -y update

chkconfig ntpd on

%end

reboot
