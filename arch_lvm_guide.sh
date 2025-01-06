# +--------------------+-----------------+-----------------+
# | Partition          | Size            | Type            |
# +--------------------+-----------------+-----------------+
# | /dev/nvme0n1p1     | 512M            | EFI System      |
# | /dev/nvme0n1p2     | Rest            | Linux LVM       |
# +--------------------+-----------------+-----------------+

pvcreate /dev/nvme0n1p2
vgcreate main /dev/nvme0n1p2
lvcreate -L 50G -n root main 
lvcreate -L 16G -n swap main
lvcreate -L 50G -n home main

mkfs.vfat /dev/nvme0n1p1
mkfs.ext4 /dev/main/root
mkfs.ext4 /dev/main/home
mkswap    /dev/main/swap

mount  /dev/main/root /mnt
mkdir  /mnt/{home,efi}
mount  /dev/main/home /mnt/home
mount  /dev/nvme0n1p1 /mnt/efi
swapon /dev/main/swap

pacstrap -K /mnt base linux linux-firmware lvm2 grub \
    efibootmgr vim intel-ucode networkmanager reflector
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

vim /etc/mkinitcpio.conf # udev ... block lvm2 filesystems 
mkinitcpio -P
vim /etc/default/grub
#   GRUB_PRELOAD_MODULES="part_gpt part_msdos lvm"
grub-install --efi-directory=/efi --bootloader-id=GRUB
#   by default: --target=x86_64-efi 
grub-mkconfig -o /boot/grub/grub.cfg

exit
umount -R /mnt
swapoff -a
reboot

# +--------------------------------------------------------+
# |                     Post installation                  |
# +--------------------------------------------------------+

systemctl enable NetworkManager
systemctl start NetworkManager

timedatectl set-timezone Region/City
timedatectl set-ntp 1
hwclock --systohc

localectl set-locale LANG=en_US.UTF-8
localectl set-keymap us 
hostnamectl hostname yourhostname

reflector -c Country -p https --sort rate --save \
    /etc/pacman.d/mirrorlist
vim /etc/pacman.conf # Color, ParallelDownloads, [multilib]
pacman -Syu
pacman -S xorg xorg-server xorg-xinit

passwd
useradd -m -s /bin/zsh username
passwd username
EDITOR=vim visudo

