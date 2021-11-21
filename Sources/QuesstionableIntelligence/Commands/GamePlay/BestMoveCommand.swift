//
//  Created by Joseph Roque on 2021-11-20.
//

struct BestMoveCommand: RunnableCommand {

  static var name: String {
    "best-move"
  }

  static var aliases: [String] {
    ["best", "bm", "b"]
  }

  init?(_ name: String, input: String?) {
    guard input == nil || input?.isEmpty == true else { return nil }
  }

  func run(_ state: EngineState) throws {
    try state.printBestMove()
  }

}
