//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Alex Littlejohn on 02/02/2022.
//

import CombineSchedulers
import Ducks
import SwiftUI
import XCTest
@testable import Example

class ExampleTests: XCTestCase {

  var scheduler: TestSchedulerOf<DispatchQueue>!
  var store: Store<ExamplesAction, ExamplesState, ExamplesEnvironment>!
  var tasks: [TaskItem]!

  override func setUpWithError() throws {

    scheduler = DispatchQueue.test

    tasks = [
      TaskItem(name: "Task 1"),
      TaskItem(name: "Task 2"),
      TaskItem(name: "Task 3"),
      TaskItem(name: "Task 4")
    ]

    store = Store(
      reducer: examplesReducer,
      state: ExamplesState(tasks: tasks),
      environment: ExamplesEnvironment(
        queue: scheduler.eraseToAnyScheduler(),
        randomColor: { _ in Color.indigo },
        randomInt: { _ in 150 }
      )
    )
  }

  func testStateChanges() throws {

    // Given
    var matchingState = ExamplesState(tasks: tasks)
    XCTAssertEqual(store.state, matchingState)

    // When a task is toggled
    let id = try XCTUnwrap(matchingState.tasks.first?.id)
    store.send(ExamplesAction.toggle(id: id))

    // Mutate the matching state
    let index = try XCTUnwrap(matchingState.tasks.firstIndex(where:{ $0.id == id }))
    matchingState.tasks[index].isComplete.toggle()

    // The states match
    XCTAssertEqual(store.state.tasks, matchingState.tasks)

    // Mimic an advance in time
    scheduler.advance(by: 1)

    // Mutate the matching state
    matchingState.tasks.sort()

    // The states match
    XCTAssertEqual(store.state.tasks, matchingState.tasks)
  }
}
