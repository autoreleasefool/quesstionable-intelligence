//
//  Created by Joseph Roque on 2021-11-18.
//

import ConsoleKit
import QuessEngine

class EngineState {

  let game: GameState
  let ctx: CommandContext

  var isRunning: Bool = true

  init(game: GameState, ctx: CommandContext) {
    self.game = game
    self.ctx = ctx
  }

  func printBoard(compact: Bool = false) {
    ctx.console.output(game.toString(compact: compact).consoleText(.plain))
  }

}
