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
        UIScrollViewWrapper(
          isScrollEnabled: $isScrollEnabled,
          dragState: $dragState,
          showsIndicators: showsIndicators
        ) {
          content()
        }
        .simultaneousGesture(
          self.isScrollEnabled ? nil : gesture(geo)
        )
        .coordinateSpace(name: swipeableFullscreenCoverCoordinateSpace)
      }
    } else {
      content()
    }
  }
}
