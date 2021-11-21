//
//  Created by Joseph Roque on 2021-11-20.
//

import ConsoleKit
import Foundation
import QuessEngine

struct SetDepthCommand: RunnableCommand {

  static var name: String {
    "set-depth"
  }

  static var aliases: [String] {
    ["sd", "d", "depth"]
  }

  let depth: Int

  init?(_ name: String, input: String?) {
    guard let input = input, let depth = Int(input) else { return nil }
    self.depth = depth
  }

  func run(_ state: EngineState) throws {
    state.depth = depth
    state.restartEvaluation()
  }

}
