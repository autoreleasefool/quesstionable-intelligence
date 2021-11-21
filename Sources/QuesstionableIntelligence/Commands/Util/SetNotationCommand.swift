//
//  Created by Joseph Roque on 2021-11-20.
//

struct SetNotationCommand: RunnableCommand {

  static var name: String {
    "set-notation"
  }

  static var aliases: [String] {
    ["mode"]
  }

  let notation: SupportedNotation

  init?(_ name: String, input: String?) {
    guard let input = input, let notation = SupportedNotation(rawValue: input) else { return nil }
    self.notation = notation
  }

  func run(_ state: EngineState) throws {
    state.preferredNotation = notation
  }

}
