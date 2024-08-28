//
//  SwipeableFullscreenCoverView.swift
//  SwipeableFullscreenCover
//
//  Created by Demirhan Mehmet Atabey on 13.06.2024.
//

import SwiftUI

internal typealias Configuration = SwipeableFullscreenCoverConfiguration

/// A wrapper to present swipable fullscreen cover.
public struct SwipeableFullscreenCoverView<SheetContent: View, P: View>: View {
  
  // MARK: - Wrapped Properties
  
  @StateObject var sheetCoordinator = SheetCoordinator()
  @ObservedObject    var configuration = Configuration()
  
  @Binding public var isPresented: Bool
  @State private var i: Bool = false
  
  // MARK: - Properties
  
  public var onDismiss: (() -> Void)?
  public let parent: P
  public let content: () -> SheetContent
  
  // MARK: - Body View
  
  @Environment(\.colorScheme) var colorScheme
  @State private var animate: Bool = false
  
  @StateObject var coordinator = SheetCoordinator()
  
  // MARK: - Properties
  
  var scaleEffectSize: CGFloat {
    min(1, (0.94) + (((coordinator.dragHeight / UIScreen.main.bounds.height) * 0.1)))
  }
  
  var opacitySize: CGFloat {
    if !isPresented {
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
  
  public var body: some View {
    ZStack {
      parent
    }
    .environmentObject(coordinator)
    .overlay {
      overlayColor
        .ignoresSafeArea()
        .opacity(opacitySize)
    }
    .cornerRadius(!isPresented ? 1 : cornerRadiusSize)
    .scaleEffect(!isPresented ? 1 : scaleEffectSize, anchor: .bottom)
    .animation(.spring(response: 0.25, dampingFraction: 1.25), value: !isPresented)
    .animation(.spring(response: 0.25, dampingFraction: 1.25), value: animate)
    .ignoresSafeArea()
    .overlay {
      sheetPresentation
    }
    .animation(.spring(response: 0.25, dampingFraction: 1.2), value: isPresented)

    .onChange(of: isPresented) { val in
      if !val {
        onDismiss?()
      }
    }
    .onChange(of: coordinator.present) { val in
      if !val {
        isPresented = false
        onDismiss?()
      }
    }
  }
  
  @ViewBuilder
  var sheetPresentation: some View {
    if isPresented {
      GeometryReader { geo in
        ZStack {
          content()
          dragIndicatorView
        }
      }
      .frame(height: UIScreen.main.bounds.height)
      .cornerRadius(24)
      .offset(y: coordinator.dragHeight)
      .ignoresSafeArea()
      .transition(.move(edge: .bottom).animation(.default))
      .environmentObject(coordinator)
    }
  }
  
  @ViewBuilder
  var dragIndicatorView: some View {
    if isPresented {
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
