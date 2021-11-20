//
//  Created by Joseph Roque on 2021-11-19.
//

import Combine
import QuessEngine

class QuesstionableIntelligence {

  private let cache = StateCache()

  private let bestMoveSubject = CurrentValueSubject<Movement?, Never>(nil)
  var bestMove: AnyPublisher<Movement?, Never> {
    bestMoveSubject.eraseToAnyPublisher()
  }

  func evaluate(state: GameState) {
    bestMoveSubject.send(nil)
//    var hash = ZobristHash.shared.hash(forState: state)

  }
}
