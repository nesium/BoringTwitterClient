/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Boring
import Foundation

extension String {
  init(freeingPlacesString rustString: UnsafeMutablePointer<CChar>) {
    defer { boring_destroy_string(rustString) }
    self.init(cString: rustString)
  }
}
