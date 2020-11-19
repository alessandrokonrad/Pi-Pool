<p align="center"><img width="80px" src="https://github.com/alessandrokonrad/Pi-Pool/blob/master/images/logo.svg"></img></p>

# Berry Pool

Berry is a Cardano Stakepool on Raspberry Pi. Check out my <a href="https://pipool.online">website</a> to see more about my stakepool. You can support me by just delegating to my pool. <br>
This repository is a guide to setup a stakepool on a Raspberry Pi by your own.

## Why this guide

Basically we have two different popular CPU architectures. Let's only consider 64-bit machines. Many of you know Intel and AMD. They primarily build their CPUs on a x86_64 architecture. Then there is ARM, which CPUs are built on the so called aarch64 architecture, and our Raspberry Pi has an aarch64 CPU. I don't want to dive any deeper in that, but the problem is, that the Cardano-Node setup is made for x86_64 machines and currently doesn't support aarch64 out of the box. The goal of this repository is to make it as easy as possible to run a Cardano-Node on Raspberry Pi.

## Prerequesites

- Raspberry Pi 4 with 8GB RAM (4GB version works only with Swap partition as extra RAM)
- Ubuntu 20.04 LTS <b>64-bit</b> (Very easy to install with <a href="https://www.raspberrypi.org/downloads/">Pi Imager</a>. For running Ubuntu on SSD, check below)

## Getting started

## Note
<b>IOG is currently improving the performance of the Cardano Node on ARM devices. Join this <a href="https://t.me/joinchat/FeKTCBu-pn5OUZUz4joF2w">group</a> to find out more.
I wouldn't recommend you building the node with the GHC 8.6.5 compiler for ARM any longer, like in this guide.</b>

This guide is for the Cardano mainnet!

#### 1. First of all let's update and upgrade our Ubuntu:

```
sudo apt-get update
sudo apt-get upgrade
```

You might reboot your Pi afterwards.

#### 2. Install necessary dependencies:

```
sudo apt-get install libsodium-dev build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 llvm -y

```

#### 3. Get the Haskell platform:

```
wget https://downloads.haskell.org/ghc/8.6.5/ghc-8.6.5-aarch64-ubuntu18.04-linux.tar.xz
tar -xf ghc-8.6.5-aarch64-ubuntu18.04-linux.tar.xz
rm ghc-8.6.5-aarch64-ubuntu18.04-linux.tar.xz
cd ghc-8.6.5/
./configure
sudo make install
cd ../
rm -r ghc-8.6.5/
```

Now you should have GHC 8.6.5. You can check that with <code>ghc --version</code>.

#### 4. Get Cabal 3.2:

```
wget https://github.com/alessandrokonrad/Pi-Pool/raw/master/aarch64/cabal3.2/cabal
chmod +x cabal
mkdir -p ~/.local/bin
mv cabal ~/.local/bin
```

You can also build your own Cabal binary for aarch64. Look <a href="/Crossbuilding.md">here</a>.

#### 5. Add the new Cabal to PATH:

Open the .bashrc file in your home directory and add at the bottom:

```
export PATH="~/.local/bin:$PATH"
```

To make the the new PATH active you can either reboot the Pi or type <code>source .bashrc</code> from your home directory. Then run:

```
cabal update
```

<br>

Now we are ready to build the Cardano-Node!

#### 6. Clone the cardano-node repository from GitHub and build it (this takes a while):

```
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
echo -e "package cardano-crypto-praos\n  flags: -external-libsodium-vrf" > cabal.project.local
git fetch --all --tags
git checkout tags/1.21.1
cabal build all
cp -p dist-newstyle/build/aarch64-linux/ghc-8.6.5/cardano-node-1.21.1/x/cardano-node/build/cardano-node/cardano-node ~/.local/bin/
cp -p dist-newstyle/build/aarch64-linux/ghc-8.6.5/cardano-cli-1.21.1/x/cardano-cli/build/cardano-cli/cardano-cli ~/.local/bin/

```

Finally we have our node. If everything worked fine, you should be able to type <code>cardano-cli</code> and <code>cardano-node</code>.

#### 7. Running a node:

We need first of all some configuration files:

```
mkdir pi-node
cd pi-node
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-config.json
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-byron-genesis.json
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-shelley-genesis.json
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-topology.json

```

You can change "ViewMode" from "SimpleView to "LiveView" in mainnet-config.json to get a fancy node monitor.<br>
Now start the node:

```
cardano-node run \
   --topology mainnet-topology.json \
   --database-path db \
   --socket-path db/socket \
   --host-addr 0.0.0.0 \
   --port 3000 \
   --config mainnet-config.json
```

That's it. Your node is now starting to sync!

<b>Note:</b> The syncing process for the mainnet blockchain can take really long. My node also crashed sometimes during the syncing process. Having a backup machine (x86_64) where you sync the node and just copy the db on the Raspberry Pi, makes it much easier and faster. As soon as the Pi is in sync it runs really smooth and just uses about 5% of the CPU.

## Update the node

If a new version is released, you can update your installed node with the following commands (replace `<version>` with the latest version number):

```
cd cardano-node
git fetch --all --tags
git checkout tags/<version>
cabal update
cabal build all
cp -p dist-newstyle/build/aarch64-linux/ghc-8.6.5/cardano-node-<version>/x/cardano-node/build/cardano-node/cardano-node ~/.local/bin/
cp -p dist-newstyle/build/aarch64-linux/ghc-8.6.5/cardano-cli-<version>/x/cardano-cli/build/cardano-cli/cardano-cli ~/.local/bin/
```

## Setup a stakepool

I might create a detailed guide soon, on how to register a stakepool. Anyway there are plenty tutorials out there: <br />
I can recommend <a href="https://cardano-community.github.io/guild-operators/Scripts/cntools.html">CNTools</a> (make sure the CNTools version is compatible with the Cardano-Node version).<br />
Otherwise I would follow the official guide of <a href="https://cardano-foundation-cardano.readthedocs-hosted.com/en/latest/getting-started/stake-pool-operators/index.html">cardano.org</a>

## Run Ubuntu on a SSD

#### Running Ubuntu from SSD, while booting from SD card:

1. Flash the Ubuntu image on your SSD and your SD card.
2. Now go to to the boot partition of the SD card and change in cmdline.txt the root path to: <code>root=/dev/sda2</code>
3. Insert the SD card into the Pi and the SSD into one of the USB 3.0 ports.
   This should boot now from the SD card, but the OS will run on the SSD then.

#### Running and booting from SSD (no need for SD card):

You can check that out:
<a href="https://www.raspberrypi.org/forums/viewtopic.php?t=278791">Directly boot from SSD</a>

#### Problems with running Ubuntu from USB 3.0:

<a href="https://jamesachambers.com/raspberry-pi-4-usb-boot-config-guide-for-ssd-flash-drives/">Adding quirks to your chipset, if it's not working</a>

## Cross-building

If you want to build your own Cabal binary for aarch64 or a different version of Cabal, follow <a href="/Crossbuilding.md">this</a> guide.

## Port forwarding

Go to your router settings. You can access them via your browser with the IP address of the router (e.g. 192.168.178.1 or if you have a FritzBox with fritz.box).
Then look for a option Port Forwarding. Choose the IP address of your relay node(s) and open its/their port(s). Allow TCP and UDP. Then save it and that's it.
