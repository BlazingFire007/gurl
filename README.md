# gurl 0.1.0

A go curl-like program to send http request from the command line.

- [gurl 0.1.0](#gurl-010)
  - [Installation:](#installation)
    - [Linux/Macos](#linuxmacos)
    - [Windows](#windows)
  - [Building](#building)

## Installation:
`gurl` is precompiled for several common platforms and architecturs.


### Linux/Macos
There is an install script for those on linux or macos.
```sh
curl https://raw.githubusercontent.com/BlazingFire007/gurl/main/install-nix.sh | bash
```

### Windows
There is a batch (cmd.exe) script for those on windows

## Building
You can build for your platform by cloning this repo, and running `go build .`

[You must have 'go' installed to build this tool.](https://go.dev/dl/)

An example of what that looks like on *nix systems:
```sh
git clone https://github.com/BlazingFire007/gurl.git
cd gurl
go build .
```