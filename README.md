<p align="center"><img width="80px" src="https://github.com/alessandrokonrad/Pi-Pool/blob/master/images/logo.svg"></img></p>

# Berry Pool

Berry is a Cardano Stakepool on Raspberry Pi. Check out my <a href="https://pipool.online">website</a> to see more about my stakepool. You can support me by just delegating to my pool. <br>
This repository is a guide to setup a stakepool on a Raspberry Pi by your own.

## Why this guide

Basically we have two different popular CPU architectures. Let's only consider 64-bit machines. Many of you know Intel and AMD. They primarily build their CPUs on a x86_64 architecture. Then there is ARM, which CPUs are built on the so called aarch64 architecture, and our Raspberry Pi has an aarch64 CPU. I don't want to dive any deeper in that, but the problem is, that the Cardano-Node setup is made for x86_64 machines and currently doesn't support aarch64 out of the box. The goal of this repository is to make it as easy as possible to run a Cardano-Node on Raspberry Pi.

## Prerequesites

- Raspberry Pi 4 4GB RAM or 8GB RAM (recommended)
- SSD (at least 20GB)
- microSD Card
- Eluteng SATA USB 3.0 Adapter (<a href="https://jamesachambers.com/raspberry-pi-4-usb-boot-config-guide-for-ssd-flash-drives/">list of other working adapters</a>)

## Getting started

### Upgrading the Bootloader

If your Pi already boots from SSD, you can skip this section.

1. Download <a href="https://www.raspberrypi.org/downloads/">Pi Imager</a> and install it
2. Insert the microSD Card in a Card Reader and plug it in your PC
3. Open Pi Imager and click "Choose OS" -> Misc utility images -> Raspberry Pi 4 EEPROM boot recovery
4. Click on "Choose SD Card" and select the microSD Card
5. Click "Write" and wait until finished
6. Now remove the microSD Card from the PC and plug it into the Pi
7. Connect a monitor to the Pi and turn it on
8. If you screen shows a <b>green</b> color, the bootloader had been successfully updated!
9. Remove the microSD from the Pi

### Install the Image
1. Download the latest <a href="https://github.com/alessandrokonrad/Pi-Pool/releases/download/1.0.0/ubuntu-cardano.img.gz">release</a>
2. Plug in the SSD in your PC
3. Open <a href="https://www.raspberrypi.org/downloads/">Pi Imager</a> and scroll down to "Use custom", select the downloaded release
4. Click on "Choose SD Card" and select the SSD
5. Click "Write" and wait until finished
6. You can now connect the SSD with the Pi and turn it on.

### Running the Image
These are the login credentials:
Username:<code>ada</code>
Password:<code>lovelace</code>

If you want to change the password, you can do this with <code>passwd</code>

### Running a Cardano-Node:

A sample node configuration folder is already preinstalled. These are the steps to follow:

```
mkdir pi-node
cd pi-node
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-config.json
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-byron-genesis.json
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-shelley-genesis.json
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-topology.json

```


### Starting a Cardano-Node:
```
cd pi-node
cardano-node run \
   --topology mainnet-topology.json \
   --database-path db \
   --socket-path db/socket \
   --host-addr 0.0.0.0 \
   --port 3000 \
   --config mainnet-config.json
```

That's it. Your node is now starting to sync!

### Monitoring
If you want to monitor your node, you can do this with the command <code>startMonitor</code>.

This will create a Grafana instance at port 5000. A custom dashboard is also already preinstalled. You can find it in the left panel under Dashboard -> Manage. You should find a Dashboard called "Raspberry Pi Node".

Use <code>stopMonitor</code> to stop the monitoring process.


### Updating the Cardano-Node

Currently there is no auto updater built in the Image. In order to update the version, this needs to be done manually.
To get the latest Cardano-Node version, join this <a href="https://t.me/joinchat/FeKTCBu-pn5OUZUz4joF2w">Telgram group</a>.
If there is one, download it and replace the the new binaries with the current ones under <code>~/.local/bin</code> (cardano-node and cardano-cli)


## Setup a Stake Pool

I can recommend <a href="https://cardano-community.github.io/guild-operators/#/">CNTools</a> (make sure the CNTools version is compatible with the Cardano-Node version).<br />
Otherwise I would follow the official guide of <a href="https://cardano-foundation-cardano.readthedocs-hosted.com/en/latest/getting-started/stake-pool-operators/index.html">cardano.org</a>

## Port forwarding

Go to your router settings. You can access them via your browser with the IP address of the router (e.g. 192.168.178.1 or if you have a FritzBox with fritz.box).
Then look for an option "Port Forwarding". Choose the IP address of your node(s) and open its/their port(s). Allow TCP. Then save it and that's it.
