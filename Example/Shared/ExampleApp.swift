//
//  ExampleApp.swift
//  Shared
//
//  Created by Alex Littlejohn on 27/01/2022.
//

import SwiftUI

@main
struct ExampleApp: App {
  var body: some Scene {
    WindowGroup {
      ExamplesView(store: initialStore(tasks: tasks))
    }
  }
}
