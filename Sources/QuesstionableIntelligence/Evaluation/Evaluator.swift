//
//  Created by Joseph Roque on 2021-11-19.
//

import QuessEngine

class Evaluator {

  private static let pieceValue: [Piece.Class: Int] = [
    .triangle: 100,
    .circle: 320,
    .square: 500,
  ]

  // swiftlint:disable all

  private static let triangleValueWhite: [Int] = [
      5,  15, 25, 40, 30, 15,
     15,  25, 30, 35, 50, 30,
     25,  30, 40, 45, 35, 40,
     50,  25, 35, 40, 30, 25,
    -25,  50, 25, 30, 25, 15,
    -50, -25, 50, 25, 15,  5,
  ]

  private static let triangleValueBlack: [Int] = triangleValueWhite.reversed()

  private static let circleValueWhite: [Int] = [
    -50, -40, -30,  10,   5, -10,
    -40, -20,  15,  15,  10,   5,
    -30,  15,  20,  20,  15,  10,
    -30,  15,  20,  20,  15, -30,
    -40, -20,  15,  15, -20, -40,
    -50, -40, -30, -30, -40, -50,
  ]

  private static let circleValueBlack: [Int] = circleValueWhite.reversed()

  private static let squareValueWhite: [Int] = [
    -15, -15, -15,  -5,  -5,  -5,
    -10,   0,   0,   5,   5,  -5,
    -10,   0,   0,   0,   5,  -5,
    -10,   0,   0,   0,   0, -15,
    -10,  -5,   0,   0,   0, -15,
    -20, -10, -10, -10, -10, -15,
  ]

  private static let squareValueBlack: [Int] = squareValueWhite.reversed()

  // swiftlint:enable all

  func rankMoves(_ movements: [Movement], in state: GameState) -> [Movement] {
    movements
      .sorted { rankMovement($0, in: state) < rankMovement($1, in: state) }
      .reversed()
  }

  private func rankMovement(_ movement: Movement, in state: GameState) -> Int {
    // Moving a piece into the opponent's start zone is great
    // A weaker piece capturing a stronger piece is good
    // A stronger piece capturing a weaker piece is bad
    // Finally, consider the move from a good position to a bad position (or vice-versa)

    let player = movement.piece.owner
    let opponent = player.opponent

    if movement.to.isWithinStartZone(for: opponent) {
      return player == .white ? 100 : -100
    }

    let from = state.board.position(ofPiece: movement.piece)!
    let positionChangeValue = evaluatePiece(movement.piece, atPosition: movement.to) -
      evaluatePiece(movement.piece, atPosition: from)

    let captureValue: Int
    if let captured = state.board.pieceAt(movement.to) {
      captureValue = evaluateCapture(ofPiece: captured, byCaptor: movement.piece)
    } else {
      captureValue = 0
    }

    return player == .white ? (captureValue + positionChangeValue) : -(captureValue + positionChangeValue)
  }

  private func evaluateCapture(ofPiece capture: Piece, byCaptor piece: Piece) -> Int {
    Evaluator.pieceValue[capture.class]! - Evaluator.pieceValue[piece.class]!
  }

  private func evaluatePiece(_ piece: Piece, atPosition: Board.RankFile) -> Int {
    var mapping: [Int]
    switch piece.class {
    case .triangle: mapping = piece.owner == .white ? Evaluator.triangleValueWhite : Evaluator.triangleValueBlack
    case .square: mapping = piece.owner == .white ? Evaluator.squareValueWhite : Evaluator.squareValueBlack
    case .circle: mapping = piece.owner == .white ? Evaluator.circleValueWhite : Evaluator.circleValueBlack
    }

    return mapping[at.rawValue]
  }

  func evaluateState(_ state: GameState) -> Int {
    Board.RankFile.allCases.reduce(0) { total, position in
      guard let piece = state.board.pieceAt(position) else { return total }
      let value = Evaluator.pieceValue[piece.class]! + evaluatePiece(piece, atPosition: position)
      return total + (piece.owner == .white ? value : -value)
    }
  }

}
