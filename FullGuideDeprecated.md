# How to setup the Cardano Node on Raspberry Pi 4 (Full Guide)



## Prerequesites

- Raspberry Pi 4 8GB RAM
- SSD (at least 240GB)
- microSD Card (at least 1GB)
- microSD Card Reader
- Eluteng SATA USB 3.0 Adapter
- microHDMI to HDMI Adapter
- Keyboard and Monitor (or use SSH instead)
- LAN connection

## 1. Upgrading Bootloader

In order to boot the Raspberry Pi from the SSD, we need to upgrade the bootloader firmware of the Pi. Normally the Pi can just boot from the microSD card slot.
We want to run the Pi on SSD because performance and speed is much higher. Also it's much more reliable, because a microSD card is not meant for a lot of read and write actions. These are the steps you need to take:

1. Download <a href="https://www.raspberrypi.org/downloads/">Pi Imager</a> and install it.
2. Insert the microSD Card in the Card Reader and plug it in your PC.
3. Open Pi Imager and click "Choose OS" -> Raspberry Pi OS (other) -> Raspberry Pi OS Lite (32-bit)
4. Click on "Choose SD Card" and select the microSD Card
5. Click "Write" and wait until finished
6. Now remove the microSD Card from the PC and plug it into the Pi
7. Connect a monitor and plugin the keyboard in a USB 2.0 slot (the left ones), also make sure to connect the LAN cabel
8. Connect the power adapter and now the Pi should turn on and boot.
9. Just wait until you are at the login screen:

- Username: pi
- Password: raspberry

10. Enter the following commands to update the distribution:

```
sudo apt update
sudo apt full-upgrade
```

11. In order to receive the latest firmware updates edit the file:

```
sudo nano /etc/default/rpi-eeprom-update
```

<img src="https://www.maketecheasier.com/assets/uploads/2020/07/raspberry-pi-4-usb-ssd-boot-05.jpg.webp"></img>

12. Change <code>FIRMWARE_RELEASE_STATUS</code> from "critical" to "stable". Press <code>CTRL + X</code>, then press <code>Y</code> and then <code>Enter</code> to confirm and leave.

13. Now enter the following command in order to upgrade the bootloader:

```
sudo rpi-eeprom-update -d -f /lib/firmware/raspberrypi/bootloader/stable/pieeprom-2020-07-31.bin
```

14. Now you can shutdown/turn off the Pi. The new Bootloader is activated and we can boot from SSD!

## 2. Preparing Ubuntu

1. Insert the SSD together with the Eluteng Adapter in your PC.
2. Open Pi Imager again and click on "Choose OS" -> Ubuntu -> Ubuntu 20.04.1 LTS (Raspberry Pi 3/4). <b>The 64-bit version!</b>
3. Click on "Choose SD Card" and select the SSD
4. Click "Write" and wait until finished
5. You should now have two partitions on your SSD looking like this:
   <img src="https://github.com/alessandrokonrad/Pi-Pool/raw/master/images/partitions.png"></img>
6. For the following it's important to have access to Linux commands on your PC (Windows users can use WSL):<br />
    
    1. Go in the system-boot partition of your SSD and open up a terminal inside (Right Click --> Open Terminal). Run this command:
    ```
    zcat vmlinuz > vmlinux
    ```
    
    2. Now open the config.txt file and replace the [pi4] section with this:
    ```
    [pi4]
    max_framebuffers=2
    dtoverlay=vc4-fkms-v3d
    boot_delay
    kernel=vmlinux
    initramfs initrd.img followkernel
    ```
    3. Now run this command, also from system-boot partition:
    ```
    wget https://raw.githubusercontent.com/alessandrokonrad/Pi-Pool/master/scripts/fullGuide/auto_decompress_kernel
    sudo chmod +x auto_decompress_kernel
    ```
    4. Now go in the writable partition and go to /ect/apt/apt.conf.d/ and open up a new terminal inside:
    ```
    wget https://raw.githubusercontent.com/alessandrokonrad/Pi-Pool/master/scripts/fullGuide/999_decompress_rpi_kernel
    sudo chmod +x 999_decompress_rpi_kernel
    ```

7. Unplug the SSD from the PC and insert it into one of the USB 3.0 ports (the right ones) of the Pi. (You can remove the SD Card from the Pi, if it's still inserted)
8. Turn on the Pi and wait until you are at the login screen again:

- Username: ubuntu
- Password: ubuntu

9. Now you will be prompted to change password. Afterwards you should be successfully logged in your Ubuntu distribution!

For more information on how to run Ubuntu on SSD, check out <a href="https://www.raspberrypi.org/forums/viewtopic.php?t=278791">this</a> forum post.

## 3. Installing Cardano node
1. Download the start.sh script and execute it. This script will install all necessary dependencies for the Cardano node:
```
wget https://raw.githubusercontent.com/alessandrokonrad/Pi-Pool/master/scripts/fullGuide/start.sh
chmod +x start.sh
./start.sh
```
2. Install cardano-node and cardano-cli:
```
wget https://raw.githubusercontent.com/alessandrokonrad/Pi-Pool/master/scripts/fullGuide/installCardano.sh
chmod +x installCardano.sh
./installCardano.sh
```
