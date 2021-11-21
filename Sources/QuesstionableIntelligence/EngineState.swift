//
//  Created by Joseph Roque on 2021-11-18.
//

import ConsoleKit
import Foundation
import QuessEngine

class EngineState {

  let game: GameState
  let ctx: CommandContext
  private let queue = DispatchQueue(label: "qi.EngineState")
  private let actor = Actor()

  var isRunning: Bool = true
  var depth: Int = 4
  var preferredNotation: SupportedNotation = .chess

  private(set) var bestMove: Movement?

  init(game: GameState, ctx: CommandContext) {
    self.game = game
    self.ctx = ctx

    self.actor.delegate = self
    self.restartEvaluation()
  }

  func printBoard(compact: Bool = false) {
    ctx.console.output(game.toString(notation: preferredNotation, compact: compact).consoleText(.plain))
  }

  func restartEvaluation() {
    if let endState = game.endState {
      ctx.console.output("Game over: \(endState)".consoleText(.success))
    } else {
      actor.evaluate(state: game, depth: depth)
    }
  }

  func printBestMove() throws {
    if let bestMove = bestMove {
      let notation: String
      switch preferredNotation {
      case .chess:
        notation = bestMove.cNotation
      case .quess:
        notation = try bestMove.quessify(withState: game).qNotation
      }
      ctx.console.output("Best move: \(notation)".consoleText(.success))
    } else {
      ctx.console.output("No moves found".consoleText(.error))
    }
  }

}

extension EngineState: ActorDelegate {

  func actor(_ actor: Actor, didDetermineBestMove bestMove: Movement?) {
    self.bestMove = bestMove
    if !actor.isRunning {
      try? self.printBestMove()
    }
  }

}
