//
//  DismissingScrollView.swift
//
//
//  Created by Demirhan Mehmet Atabey on 23.08.2024.
//

import SwiftUI

public let swipeableFullscreenCoverCoordinateSpace: String = "SwipeableFullscreenCoverCoordinateSpace"

struct DismissingScrollView<Content: View>: View {
  var behavior: SwipeToDismissBehavior
  @Binding var offset: CGFloat
  @ViewBuilder var content: () -> Content
  
  private let coordinatespace = UUID()
  
  var body: some View {
    if case .enabled(let showsIndicators) = behavior {
      ScrollView(showsIndicators: showsIndicators) {
        content()
          .background(GeometryReader { geometry in
            Color.clear.preference(
              key: PreferenceKey.self,
              value: geometry.frame(in: .named(swipeableFullscreenCoverCoordinateSpace)).origin
            )
          })
          .onPreferenceChange(PreferenceKey.self) { position in
            offset = -position.y
          }
      }
      .coordinateSpace(name: swipeableFullscreenCoverCoordinateSpace)
    } else {
      content()
    }
  }
}

struct PreferenceKey: SwiftUI.PreferenceKey {
  static var defaultValue: CGPoint { .zero }
  
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
  }
}
