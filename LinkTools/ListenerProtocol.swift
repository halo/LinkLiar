// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

@objc(ListenerProtocol)

protocol ListenerProtocol {
  func version(reply: @escaping (String) -> Void)

  func createConfigDirectory(reply: @escaping (Bool) -> Void)
  func removeConfigDirectory(reply: @escaping (Bool) -> Void)

//  func install(pristineDaemonExecutablePath: String, reply: @escaping (Bool) -> Void)
//  func uninstall(reply: @escaping (Bool) -> Void)

//  func installDaemon(pristineDaemonExecutablePath: String, reply: @escaping (Bool) -> Void)
//  func activateDaemon(reply: @escaping (Bool) -> Void)
//  func deactivateDaemon(reply: @escaping (Bool) -> Void)
//  func uninstallDaemon(reply: @escaping (Bool) -> Void)
//
//  func uninstallHelper(reply: @escaping (Bool) -> Void)
}
