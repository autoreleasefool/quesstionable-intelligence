//
//  Created by Joseph Roque on 2021-11-18.
//

import QuessEngine

struct InvalidCommand: RunnableCommand {
  static var name: String {
    ""
  }

  static var shortName: String? {
    nil
  }

  let command: String

  init(_ command: String) {
    self.command = command
  }

  func run(_ state: EngineState) throws {
    state.ctx.console.output(.init(fragments: [
      .init(string: "\(command)", style: .init(isBold: true)),
      .init(string: " is not a valid command", style: .error),
    ]))
  }

}
