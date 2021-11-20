//
//  Created by Joseph Roque on 2021-11-20.
//

import Foundation

struct BulkPlayCommand: RunnableCommand {

  static var name: String {
    "bulk-play"
  }

  static var aliases: [String] {
    ["bp", "bulk"]
  }

  private let moves: [String]

  init?(_ name: String, input: String?) {
    guard let moves = input else { return nil }
    self.moves = moves.split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }
  }

  func run(_ state: EngineState) throws {
    self.moves.forEach { _ = state.game.apply($0) }
    state.printBoard()
    state.restartEvaluation()
  }

}
