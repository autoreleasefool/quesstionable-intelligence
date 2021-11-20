//
//  Created by Joseph Roque on 2021-11-18.
//

import ConsoleKit
import Foundation
import QuessEngine

protocol RunnableCommand {
  static var name: String { get }
  static var aliases: [String] { get }

  init?(_ name: String, input: String?)
  func run(_ state: EngineState) throws
}

struct RunnableCommandParser {

  static func from(input: String) -> RunnableCommand {
    let runnableCommands: [RunnableCommand.Type] = [
      PlayMoveCommand.self,
      ShowCommand.self,
      ListMovesCommand.self,
      SetDepthCommand.self,
      ExitCommand.self,
    ]

    let (name, input) = extractNameAndInput(from: input)

    let firstRunnableCommand = runnableCommands.firstNonNil { commandType -> RunnableCommand? in
      guard commandType.name == name || commandType.aliases.contains(name) else { return nil }
      return commandType.init(name, input: input)
    }
    return firstRunnableCommand ?? InvalidCommand(name, input: input)
  }

  private static func extractNameAndInput(from input: String) -> (String, String?) {
    if let separator = input.firstIndex(of: " ") {
      return (
        String(input.prefix(upTo: separator)),
        String(input.suffix(from: separator)).trimmingCharacters(in: .whitespacesAndNewlines)
      )
    } else {
      return (input, nil)
    }
  }

}
