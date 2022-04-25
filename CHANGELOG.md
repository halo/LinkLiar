# 3.2.0

* [FEATURE] If connected to a network, re-associate to the same SSID after a disconnect to change the MAC address.

# 3.1.0

* [BUGFIX] Disassociate from any connected network before trying to change MAC address. See [this issue](https://github.com/halo/LinkLiar/issues/44#issuecomment-1107443632).

# 3.0.3

* [BUGFIX] Make sure only allowed prefixes are ever in use when checking for re-randomization.

# 3.0.2

* [BUGFIX] Specifying a manual address as default now affects the interfaces that should use the default
* [BUGFIX] Properly disable/enable submenus if config file cannot be found/written

# 3.0.1 (beta)

* [BREAKING] Daemon executable directory moved from
             `/Library/Application Support/LinkDaemon`
             to
             `/Library/Application Support/io.github.halo.linkdaemon`
             as this is more future-proof.
* [USABILITY] Hide "Prefixes" submenu and reveal it only when holding the option key. I think it's only for advanced users.
* [DOCUMENTATION] Updated most images
* [DOCUMENTATION] Add Airpass to list of alternative apps
* [DOCUMENTATION] Make the background dark
* [DOCUMENTATION] Add section about prefix configuration

# 3.0.0 (alpha)

* [BREAKING] Configuration directory moved from
             `/Library/Application Support/LinkLiar/`
             to
             `/Library/Application Support/io.github.halo.LinkLiar`
             as this is more future-proof and I think the way Apple wants it.

* [FEATURE] Choose among vendors (and custom prefixes) to be used when randomizing MAC addresses #27
* [FEATURE] Do not show leakage icon for ignored interfaces #38
* [FEATURE] Show which MAC address was specified by default
* [FEATURE] Show paths to all relevant directories and files in developer menu
* [UPDATE] Update MAC prefixes of "popular" vendors

# 2.1.1

* [FEATURE] Added setting to start menu bar GUI on login

# 2.1.0

* [FEATURE] Added setting to anonymize MAC addresses in log files and menus
* [FEATURE] Updated screenshot in documentation
* [FEATURE] Completed in-app Help Book
* [BUGFIX] Disable submenus unless config file exists (to avoid confusion)

# 2.0.0

* [DEPRECATION] Dropped support for macOS El Capitan (and earlier), only Sierra and later supported
* [FEATURE] Rewrote the entire application from scratch using Swift 3
* [FEATURE] Moved logic that sets MAC addresses from userspace to root launch daemon
* [FEATURE] Default settings for unknown/future Interfaces
* [FEATURE] Re-randomize MAC addresses on sleep/logout
* [FEATURE] Proper application help
* [PERFORMANCE] The status menu does not halt, querying interfaces happens asynchronously

# 1.1.3

* [BUGFIX] Defining MAC addresses manually now works #23
* [BUGFIX] Can now copy and paste manual MAC addresses #23

# 1.1.2

* [DESIGN] Smaller application icon #19

# 1.1.1

* [BUGFIX] The "Debug Mode" menu item does not simply "overwrite" the "Help" menu item any more. Instead it pops up underneath when you hold the ⌥ key
* [FEATURE] Added "Launch at login" toggle #17

# 1.1.0

* [BUGFIX] Wi-Fi on en1, en2 or en3 are now included in automatic interface change detection (not only en0)
* [BUGFIX] Plugging in an external interface will cause a refresh of the icon after 7 and 15 seconds (the changing takes some time)
* [BUGFIX] Hiding iPhones etc. they are not spoofable #16
* [FEATURE] A warning will once be displayed to let you know you might loose your Internet connection #15
* [DESIGN] New application icon: lightning means "not leaking", person falling means "leaking"
* [PERFORMANCE] Less calls to ifconfig (NSTask) by filtering out Bluetooth, iPhone etc. in Objective-C right away

# 1.0.3

* [BUGFIX] Fixed some issues when Firewire or Bluetooth interfaces were mistakenly detected as spoofable when they, in reality, were not.

# 0.2.0

* Preference Pane for Mavericks

# 0.1.2

* Preference Pane for Mountain Lion

# 0.0.1

* Preference Pane for Lion
