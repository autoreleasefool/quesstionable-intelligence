//
//  Created by Joseph Roque on 2021-11-18.
//

import ConsoleKit
import Foundation
import QuessEngine

class Engine {

  private let queue = DispatchQueue(label: "ca.josephroque.Quesstionable.Engine")

  private let state: EngineState

  init(state: GameState, context: CommandContext) {
    self.state = EngineState(state: state, ctx: context)
  }

  func runLoop() {
    queue.async {
      do {
        try self.playGame()
      } catch {
        if let exitCode = error as? ExitCode {
          exit(exitCode.errorCode)
        } else {
          exit(ExitCode.failure(reason: "\(error.localizedDescription)").errorCode)
        }
      }
    }
  }

  private func playGame() throws {
    guard state.isRunning else {
      throw ExitCode.success
    }

    let command = state.ctx.console.ask("Enter a command:".consoleText(.info))
    let commandToRun = RunnableCommandParser.from(input: command)
    try commandToRun.run(state)

    runLoop()
  }

}
