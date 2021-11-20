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

  private var cancellable: AnyCancellable?

  init(game: GameState, ctx: CommandContext) {
    self.game = game
    self.ctx = ctx

    self.cancellable = actor.bestMove
      .receive(on: queue)
      .sink { [weak self] movement in
        if let movement = movement {
          self?.ctx.console.output("Best move so far: \(movement.notation)")
        }
      }
  }

  func printBoard(compact: Bool = false) {
    ctx.console.output(game.toString(compact: compact).consoleText(.plain))
  }

  func restartEvaluation() {
    actor.evaluate(state: game)
  }

}
