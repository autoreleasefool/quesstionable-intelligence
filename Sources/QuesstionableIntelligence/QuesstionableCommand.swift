//
//  Created by Joseph Roque on 2021-11-15.
//

import ConsoleKit
import Foundation
import QuessEngine

struct Quesstionable: Command {

  struct Signature: CommandSignature {
    @Flag(name: "first", help: "Will play as first player")
    var isFirstPlayer: Bool

    init() {}
  }

  var help: String {
    "An AI for the game Quess"
  }

  func run(using context: CommandContext, signature: Signature) throws {
    let state = GameState()
    let engine = Engine(state: state, context: context)
    engine.runLoop()
  }

}
