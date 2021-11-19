//
//  Created by Joseph Roque on 2021-11-18.
//

import Foundation

enum ExitCode: LocalizedError {

  case success
  case failure(reason: String)

  var errorDescription: String? {
    switch self {
    case .success:
      return "No failures"
    case .failure(let reason):
      return reason
    }
  }

  var errorCode: Int32 {
    switch self {
    case .success:
      return 0
    case .failure:
      return 1
    }
  }

}
