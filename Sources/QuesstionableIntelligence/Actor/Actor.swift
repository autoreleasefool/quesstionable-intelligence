//
//  Created by Joseph Roque on 2021-11-19.
//

import Combine
import Foundation
import QuessEngine

// swiftlint:disable all

class Actor {

  private let jobQueue = DispatchQueue(label: "qi.Actor.jobs", attributes: .concurrent)
  private let queue = DispatchQueue(label: "qi.Actor")

  private let stateCache: [Int: Int] = [:]
  private let evaluator = Evaluator()

  private var queue_isRunning: Bool = false
  private var queue_jobId = UUID()

  var isRunning: Bool {
    queue.sync { queue_isRunning }
  }

  private var currentJob: UUID {
    queue.sync { queue_jobId }
  }

  private let bestMoveSubject = CurrentValueSubject<(UUID, Movement?), Never>((UUID(), nil))
  var bestMove: AnyPublisher<Movement?, Never> {
    bestMoveSubject
      .eraseToAnyPublisher()
      .receive(on: queue)
      .filter { [weak self] id, movement in
        guard let self = self else { return false }
        return self.queue_jobId == id
      }
      .map { _, movement in
        movement
      }
      .eraseToAnyPublisher()


  }

  func evaluate(state originalState: GameState, depth: Int) {
    let id = UUID()
    queue.async {
      self.queue_isRunning = true
      self.queue_jobId = id
    }

    let history = originalState.history
    jobQueue.async {
      let state = GameState()
      history.forEach { state.apply($0) }

      self.bestMoveSubject.send((id, nil))
      self.jobQueue_minimaxRoot(id: id, depth: depth, state: state)
    }
  }

  private func jobQueue_minimaxRoot(id: UUID, depth: Int, state: GameState) {
    let maximize = state.currentPlayer == .white

    var bestMove = maximize ? Int.min : Int.max
    let moves = evaluator.rankMoves(in: state)
    var bestMoveFound = moves[0]

    for move in evaluator.rankMoves(in: state) {
      state.apply(move)
      guard let value = jobQueue_minimax(
        id: id,
        depth: depth - 1,
        state: state,
        alpha: Int.min,
        beta: Int.max,
        maximizingPlayer: !maximize
      ) else {
        return
      }
      state.undo()

      if maximize && value > bestMove {
        bestMove = value
        bestMoveFound = move
      } else if !maximize && value < bestMove {
        bestMove = value
        bestMoveFound = move
      }
    }

    queue.async {
      self.queue_isRunning = false
    }
    bestMoveSubject.send((id, bestMoveFound))
  }

  private func jobQueue_minimax(
    id: UUID,
    depth: Int,
    state: GameState,
    alpha xAlpha: Int,
    beta xBeta: Int,
    maximizingPlayer: Bool
  ) -> Int? {
    var alpha = xAlpha
    var beta = xBeta

    guard id == currentJob else { return nil }

    if state.isFinished {
      if state.winner == nil {
        return 0
      } else {
        return maximizingPlayer ? -Evaluator.mateValue : Evaluator.mateValue
      }
    }

    guard depth > 0 else {
      return evaluator.evaluateState(state)
    }

    if maximizingPlayer {
      var bestMove = Int.min
      for move in evaluator.rankMoves(in: state) {
        state.apply(move)
        guard var currentMove = jobQueue_minimax(id: id, depth: depth - 1, state: state, alpha: alpha, beta: beta, maximizingPlayer: !maximizingPlayer) else { return nil }

        // Downrank slower checkmates
        if currentMove > Evaluator.mateThreshold {
          currentMove -= 1
        } else if currentMove < -Evaluator.mateThreshold {
          currentMove += 1
        }

        bestMove = max(currentMove, bestMove)
        state.undo()
        alpha = max(alpha, bestMove)
        if beta <= alpha {
          return bestMove
        }
      }

      return bestMove
    } else {
      var bestMove = Int.max
      for move in evaluator.rankMoves(in: state) {
        state.apply(move)
        guard var currentMove = jobQueue_minimax(id: id, depth: depth - 1, state: state, alpha: alpha, beta: beta, maximizingPlayer: !maximizingPlayer) else { return nil }

        // Downrank slower checkmates
        if currentMove > Evaluator.mateThreshold {
          currentMove -= 1
        } else if currentMove < -Evaluator.mateThreshold {
          currentMove += 1
        }

        bestMove = min(bestMove, currentMove)
        state.undo()
        beta = min(beta, bestMove)
        if beta <= alpha {
          return bestMove
        }
      }
      return bestMove
    }
  }
}
