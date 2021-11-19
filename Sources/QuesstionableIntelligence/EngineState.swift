//
//  Created by Joseph Roque on 2021-11-18.
//

import ConsoleKit
import QuessEngine

class EngineState {

  let state: GameState
  let ctx: CommandContext

  var isRunning: Bool = false

  init(state: GameState, ctx: CommandContext) {
    self.state = state
    self.ctx = ctx
  }

}
