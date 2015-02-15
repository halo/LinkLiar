[![Version](https://img.shields.io/github/release/halo/LinkLiar.svg?style=flat&label=version)](https://github.com/halo/LinkLiar/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/halo/LinkLiar/blob/master/LICENSE.md)
[![Build Status](https://travis-ci.org/halo/LinkLiar.svg?branch=master)](https://travis-ci.org/halo/LinkLiar)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/halo/LinkLiar)

## Prevent your Mac from leaking MACs

This is an intuitive status menu application written in Objective-C to help you spoof the MAC addresses of your Wi-Fi and Ethernet interfaces.

![Screenshot](https://cdn.rawgit.com/halo/LinkLiar/master/doc/screenshot.png)

## Requirements

* Mac OS Yosemite (I have not tested it on older versions, it might work on Mavericks and Lion)
* Administrator privileges (you will be asked once for your root password)

## Installation

Grap the latest release [over here](https://github.com/halo/LinkLiar/releases/latest) and place it into your `/Applications` directory. You might want to add it to the applications which start each time you login (see System Preferences -> User -> Login Items).

Once on the [release page](https://github.com/halo/LinkLiar/releases/latest) you need to click on the link that looks like this:

![Download Image](https://cdn.rawgit.com/halo/LinkLiar/master/doc/download.png)

## Uninstall / Upgrading

Changing MAC addresses requires superuser privileges, for which a so called "HelperTool" will additionally be installed on your computer when you run LinkLiar for the first time. If you wish to remove the HelperTool, you need to run these commands:

```bash
sudo launchctl unload /Library/LaunchDaemons/com.funkensturm.LinkHelper.plist
sudo rm /Library/LaunchDaemons/com.funkensturm.LinkHelper.plist
sudo rm /Library/PrivilegedHelperTools/com.funkensturm.LinkHelper
```

## Limitations

* When your Wi-Fi (aka Airport) is turned off, you cannot change its MAC address. You need to turn it on first.
* There is basic support to automatically enforce the settings you specified. This is triggered e.g. when you plugin a USB Ethernet adapter. I do not want to poll every minute to see if anything changed so that LinkLiar can jump in and revert it to what you want to have. This is to save energy and it's good programming practice. I'm still figuring out how to trigger this more reliably, e.g. when you manually change the MAC address with `ifconfig`.
* Previous versions of LinkLiar were preference panes. While these are beautiful and not in your fase like status menu apps, there is a technical reason to why I don't use a preference pane. To run superuser commands with a HelperTool, the application needs to be signed - with preference panes, the application is "System Preferences" and it simply cannot be signed. Another advantage of the status menu is that you always see at once whether you're leaking a MAC address.

## Troubleshooting

* If the application does not start at all, run the `Console` app to see if there are any logs. Uninstall the HelperTool and try again.
* Sometimes it takes 1-2 seconds for the MAC address to change so if you're really fast with your mouse you might see outdated information in the status menu. Just close and open the menu again in that case.
* There exist MAC addresses which, for unknown reasons, cannot be applied to the interface. This may happen when you specify the address manually and e.g. choose a prefix which does not exist in the real world. You may try to use the "Random" function to make sure you always have a valid prefix.
* You may loose your Internet connection if you change a MAC address while the Interface is in use. This is not dangerous, though. Just plug the Ethernet cable out an in again or power the Wi-Fi off and on again.

## Future work

* Improve interface change detection
* Choose fake vendor from a list of MAC prefixes
* Easier upgrading of HelperTool
* Add a end-user logger for troubleshooting

## Development and credits

Feel free to browse through the code of this application. It's rather small and straight-forward.

The IconWork in the `Link/Images.xcassets` is from [Iconmonstr](http://iconmonstr.com).

## Special thanks

* To [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack) I was allowed to use.
* To **you** for starring my project on Github (the little star in the top right corner).

## License

MIT 2015 funkensturm. See [MIT-LICENSE](https://github.com/halo/LinkLiar/blob/master/LICENSE.md).
