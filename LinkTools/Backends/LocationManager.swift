// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreLocation

// GUI apps cannot read the current SSID without Location Services.
// See https://developer.apple.com/forums/thread/732431?answerId=758611022#758611022
//
// And Daemons cannot inherit Location Services from their owning App.
// See https://developer.apple.com/forums/thread/739712?answerId=768907022#768907022
//
// The GUI doesn't really need the SSID. So that's okay.
// In fact, I would feel uncomfortable if end-users were forced to activate Location Services.
// But for troubleshooting I'd still like to be able to reference the manager.
struct LocationManager {
  static let instance = CLLocationManager()
}
