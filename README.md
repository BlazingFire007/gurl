# gurl 0.1.0

A go curl-like program to send http request from the command line.

- [gurl 0.1.0](#gurl-010)
  - [Why Should I Use This Instead of `curl` or `wget`?](#why-should-i-use-this-instead-of-curl-or-wget)
  - [Installation:](#installation)
    - [Linux/Macos](#linuxmacos)
    - [Windows](#windows)
  - [Usgae](#usgae)
    - [Options](#options)
  - [Bugs](#bugs)
  - [Building](#building)

## Why Should I Use This Instead of `curl` or `wget`?
You should not.

This was a fun project I made to better learn golang.

It has **no** advantages over `curl` or `wget` and several disadvantages.

## Installation:
`gurl` is precompiled for several common platforms and architecturs.

**NOTE: installation scripts likely won't work for ARM devices.**


### Linux/Macos
There is an install script for those on linux or macos.
```sh
curl https://raw.githubusercontent.com/BlazingFire007/gurl/main/install-nix.sh | bash
```

### Windows
There is a batch (cmd.exe) script for those on windows.
```bat
powershell -Command wget -UseBasicParsing -o install-windows.bat https://raw.githubusercontent.com/BlazingF
ire007/gurl/main/install-windows.bat && call install-windows.bat && del install-windows.bat
```

## Usgae
It's important to put any command line options **BEFORE** the url.

`gurl [options...] url`

Please do not use `-l, --loop` unless you really know what you're doing.
`-n, --times` will not wait for the previous request to complete before sending the next.

### Options
  - -A, --user-agent <name>
    - Send User-Agent <name> to server (default "gurl/0.1.0")
  - -H, --headers
    - Set headers: "HEADER1::VAL1|||HEADER2::VAL2"
  - -c, --cookie
    - set cookie from FILE
  - -d, --data
    - HTTP POST data
  - -h, --help
    - Show this screen
  - -i, --include
    - Include protocol response headers in the output
  - -l, --loop
    - Send request until program error. (DO NOT USE: IGNORES ERRORS)
  - -n, --times int
    - Number of times to send the request. Max 10,000. (WARNING: ASYNC) (default 1)
  - -o, --output
    - Write to file instead of stdout
  - -p, --post
    - Send POST request
  - -s, --silent
    - Silent
  - -u, --upload
    - Transfer local FILE to destination
  - -v, --version
    - Display the version of this program

## Bugs
Known bugs:
- downloading a file (with `-o, --output`) is very unstable and often does not work.
- urls that start with "http" cannot be prefixed with "http://" or "https://"

## Building
You can build for your platform by cloning this repo, and running `go build .`

[You must have 'go' installed to build this tool.](https://go.dev/dl/)

An example of what that looks like on *nix systems:
```sh
git clone https://github.com/BlazingFire007/gurl.git
cd gurl
go build .
```