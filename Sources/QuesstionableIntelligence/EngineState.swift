//
//  Created by Joseph Roque on 2021-11-18.
//

import Combine
import ConsoleKit
import Foundation
import QuessEngine

class EngineState {

  let game: GameState
  let ctx: CommandContext
  private let queue = DispatchQueue(label: "qi.EngineState")
  private let actor = Actor()

  var isRunning: Bool = true
  var depth: Int = 3

  private(set) var bestMove: Movement?
  private var cancellable: AnyCancellable?

  init(game: GameState, ctx: CommandContext) {
    self.game = game
    self.ctx = ctx

    self.cancellable = actor.bestMove
      .receive(on: queue)
      .sink { [weak self] movement in
        guard let self = self else { return }
        self.bestMove = movement
        if !self.actor.isRunning {
          self.printBestMove()
        }
      }

    self.restartEvaluation()
  }

  func printBoard(compact: Bool = false) {
    ctx.console.output(game.toString(compact: compact).consoleText(.plain))
  }

  func restartEvaluation() {
    if let endState = game.endState {
      ctx.console.output("Game over: \(endState)".consoleText(.success))
    } else {
      actor.evaluate(state: game, depth: depth)
    }
  }

  func printBestMove() {
    if let bestMove = bestMove {
      ctx.console.output("Best move: \(bestMove.notation)".consoleText(.success))
    } else {
      ctx.console.output("No moves found".consoleText(.error))
    }
  }

}
