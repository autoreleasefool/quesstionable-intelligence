//
//  Created by Joseph Roque on 2021-11-19.
//

import Combine
import Foundation
import QuessEngine

class Actor {

  private var jobId = UUID()

  private let queue = DispatchQueue(label: "qi.Actor")

  private let evaluator = Evaluator()

  private let bestMoveSubject = CurrentValueSubject<Movement?, Never>(nil)
  var bestMove: AnyPublisher<Movement?, Never> {
    bestMoveSubject.eraseToAnyPublisher()
  }

  func evaluate(state originalState: GameState) {
    let id = UUID()
    self.jobId = id
    let state = GameState()
    originalState.history.forEach { state.apply($0) }

    queue.async {
      guard id == self.jobId else { return }

      self.bestMoveSubject.send(nil)
      var hash = ZobristHash.shared.hash(forState: state)
    }
  }
}
