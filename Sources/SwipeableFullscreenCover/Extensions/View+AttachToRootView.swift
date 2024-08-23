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
  @State private var scrollOffset: CGFloat = .zero
  
  @ObservedObject var coordinator = SheetCoordinator()
  
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
              behavior: coordinator.configuration.swipeToDismissBehavior,
              offset: $scrollOffset) {
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
      .onChange(of: scrollOffset) { value in
        if value < 0 {
          scrollSheet(val: abs(value))
        }
      }
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
                print(val.velocity.height)
                if val.translation.height > 400 || abs(val.velocity.height) > 600 {
                  coordinator.removeSheet(sheet)
                  dragHeight = .zero
                } else {
                  animate.toggle()
                  withAnimation {
                    dragHeight = .zero
                  }
                }
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
}

extension View {
  /// Attaches the swipeable fullscreencover to the root of the view. You should not use this modifier twice and if you attach to a different view, that view will act like root.
  public func attachFullscreenCoverToRootView() -> some View {
    RootAttachmentView(parent: self)
  }
}
