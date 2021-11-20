//
//  Created by Joseph Roque on 2021-11-19.
//

import Foundation

struct ExitCommand: RunnableCommand {

  static var name: String {
    "exit"
  }

  static var aliases: [String] {
    ["e"]
  }

  init?(_ name: String, input: String?) {}

  func run(_ state: EngineState) throws {
    throw ExitCode.success
  }

}
