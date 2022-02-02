//
//  TasksRedux.swift
//  Example
//
//  Created by Alex Littlejohn on 31/01/2022.
//

import Combine
import CombineSchedulers
import CoreGraphics
import Ducks
import Foundation
import SwiftUI

func initialStore(tasks: [TaskItem] = []) -> Store<ExamplesAction, ExamplesState, ExamplesEnvironment> {
  Store<ExamplesAction, ExamplesState, ExamplesEnvironment>(
    reducer: examplesReducer,
    state: ExamplesState(tasks: tasks),
    environment: ExamplesEnvironment(
      queue: DispatchQueue.main.eraseToAnyScheduler(),
      randomColor: { color in
        animationColors.filter { $0 != color }.randomElement() ?? color
      },
      randomInt: Int.random(in:)
    )
  )
}

enum ExamplesAction {
  case toggle(id: UUID)
  case toggleTask(task: TaskItem)
  case create(name: String)
  case rename(id: UUID, name: String)
  case delete(id: UUID)
  case sortTasks
  case animateRect
  case animateRect2
}

func toggleReducer( state: inout ExamplesState, id: UUID, environment: ExamplesEnvironment) -> AnyPublisher<ExamplesAction, Never> {

    if let index = state.tasks.firstIndex(where: { $0.id == id }) {
        state.tasks[index].isComplete.toggle()

        return Just(ExamplesAction.sortTasks)
            .delay(for: 1, scheduler: environment.queue.animation())
            .eraseToAnyPublisher()
    }

    return .none
}

/// This reducer mimics most of the style and behaviour of the TCA reducer but differs in a few key ways.
/// 1. It does not rely on an `Effect` struct to abstract away some of the sharp edges of Combine
/// 2. It currently lacks a concise mechanism for reducer composition.
let examplesReducer: Reducer<ExamplesAction, ExamplesState, ExamplesEnvironment> = { action, state, environment in

  switch action {
  case .toggle(id: let id):

    /// **Improvement point:**
    /// We can use [IdentifiedCollections](https://github.com/pointfreeco/swift-identified-collections) here to provide a more concise experience

      return toggleReducer(state: &state, id: id, environment: environment)
  case .create(name: let name):
    state.tasks.append(TaskItem(name: name))
      return .none
  case let .rename(id, name):

    /// Same as above regarding IdentifiedCollections
    if let index = state.tasks.firstIndex(where: { $0.id == id }) {
      state.tasks[index].name = name
    }
    return .none
  case .delete(id: let id):
    state.tasks.removeAll(where: { $0.id == id })
    return .none
  case .sortTasks:
    state.tasks.sort()
    return .none
  case .toggleTask(task: var task):
    task.isComplete.toggle()
    return .none
  case .animateRect:
    let color = environment.randomColor(state.rectColor)
    state.rectColor = color
    state.rectSize = CGSize(width: environment.randomInt(100...200), height: environment.randomInt(100...200))
    return .none
  case .animateRect2:
      return .none
  }
}

/// Describe the all state values necessary to represent our feature here
struct ExamplesState: Equatable {
  var tasks: [TaskItem] = []
  var rectColor: Color = .red
  var rectSize: CGSize = CGSize(width: 100, height: 100)
}

/// Collect all of our features dependencies here
struct ExamplesEnvironment {
  var queue: AnySchedulerOf<DispatchQueue>
  var randomColor: (_ existing: Color) -> Color
  var randomInt: (_ range: ClosedRange<Int>) -> Int
}
