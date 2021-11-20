//
//  Created by Joseph Roque on 2021-11-18.
//

import ConsoleKit
import QuessEngine

struct InvalidCommand: RunnableCommand {

  static var name: String {
    ""
  }

  static var shortName: String? {
    nil
  }

  let command: String

  init(_ name: String, input: String?) {
    if let input = input {
      self.command = "\(name) \(input)"
    } else {
      self.command = name
    }
  }

  func run(_ state: EngineState) throws {
    state.ctx.console.output(ConsoleText(fragments: [
      ConsoleTextFragment(string: "\(command)", style: ConsoleStyle(isBold: true)),
      ConsoleTextFragment(string: " is not a valid command", style: .error),
    ]))
  }

}
