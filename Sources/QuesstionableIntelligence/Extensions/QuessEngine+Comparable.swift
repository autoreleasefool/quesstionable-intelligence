//
//  Created by Joseph Roque on 2021-11-19.
//

import QuessEngine

extension Player: Comparable {

  public static func < (lhs: Player, rhs: Player) -> Bool {
    switch (lhs, rhs) {
    case (.white, .white): return false
    case (.white, _): return true
    case (.black, _): return false
    }
  }

}

extension Piece.Class: Comparable {

  public static func < (lhs: Piece.Class, rhs: Piece.Class) -> Bool {
    switch (lhs, rhs) {
    case (.circle, .circle): return false
    case (.circle, _): return true
    case (.triangle, .triangle): return false
    case (.triangle, _): return true
    case (.square, _): return false
    }
  }

}

extension Piece: Comparable {

  public static func < (lhs: Piece, rhs: Piece) -> Bool {
    if lhs.owner == rhs.owner {
      if lhs.class == rhs.class {
        return lhs.index < rhs.index
      } else {
        return lhs.class < rhs.class
      }
    } else {
      return lhs.owner < rhs.owner
    }
  }

}

extension Board.RankFile: Comparable {

  public static func < (lhs: Board.RankFile, rhs: Board.RankFile) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }

}

extension Movement: Comparable {

  public static func < (lhs: Movement, rhs: Movement) -> Bool {
    if lhs.piece == rhs.piece {
      return lhs.to < rhs.to
    } else {
      return lhs.piece < rhs.piece
    }
  }

}
