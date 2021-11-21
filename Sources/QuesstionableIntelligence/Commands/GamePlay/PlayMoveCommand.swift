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

  let move: Playable

  init?(_ name: String, input: String?) {
    guard let input = input, (4...5).contains(input.count) else { return nil }
    if ["w", "b"].contains(String(input.first!)) {
      guard let movement = Movement(cNotation: input) else { return nil }
      self.move = .chess(movement)
    } else {
      guard let movement = QuessMove(qNotation: input) else { return nil }
      self.move = .quess(movement)
    }
  }

  func run(_ state: EngineState) throws {
    let applied: Bool
    let notation: String
    switch move {
    case .quess(let quessMove):
      applied = state.game.apply(quessMove)
      notation = quessMove.qNotation
    case .chess(let movement):
      applied = state.game.apply(movement)
      notation = movement.cNotation
    }

    if applied {
      state.ctx.console.output("Played \(notation)".consoleText(.info))
    } else {
      state.ctx.console.output("Invalid move not accepted".consoleText(.error))
    }

    state.restartEvaluation()
    state.printBoard()
  }

}

extension PlayMoveCommand {

  enum Playable {
    case quess(QuessMove)
    case chess(Movement)
  }

}
