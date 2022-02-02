//
//  ExamplesData.swift
//  Example
//
//  Created by Alex Littlejohn on 31/01/2022.
//

import Ducks
import Foundation
import SwiftUI

let tasks = [
  TaskItem(name: "Task 1"),
  TaskItem(name: "Task 2"),
  TaskItem(name: "Task 3"),
  TaskItem(name: "Task 4")
]

let animationColors = [
  Color.gray, .red, .blue, .orange, .green
]

struct TaskItem: Equatable, Identifiable, Comparable {
  static func < (lhs: TaskItem, rhs: TaskItem) -> Bool {
    !lhs.isComplete && rhs.isComplete
  }

  var id: UUID = UUID()
  var name: String
  var isComplete: Bool = false
}
