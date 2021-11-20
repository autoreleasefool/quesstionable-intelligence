//
//  Created by Joseph Roque on 2021-11-19.
//

import ConsoleKit
import Foundation
import QuessEngine

struct ShowCommand: RunnableCommand {

  static var name: String {
    "show"
  }

  static var aliases: [String] {
    ["s"]
  }

  private let compact: Bool

  init?(_ name: String, input: String?) {
    self.compact = ["compact", "c"].contains(input)
  }

  func run(_ state: EngineState) throws {
    state.printBoard(compact: compact)
  }

}
