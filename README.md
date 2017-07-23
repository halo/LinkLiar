[![Version](https://img.shields.io/github/release/halo/LinkLiar.svg?style=flat&label=version)](https://github.com/halo/LinkLiar/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/halo/LinkLiar/blob/master/LICENSE.md)
[![Build Status](https://travis-ci.org/halo/LinkLiar.svg?branch=master)](https://travis-ci.org/halo/LinkLiar)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/halo/LinkLiar)

## Prevent your Mac from leaking MACs

This is an intuitive status menu application written in Swift to help you spoof the MAC addresses of your Wi-Fi and Ethernet interfaces.

![Screenshot](https://cdn.rawgit.com/halo/LinkLiar/master/docs/screenshot_2.1.0.png)

## Requirements

* macOS Sierra (see [releases](https://github.com/halo/LinkLiar/releases) for older versions)
* Administrator privileges (you will be asked for your root password **once**)

## Installation

Grap the latest release of [LinkLiar.app.zip](https://github.com/halo/LinkLiar/releases/latest), extract it, and place it into your `/Applications` directory.

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

MIT 2017 funkensturm. See [MIT-LICENSE](https://github.com/halo/LinkLiar/blob/master/LICENSE.md).
