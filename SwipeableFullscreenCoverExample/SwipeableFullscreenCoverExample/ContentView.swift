//
//  ContentView.swift
//  SwipeableFullscreenCoverExample
//
//  Created by Demirhan Mehmet Atabey on 17.06.2024.
//

import SwiftUI
import SwipeableFullscreenCover

struct ContentView: View {
  @State private var change: Bool = false
  @State private var present: Bool = false
  
  var body: some View {
    HStack {
      Button {
        change.toggle()
      } label: {
        Text("Fullscreen")
      }
      .swipeableFullscreenCover(id: FullScreenCoverTab.first, isPresented: $change) {
        Color.purple.ignoresSafeArea()
      }
      Button {
        present = true
      } label: {
        Text("Regular")
      }
    }
    .sheet(isPresented: $present) {
      Color.purple.ignoresSafeArea()
    }
    .foregroundColor(change ? .red : .blue)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.white)
    .ignoresSafeArea()
  }
}

struct FullScreenCoverTab {
  static let first = "first"
  static let second = "second"
  static let third = "third"
}

#Preview {
  ContentView()
}
