//
//  ExamplesView.swift
//  Shared
//
//  Created by Alex Littlejohn on 27/01/2022.
//

import Combine
import SwiftUI
import Ducks

struct ExamplesView: View {

  @ObservedObject var store: Store<ExamplesAction, ExamplesState, ExamplesEnvironment>

  var body: some View {
    List {
      Section("Tasks") {
        ForEach(store.state.tasks) { task in
          HStack {
            Button(action: { store.send(ExamplesAction.toggle(id: task.id)) }) {
              Image(systemName: task.isComplete ? "checkmark.square" : "square")
            }

            Text(task.name)
          }
        }
      }

      Section("Animations") {
        HStack {
          Rectangle()
            .fill(store.state.rectColor)
            .frame(width: store.state.rectSize.width, height: store.state.rectSize.height, alignment: .leading)
        }
        .onTapGesture {
            store.send(.animateRect, animation: .easeInOut)
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ExamplesView(
      store: initialStore()
    )
  }
}
