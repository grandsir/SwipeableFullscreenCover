//
//  View+AttachToRootView.swift
//  SwipeableFullscreenCover
//
//  Created by Demirhan Mehmet Atabey on 16.06.2024.
//

import SwiftUI

struct RootAttachmentView<Parent: View>: View {
  
  // MARK: - Wrapped Properties
  
  @Environment(\.colorScheme) var colorScheme
  @State private var animate: Bool = false
  
  @StateObject var coordinator = SheetCoordinator()
  
  // MARK: - Properties
  
  var parent: Parent
  
  
  var isPresented: Bool {
    return !coordinator.presentedSheets.isEmpty
  }
  var scaleEffectSize: CGFloat {
    min(1, (0.94) + (((coordinator.dragHeight / UIScreen.main.bounds.height) * 0.1)))
  }
  
  var opacitySize: CGFloat {
    if coordinator.presentedSheets.isEmpty {
      return 0.0
    }
    return min(1, 0.50 - (((coordinator.dragHeight / UIScreen.main.bounds.height))))
  }
  
  var cornerRadiusSize: CGFloat {
    max(0, 20 + (((coordinator.dragHeight / UIScreen.main.bounds.height) * 48)))
  }
  
  var overlayColor: Color {
    if colorScheme == .dark {
      Color.init(white: 0.20)
    } else {
      Color.black
    }
  }
  
  var body: some View {
    ZStack {
      parent
        .environmentObject(coordinator)
        .overlay {
          overlayColor
            .ignoresSafeArea()
            .opacity(opacitySize)
        }
        .cornerRadius(coordinator.presentedSheets.isEmpty ? 1 : cornerRadiusSize)
        .scaleEffect(coordinator.presentedSheets.isEmpty ? 1 : scaleEffectSize, anchor: .bottom)
        .animation(.spring(response: 0.25, dampingFraction: 1.25), value: coordinator.presentedSheets.count)
        .animation(.spring(response: 0.25, dampingFraction: 1.25), value: animate)
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
          sheet.view
          dragIndicatorView
        }
      }
      .frame(height: UIScreen.main.bounds.height)
      .background(coordinator.configuration.backgroundView)
      .cornerRadius(24)
      .offset(y: coordinator.dragHeight)
      .ignoresSafeArea()
      .transition(.move(edge: .bottom).animation(.default))
      .environmentObject(coordinator)
    }
  }
  
  @ViewBuilder
  var dragIndicatorView: some View {
    if let sheet = coordinator.presentedSheets.first {
      ZStack(alignment: .top) {
        Color.clear
        RoundedRectangle(cornerRadius: 16)
          .foregroundColor(Color(UIColor.systemGray2))
          .frame(width: 45, height: 6)
          .highPriorityGesture(
            DragGesture()
              .onChanged({ val in
                coordinator.onDragChange(val: val.translation.height)
              })
              .onEnded { val in
                coordinator.onDragEnd(val: val)
              }
          )
          .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
          .zIndex(99)
      }
    }
  }
}

extension View {
  /// Attaches `SwipeableFullscreenCover` to the root of the view. You should not use this modifier twice and if you attach to a different view, that view will act like root.
  /// - Important: `SwipeableFullscreenCover` will crash if you don't attach it on the root level.
  public func attachFullscreenCoverToRootView() -> some View {
    RootAttachmentView(parent: self)
  }
}
