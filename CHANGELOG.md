# 1.1.0

* [BUGFIX] Wi-Fi on en1, en2 or en3 are now included in automatic interface change detection (not only en0)
* [BUGFIX] Plugging in an external interface will cause a refresh of the icon after 7 and 15 seconds (the changing takes some time)
* [BUGFIX] Hiding iPhones etc. they are not spoofable
* [FEATURE] A warning will once be displayed to let you know you might loose your Internet connection
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