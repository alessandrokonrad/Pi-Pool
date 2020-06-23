<p align="center"><img width="80px" src="https://github.com/alessandrokonrad/Pi-Pool/blob/master/images/logo.svg"></img></p>

# Pi Pool

Pi Pool is a Cardano Stakepool on Raspberry Pi. Check out my <a href="http://pi-pool.web.app">website</a> to see more about my stakepool. You can support me by just delegating to my pool. I'm definitely around at mainnet release of Shelley with a stakepool!<br>
This repository is a guide to setup a stakepool on a Raspberry Pi by your own.

## Why this guide
Basically we have two different popular CPU architectures. Let's only consider 64-bit machines. Many of you know Intel and AMD. They primarily build their CPUs in a x86_64 architecure. Then there is ARM, which CPUs are built in the so called aarch64 architecure, and our Raspberry Pi has an aarch64 CPU. I don't want to dive any deeper in that, but the problem is, that the Cardano-Node setup is made for x86_64 machines and currently doesn't support aarch64 out of the box. The goal of this repository is to make it as easy as possible to run a Cardano-Node on Raspberry Pi.

## Prerequesites

* Raspberry Pi 4 with 4 GB or 8 GB (recommended) RAM
* Ubuntu 20.04 LTS <b>64-bit</b> (Very easy to install with <a href="https://www.raspberrypi.org/downloads/">Pi Imager</a>)

## Getting started

This guide is currently for the Haskell Testnet (HTN)

1. First of all let's update and upgrade our Ubuntu:
```
sudo apt-get update
sudo apt-get upgrade
```

2. Install necessary dependencies:
```
sudo apt-get install build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 llvm -y

``` 
3. Get the Haskell platform:
```
sudo apt-get install -y haskell-platform
```
Now you should have GHC 8.6.5 and Cabal 2.4. You can check that with <code>ghc --version</code> and <code>cabal --version</code>.
GHC 8.6.5 is perfectly fine, but we need a higher Cabal version (3.0).<br>

4. Get Cabal 3.0 and remove Cabal 2.4:
```
wget https://github.com/alessandrokonrad/Pi-Pool/blob/master/aarch64/cabal
mv cabal ~/.local/bin
rm /usr/bin/cabal
```
5. Add the new Cabal to PATH:
Open the .bashrc file in your home directory and add at the bottom:
```
export PATH="~/.cabal/bin:$PATH"
export PATH="~/.local/bin:$PATH"
```
To make the the new PATH active you can either reboot the Pi or type <code>source .bashrc</code> from your home directory.
