//
//  Created by Joseph Roque on 2021-11-19.
//

import Foundation

struct ListMovesCommand: RunnableCommand {

  static var name: String {
    "list-moves"
  }

  static var aliases: [String] {
    ["list", "lm", "l"]
  }

  init?(_ name: String, input: String?) {
    guard input == nil || input?.isEmpty == true else { return nil }
  }

  func run(_ state: EngineState) throws {
    let moves = state.game
      .allPossibleMoves()
      .sorted()
      .map(\.notation)
      .joined(separator: "\n")
    state.ctx.console.output(moves.consoleText(.plain))
  }

}
