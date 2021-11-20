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

//     -----------------------------
//  6 |    |    |    | ▲1 | ●1 | ■  |
//  5 |    |    |    |    | ▲2 | ●2 |
//  4 |    |    |    |    |    | ▲3 |
//  3 | △1 |    |    |    |    |    |
//  2 | ○1 | △2 |    |    |    |    |
//  1 | □  | ○2 | △3 |    |    |    |
//     -----------------------------
//      A    B    C    D    E    F

extension Board {

  private func rankToString(_ rank: Int, compact: Bool) -> String {
    (0...5).map {
      let piece = pieceAt(x: $0, y: rank)
      let base = compact ? piece.baseAscii : piece.ascii
      return " \(base)".padding(toLength: compact ? 3 : 4, withPad: " ", startingAt: 0)
    }.joined(separator: "|")
  }

  func toString(compact: Bool = false) -> String {
    [
      "     -----------------------\(compact ? "" : "------") ",
      "  6 |\(rankToString(5, compact: compact))|",
      "  5 |\(rankToString(4, compact: compact))|",
      "  4 |\(rankToString(3, compact: compact))|",
      "  3 |\(rankToString(2, compact: compact))|",
      "  2 |\(rankToString(1, compact: compact))|",
      "  1 |\(rankToString(0, compact: compact))|",
      "     -----------------------\(compact ? "" : "------") ",
      "      \(["A", "B", "C", "D", "E", "F"].joined(separator: compact ? "   " : "    "))   ",
    ].joined(separator: "\n")
  }

}

extension GameState {

  func toString(compact: Bool = false) -> String {
    [
      historicalNotation().joined(separator: "; "),
      board.toString(compact: compact),
    ].joined(separator: "\n")
  }

}
