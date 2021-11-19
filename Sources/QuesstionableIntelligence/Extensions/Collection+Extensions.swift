//
//  Created by Joseph Roque on 2021-11-18.
//

import Foundation

extension Collection {

  func firstNonNil<T>(where predicate: (Element) -> T?) -> T? {
    for item in self {
      if let element = predicate(item) {
        return element
      }
    }

    return nil
  }

}
