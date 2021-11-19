//
//  Created by Joseph Roque on 2021-11-18.
//

import ConsoleKit
import Foundation

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)
var context = CommandContext(console: console, input: input)

var commands = Commands(enableAutocomplete: true)
commands.use(Quesstionable(), as: "play", isDefault: true)

do {
  let group = commands.group(help: "Play against the Quesstionable AI")
  try console.run(group, input: input)
} catch let error {
  console.error("\(error.localizedDescription)")
  exit(ExitCode.success.errorCode)
}

RunLoop.main.run()
