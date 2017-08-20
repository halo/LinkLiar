[![Version](https://img.shields.io/github/release/halo/LinkLiar.svg?style=flat&label=version)](https://github.com/halo/LinkLiar/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/halo/LinkLiar/blob/master/LICENSE.md)
[![Build Status](https://travis-ci.org/halo/LinkLiar.svg?branch=master)](https://travis-ci.org/halo/LinkLiar)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/halo/LinkLiar)

## Prevent your Mac from leaking MACs

This is an intuitive status menu application written in Swift to help you spoof the MAC addresses of your Wi-Fi and Ethernet interfaces.

It is free as in open-source. Should you like to motivate me, you may click on the ✭ in the top-right corner.

![Screenshot](https://cdn.rawgit.com/halo/LinkLiar/master/docs/screenshot_2.1.0.png)

## Documentation

The end-user documentation is located at [halo.github.io/LinkLiar](http://halo.github.io/LinkLiar).

What you're looking at right now is the technical documentation.

There is also a source-code documentation in progress, see `bin/docs` for inspiration.

## Requirements

* macOS Sierra (see [releases](https://github.com/halo/LinkLiar/releases) for older versions)
* Administrator privileges (you will be asked for your root password **once**)

## Installation

If you have [https://brew.sh](Homebrew), just run `brew cask install linkliar`.

Alternatively, grab the latest release of [LinkLiar.app.zip](https://github.com/halo/LinkLiar/releases/latest), extract it,
and place it into your `/Applications` directory (see [installation](http://halo.github.io/LinkLiar/installation.html) for help).

## Limitations

* When your Wi-Fi (aka Airport) is turned off, you cannot change its MAC address. You need to turn it on first.
* If you change a MAC address while the interface is connected, you will briefly loose connection.

## Troubleshooting

You can create this logfile and whenever it exists, all  LinkLiar components will write to it:

```bash
touch "/Library/Application Support/LinkLiar/linkliar.log"
```

Delete the log file again to silence logging.

Once LinkLiar is started and the menu is visible, you can hold the ⌥ Option key for advanced options. This is only intended for developers.

## Future work

* Add badge with test coverage to README
* Nicer GUI for specifying a MAC address manually (with option to randomize)

## Thanks

* The icon in `Link/Images.xcassets` is from [Iconmonstr](http://iconmonstr.com).

## License

MIT 2017 halo. See [MIT-LICENSE](https://github.com/halo/LinkLiar/blob/master/LICENSE.md).
