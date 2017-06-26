[![Version](https://img.shields.io/github/release/halo/LinkLiar.svg?style=flat&label=version)](https://github.com/halo/LinkLiar/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/halo/LinkLiar/blob/master/LICENSE.md)
[![Build Status](https://travis-ci.org/halo/LinkLiar.svg?branch=master)](https://travis-ci.org/halo/LinkLiar)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/halo/LinkLiar)

## Prevent your Mac from leaking MACs

This is an intuitive status menu application written in Objective-C to help you spoof the MAC addresses of your Wi-Fi and Ethernet interfaces.

If you like this project, feel free to give it a ★ in the top right corner.

![Screenshot](https://cdn.rawgit.com/halo/LinkLiar/master/doc/screenshot_1.1.1.png)

## Requirements

* Mac OS Yosemite
* Administrator privileges (you will be asked for your root password **once**)

## Installation

Grap the latest release of [LinkLiar.app.zip](https://github.com/halo/LinkLiar/releases/latest), extract it, and place it into your `/Applications` directory.

Hint: Press the ⌥ key while the LinkLiar menu is open to choose whether you want it to "Launch at startup".

## Uninstall / Upgrading

Changing MAC addresses requires superuser privileges, for which a so called "HelperTool" will additionally be installed on your computer when you run LinkLiar for the first time. If you wish to remove the HelperTool, you need to run these commands:

```bash
sudo launchctl unload /Library/LaunchDaemons/com.funkensturm.LinkHelper.plist
sudo rm /Library/LaunchDaemons/com.funkensturm.LinkHelper.plist
sudo rm /Library/PrivilegedHelperTools/com.funkensturm.LinkHelper
```

## Limitations

* When your Wi-Fi (aka Airport) is turned off, you cannot change its MAC address. You need to turn it on first.
* Previous versions of LinkLiar were preference panes. While these are beautiful and not in your face like status menu apps, there is a technical reason to why I don't use a preference pane any more. To run superuser commands with a HelperTool, the application needs to be signed - with preference panes, the application is "System Preferences" and it simply cannot be signed. Another advantage of the status menu is that you always see at once whether you're leaking a MAC address.

## Troubleshooting

Once LinkLiar is started, you can hold the ⌥ key to activate debug mode. The Logs will appear in the `/Applications/Utilities/Console` app.

If the application does not even start, you may turn on debug logging manually by runing the following command in a Terminal:

```bash
defaults write com.funkensturm.Link.plist debug debug  # <- Yes, twice "debug"
```

* If the "Authorize LinkLayer..." menu item does not disappear, uninstall the curent HelperTool manually (see "Uninstall").
* Sometimes it takes 1-2 seconds for the MAC address to change so if you're really fast with your mouse you might see outdated information in the status menu. Just close and open the menu again in that case. In rare occasions this can cause a crash.
* There exist MAC addresses which, for unknown reasons, cannot be applied to the interface. This may happen when you specify the address manually and e.g. choose a prefix which does not exist in the real world. You may try to use the "Random" function to make sure you always have a valid prefix.
* You may loose your Internet connection if you change a MAC address while the Interface is in use. This is not dangerous, though. Just plug the Ethernet cable out an in again or power the Wi-Fi off and on again.

## Future work

* Choose fake vendor from a list of MAC prefixes
* Easier upgrading of HelperTool

## Thanks
* https://github.com/raywenderlich/swift-style-guide

* The IconWork in the `Link/Images.xcassets` is from [Iconmonstr](http://iconmonstr.com).
* @ianyh made [the code](https://github.com/ianyh/IYLoginItem) to toggle the "Launch at login".

## License

MIT 2017 funkensturm. See [MIT-LICENSE](https://github.com/halo/LinkLiar/blob/master/LICENSE.md).
