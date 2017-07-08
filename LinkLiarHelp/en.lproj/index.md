---
title: Introduction
---

# LinkLiar Helpbook

This is an intuitive status menu application written in Swift 3 to help you spoof the MAC addresses of your Wi-Fi and Ethernet interfaces.

![](screenshot_1.1.1.png)

## 📱 What is a MAC address and why would I change it?

When you turn on the Wi-Fi of your MacBook, it sends out a unique identifier - its MAC address.
Everyone nearby may freely collect this unique identifier and use it to track your movement.

Did you know that your phone does *not* send out its Wi-Fi identifier, but rather a random, fake one?
This is to protect you from the common practice of business to track your movements when you walk around in stores.

With LinkLiar you can achieve the same privacy for your MacBook.
Though the MAC address is hardwired into your Wi-Fi, you are free to modify which address is being "sent out".

## 🐷 Can I trust this app?

I'm just an independent developer who invested some time into creating this app.
It is open source, so you have full insight into how it works.
Click on the [Octocat](https://github.com/halo/LinkLiar) in the top right corner to find out more.

## 🔩 Is this app maintained?

Every now and then I find the time to develop new features.
If you'd like to motivate me, open this project on [Github](https://github.com/halo/LinkLiar)
and give it a ★ in the top right corner.

## 🔦 Which other apps are out there?

Your operating system already ships with the tool to change your MAC address.
You would just have to enter `ifconfig en0 ether aa:bb:cc:dd:ee:ff` in a Terminal.
But that's cumbersome, so tools like LinkLiar are supposed to make it easier for you.

For macOS, the more prominent graphical apps are [WiFiSpoof](https://wifispoof.com) (commercial)
and [MacDaddyX](http://www.deepthought.ws/software/software-osx-macdaddyx/) (free).
Then there is the command line tool [SpoofMAC](https://feross.org/spoofmac/),
which unfortunately has no graphical interface.

## 🕹 What's it with the name?

The MAC address is sometimes referred to as the *link-layer* identifier. You figure out the pun :]

## 💕 Special Thanks

The icon in the status bar was created by the never-tired
[iconmonstr](https://iconmonstr.com/about) (I slightly modified it).
