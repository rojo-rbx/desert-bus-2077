# Desert Bus 2077
[![GitHub Actions Build Status](https://github.com/rojo-rbx/secret-game/workflows/CI/badge.svg)](https://github.com/rojo-rbx/secret-game/actions?query=workflow%3ACI)
[![Roblox Place](https://img.shields.io/badge/Roblox-Place-red)](https://www.roblox.com/games/4756703682)

It is the year 2077. Drive a hoverbus in real time from Los Angeles to Sacramento.

Demo project for tools in the Rojo ecosystem. Some assembly required.

The primary goal of this project is to showcase a workflow with these tools:

* [Rojo](https://github.com/rojo-rbx/rojo), a build system
* [Foreman](https://github.com/rojo-rbx/foreman), a toolchain manager
* [Remodel](https://github.com/rojo-rbx/remodel), a deployment manager and multitool
* [Tarmac](https://github.com/rojo-rbx/tarmac), an asset manager

The secondary goal of this project is to create a terrible game.

## Building and Testing
Requires [Foreman](https://github.com/rojo-rbx/foreman) 1.0.0 or newer.

```bash
# Install required tools
foreman install

# Build place
rojo build -o Place.rbxlx

# Open place (Windows)
start Place.rbxlx

# Start Rojo server
rojo serve
```

## License
This project is available under the terms of the MIT license. See [LICENSE.txt](LICENSE.txt) or <https://opensource.org/licenses/MIT> for details.