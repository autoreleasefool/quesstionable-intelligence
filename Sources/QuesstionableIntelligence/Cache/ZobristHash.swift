//
//  Created by Joseph Roque on 2021-11-19.
//

import Foundation
import QuessEngine

class ZobristHash {

  static let shared = ZobristHash()

  private var hashTable: [Int: [Piece.Class: [Player: Int]]]

  // swiftlint:disable identifier_name

  init() {
    self.hashTable = [:]
    for i in Board.RankFile.allCases {
      self.hashTable[i.rawValue] = [:]
      for j in Piece.Class.allCases {
        self.hashTable[i.rawValue]![j]![.white] = UUID().hashValue
        self.hashTable[i.rawValue]![j]![.black] = UUID().hashValue
      }
    }
  }

  func hash(forState state: GameState) -> Int {
    var h = 0
    for i in Board.RankFile.allCases {
      if let piece = state.board.pieceAt(i) {
        h = h ^ hashTable[i.rawValue]![piece.class]![piece.owner]!
      }
    }
    return h
  }

  func update(
    hash: Int,
    byMoving piece: Piece,
    from: Board.RankFile,
    to: Board.RankFile,
    in state: GameState
  ) -> Int {
    var h = hash ^ hashTable[from.rawValue]![piece.class]![piece.owner]!
    h = h ^ hashTable[to.rawValue]![piece.class]![piece.owner]!
    if let captured = state.board.pieceAt(to) {
      h = h ^ hashTable[to.rawValue]![captured.class]![captured.owner]!
    }
    return h
  }

  // swiftlint:enable identifier_name

}
