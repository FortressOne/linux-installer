# FortressOne Linux Installer

Currently tested on Ubuntu 18.04. Doesn't work on your system? [Raise an issue](https://github.com/FortressOne/linux-installer/issues/new).

## Installation

Download [FortressOne](https://github.com/FortressOne/linux-installer/releases/latest)

```bash
$ ./fortressone-0.2.0.run
```


## Development

### Dependencies: 

Requires [Makeself](https://makeself.io/) available in PATH.


### Build:

```bash
$ makeself.sh fortressone-0.2.0.run 'FortressOne - A QuakeWorld Team Fortress installer' ./setup.sh
```
