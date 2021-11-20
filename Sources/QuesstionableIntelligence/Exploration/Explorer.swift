//
//  Created by Joseph Roque on 2021-11-19.
//

import Foundation
import QuessEngine

protocol Explorer {
  func explore(state: GameState) -> [Movement]
}
