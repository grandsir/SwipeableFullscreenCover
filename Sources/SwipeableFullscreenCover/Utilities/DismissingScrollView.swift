//
//  DismissingScrollView.swift
//
//
//  Created by Demirhan Mehmet Atabey on 23.08.2024.
//

import SwiftUI

public struct ScrollView<Content: View>: View {
  
  @EnvironmentObject var coordinator: SheetCoordinator
  
  public var dismissing: Bool = true
  public var showsIndicators: Bool = true
  @ViewBuilder public var content: () -> Content
  
  public init(
    dismissing: Bool,
    showsIndicators: Bool = true,
    content: @escaping () -> Content
  ) {
    self.dismissing = dismissing
    self.showsIndicators = showsIndicators
    self.content = content
  }
  
  public var body: some View {
    GeometryReader { geo in
      VStack {
        if dismissing {
          UIScrollViewWrapper(
            isScrollEnabled: $coordinator.isScrollEnabled,
            dragState: $coordinator.dragState,
            showsIndicators: showsIndicators
          ) {
            content()
          }
          .gesture(
            self.coordinator.isScrollEnabled ? nil : dragGesture(with: geo)
          )
        } else {
          SwiftUI.ScrollView(showsIndicators: showsIndicators) {
            content()
          }
        }
      }
    }
  }
  
  func dragGesture(with geometry: GeometryProxy) -> some Gesture {
    DragGesture()
      .onChanged { value in
        if value.translation.height < 0 {
          self.coordinator.dragState = .changed(value: value)
          coordinator.onDragChange(val: 0)
        } else {
          self.coordinator.dragState = .none
          coordinator.onDragChange(val: value.translation.height)
        }
      }
      .onEnded { value in
        if value.translation.height < 0 {
          self.coordinator.dragState = .ended(value: value)
          coordinator.onDragChange(val: 0)
          self.coordinator.isScrollEnabled = true
        } else {
          coordinator.onDragEnd(val: value)
          self.coordinator.dragState = .none
        }
      }
  }
  
}
