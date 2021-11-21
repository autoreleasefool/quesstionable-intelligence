//
//  Created by Joseph Roque on 2021-11-19.
//

import ConsoleKit
import QuessEngine

extension Piece.Class {

  var whiteAscii: String {
    switch self {
    case .square: return "□"
    case .circle: return "○"
    case .triangle: return "△"
    }
  }

  var blackAscii: String {
    switch self {
    case .square: return "■"
    case .circle: return "●"
    case .triangle: return "▲"
    }
  }

}

extension Piece {

  var baseAscii: String {
    switch owner {
    case .white: return self.class.whiteAscii
    case .black: return self.class.blackAscii
    }
  }

  var ascii: String {
    self.class.isUniquePerPlayer
      ? baseAscii
      : "\(baseAscii)\(index)"
  }

}

extension Optional where Wrapped == Piece {

  var baseAscii: String {
    switch self {
    case .none: return ""
    case .some(let wrapped): return wrapped.baseAscii
    }
  }

  var ascii: String {
    switch self {
    case .none: return ""
    case .some(let wrapped): return wrapped.ascii
    }
  }

}

extension Board {

  private func rankToString(_ rank: Int, compact: Bool) -> String {
    (0...5).map {
      let piece = pieceAt(x: $0, y: rank)
      let base = compact ? piece.baseAscii : piece.ascii
      return " \(base)".padding(toLength: compact ? 3 : 4, withPad: " ", startingAt: 0)
    }.joined(separator: "|")
  }

  func toString(notation: SupportedNotation, compact: Bool = false) -> String {
    let rows: [String]
    let columns: [String]
    switch notation {
    case .chess:
      rows = ["6", "5", "4", "3", "2", "1"]
      columns = ["A", "B", "C", "D", "E", "F", "G"]
    case .quess:
      rows = ["A", "B", "C", "D", "E", "F", "G"]
      columns = ["1", "2", "3", "4", "5", "6"]
    }

    return [
      "     -----------------------\(compact ? "" : "------") ",
      "  \(rows[0]) |\(rankToString(0, compact: compact))|",
      "  \(rows[1]) |\(rankToString(1, compact: compact))|",
      "  \(rows[2]) |\(rankToString(2, compact: compact))|",
      "  \(rows[3]) |\(rankToString(3, compact: compact))|",
      "  \(rows[4]) |\(rankToString(4, compact: compact))|",
      "  \(rows[5]) |\(rankToString(5, compact: compact))|",
      "     -----------------------\(compact ? "" : "------") ",
      "      \(columns.joined(separator: compact ? "   " : "    "))   ",
    ].joined(separator: "\n")
  }

}

extension GameState {

  func toString(notation: SupportedNotation, compact: Bool = false) -> String {
    let history: String
    switch notation {
    case .chess:
      history = historicalCNotation().joined(separator: "; ")
    case .quess:
      history = historicalQNotation().joined(separator: "; ")
    }

    return [
      history,
      board.toString(notation: notation, compact: compact || notation == .quess),
    ].joined(separator: "\n")
  }

}
