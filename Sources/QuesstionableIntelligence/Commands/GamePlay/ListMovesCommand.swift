//
//  Created by Joseph Roque on 2021-11-19.
//

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
    let moves: String
    switch state.preferredNotation {
    case .quess:
      moves = try state.game
        .allPossibleMoves()
        .sorted()
        .quessify(withState: state.game)
        .map(\.qNotation)
        .joined(separator: "\n")
    case .chess:
      moves = state.game
        .allPossibleMoves()
        .sorted()
        .map(\.cNotation)
        .joined(separator: "\n")
    }
    state.ctx.console.output(moves.consoleText(.plain))
  }

}
