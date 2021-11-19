//
//  Created by Joseph Roque on 2021-11-18.
//

import ConsoleKit
import Foundation
import QuessEngine

protocol RunnableCommand {
  static var name: String { get }
  static var shortName: String? { get }

  init?(_ string: String)
  func run(_ state: EngineState) throws
}

struct RunnableCommandParser {

  static func from(input: String) -> RunnableCommand {
    let runnableCommands: [RunnableCommand.Type] = [
    ]

    let firstRunnableCommand = runnableCommands.firstNonNil { $0.init(input) }
    return firstRunnableCommand ?? InvalidCommand(input)
  }

}
