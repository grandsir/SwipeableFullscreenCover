//
//  DismissingScrollView.swift
//
//
//  Created by Demirhan Mehmet Atabey on 23.08.2024.
//

import SwiftUI

public let swipeableFullscreenCoverCoordinateSpace: String = "SwipeableFullscreenCoverCoordinateSpace"

struct DismissingScrollView<Content: View, G: Gesture>: View {
  
  @Binding var isScrollEnabled: Bool
  @Binding var dragState: DragGesture.DragState
  
  var behavior: SwipeToDismissBehavior
  var gesture: (GeometryProxy) -> G
  @ViewBuilder var content: () -> Content

  
  var body: some View {
    if case .enabled(let showsIndicators) = behavior {
      GeometryReader { geo in
        UIScrollViewWrapper(isScrollEnabled: $isScrollEnabled, dragState: $dragState) {
          content()
        }
        .gesture(
          self.isScrollEnabled ? nil : gesture(geo)
        )
        .coordinateSpace(name: swipeableFullscreenCoverCoordinateSpace)
      }
    } else {
      content()
    }
  }
}

public extension View {
  /// Applies the given transform if the given condition evaluates to `true`.
  /// - Parameters:
  ///   - condition: The condition to evaluate.
  ///   - transform: The transform to apply to the source `View`.
  /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
  
}
