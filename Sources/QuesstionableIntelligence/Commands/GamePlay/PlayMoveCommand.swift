//
//  Created by Joseph Roque on 2021-11-19.
//

import ConsoleKit
import QuessEngine

struct PlayMoveCommand: RunnableCommand {

  static var name: String {
    "play"
  }

  static var aliases: [String] {
    ["p"]
  }

  let movement: Movement

  init?(_ name: String, input: String?) {
    guard let input = input, let movement = Movement(notation: input) else { return nil }
    self.movement = movement
  }

  func run(_ state: EngineState) throws {
    if state.game.apply(movement) {
      state.ctx.console.output("Played \(movement.notation)".consoleText(.info))
    } else {
      state.ctx.console.output("Invalid move not accepted".consoleText(.error))
    }

    state.restartEvaluation()
    state.printBoard()
  }

}
