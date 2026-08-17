+++
title = "bootstrap"
weight = 1
+++

# Bootstrap

This homelab aims to take an infrastructure-as-code-first approach, meaning that any command we run,
infrastructure we provision, or services we deploy are documented, automated, and reproducible.
This page contains the instructions needed to set up these IaC tools.

> Note: the words "homelab" and "server" are used interchangibly in this documentation, refering to the device the homelab will be installed on.
> The word "client" is used to define whichever local device you are using to set up the homelab.

## Our first dependency: `mise`
We will be using [`mise`](https://mise.jdx.dev/) for much of the installation and configuration of the homelab.
mise is an environment variable manager, task runner, and package manager all in one.
The benefit of this approach is that we can define the dependencies we need, the variables to be used by our dependencies, and the tasks our dependecies should run, all in one interface.
To start, install `mise` on your client system. For example, `brew install mise`.
With `mise` installed, we can move on to installing our host operating system.

## Operating System
This host operating system of our server will be Debian.
To start, we'll need to download an Debian ISO image, flash it to a USB, and use said USB to install Debian onto our device.

First, move into the core directory:
```bash
cd homelab/core
```

In here, we can see our first `mise.toml` file. This is the file where all of our dependencies, tasks, and env vars are declared for use with `mise`.
Instead of creating one global `mise.toml` file in the root directory of our project, we will use multiple, smaller `mise.toml` files that are local to the task we are trying to complete.

Notice that inside this `mise.toml` file, we import a `.env` file to be used by `mise`.
`mise` will detect this `.env` file and automatically source it for us when we run any command with `mise`.
To start, let's make our own copy of the example `.env` file that we'll use to define our variables:
```bash
cp .env.example .env
```
Open up the `.env` file we just created in your editor.
The first variable we'll set is the version of debian we wish to use (`DEBIAN_VERSION`).
The latest stable release as of the time of writing is 13.5.0, so we'll assign our `DEBIAN_VERSION` variable to that value.
Alternatively, a list of stable release numbers for debian can be found [here](https://www.debian.org/releases/).

With our debian version set, we can now download the Debian image we'll flash to a USB drive.
From inside the same `core` directory, execute:
```bash
mise run download-debian-iso
```
This tells `mise` to "run" a task that we've defined inside `mise.toml` which in this case is the `download-debian-iso` tasks.
This task simply runs a `curl` command to download a debian image, using the `DEBIAN_VERSION` variable we defined in `.env`.
Once downloaded, it will save the image to a `debian.iso` file in the same directory.

Next, insert a USB drive into your client device (Debian manuals suggest one with 8GB or capacity or more).
We'll now use `balena`, a USB flash tool and one of our defined dependencies with `mise`, to flash our `debian.iso` image to our flash drive.
First, we need to install the dependency with `mise`:
```bash
mise install
```
This will install all declared dependencies inside our `mise.toml` file, one of which being `balena`.

Next up, run:
```bash
mise run flash-debian-usb
```
This launches balena with super-user privledges. This is required for flashing external devices.
After entering your password, `balena` will prompt you with which device you'd like to flash the image to.
