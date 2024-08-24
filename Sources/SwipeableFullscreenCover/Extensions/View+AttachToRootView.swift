//
//  View+AttachToRootView.swift
//  SwipeableFullscreenCover
//
//  Created by Demirhan Mehmet Atabey on 16.06.2024.
//

import SwiftUI

struct RootAttachmentView<Parent: View>: View {
  
  // MARK: - Wrapped Properties
  
  @State private var animate: Bool = false
  @State private var dragHeight: CGFloat = .zero
  
  @ObservedObject var coordinator = SheetCoordinator()
  
  @State var isScrollEnabled: Bool = false
  @State var dragState: DragGesture.DragState = .none
  
  // MARK: - Properties
  
  var parent: Parent
  
  var scaleEffectSize: CGFloat {
    min(1, (0.94) + (((dragHeight / UIScreen.main.bounds.height) * 0.1)))
  }
  
  var opacitySize: CGFloat {
    if coordinator.presentedSheets.isEmpty {
      return 0.0
    }
    return min(1, 0.50 - (((dragHeight / UIScreen.main.bounds.height))))
  }
  
  var cornerRadiusSize: CGFloat {
    max(0, 20 + (((dragHeight / UIScreen.main.bounds.height) * 48)))
  }
  
  var body: some View {
    ZStack {
      parent
        .environmentObject(coordinator)
        .cornerRadius(coordinator.presentedSheets.isEmpty ? 1 : cornerRadiusSize)
        .scaleEffect(coordinator.presentedSheets.isEmpty ? 1 : scaleEffectSize, anchor: .bottom)
        .animation(.spring(response: 0.25, dampingFraction: 1.25), value: coordinator.presentedSheets.count)
        .animation(.spring(response: 0.25, dampingFraction: 1.25), value: animate)
        .overlay {
          Color.black.ignoresSafeArea().opacity(opacitySize)
        }
        .ignoresSafeArea()
        .overlay {
          sheetPresentation
        }
        .animation(.spring(response: 0.25, dampingFraction: 1.2), value: coordinator.presentedSheets.count)
    }
  }
  
  @ViewBuilder
  var sheetPresentation: some View {
    if let sheet = coordinator.presentedSheets.first {
      GeometryReader { geo in
        ZStack {
          dragIndicatorView
          GeometryReader { p in
            DismissingScrollView(
              isScrollEnabled: $isScrollEnabled,
              dragState: $dragState,
              behavior: coordinator.configuration.swipeToDismissBehavior,
              gesture: { geo in
              dragGesture(with: geo)
            }) {
              sheet.view
            }
          }
        }
      }
      .background(coordinator.configuration.backgroundView)
      .cornerRadius(24)
      .offset(y: dragHeight)
      .ignoresSafeArea()
      .transition(.move(edge: .bottom).animation(.default))
    }
  }
  
  @ViewBuilder
  var dragIndicatorView: some View {
    if let sheet = coordinator.presentedSheets.first {
      ZStack(alignment:. top) {
        Color.clear
        RoundedRectangle(cornerRadius: 16)
          .foregroundColor(Color(red: 0.8705, green: 0.8705, blue: 0.8705))
          .frame(width: 45, height: 6)
          .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
          .zIndex(99)
          .gesture(
            DragGesture()
              .onChanged({ val in
                scrollSheet(val: val.translation.height)
              })
              .onEnded { val in
                onDragEnd(val: val)
              }
          )
      }
      .zIndex(99)
    }
  }
  
  func scrollSheet(val: CGFloat) {
    withAnimation(.linear(duration: 0.05)) {
      if val > 0 {
        dragHeight = val
      }
    }
  }
  
  func onDragEnd(val: DragGesture.Value) {
    if val.translation.height > 400 || abs(val.velocity.height) > 600 {
      if let sheet = coordinator.presentedSheets.first {
        coordinator.removeSheet(sheet)
      }
      self.isScrollEnabled = true
    } else {
      withAnimation(.spring(response: 0.3, dampingFraction: 1.2)) {
        dragHeight = .zero
      }
    }
  }
  
  func dragGesture(with geometry: GeometryProxy) -> some Gesture {
    DragGesture()
      .onChanged { value in
        if value.translation.height < 0 {
          self.dragState = .changed(value: value)
          scrollSheet(val: 0)
        } else {
//          self.dragState = .none
          scrollSheet(val: value.translation.height)
        }
      }
      .onEnded { value in
        if value.translation.height < 0 {
          self.dragState = .ended(value: value)
          scrollSheet(val: 0)
          self.isScrollEnabled = true
        } else {
          onDragEnd(val: value)
          self.dragState = .none
        }
      }
  }
}

extension View {
  /// Attaches the swipeable fullscreencover to the root of the view. You should not use this modifier twice and if you attach to a different view, that view will act like root.
  public func attachFullscreenCoverToRootView() -> some View {
    RootAttachmentView(parent: self)
  }
}
