//
//  View+AttachToRootView.swift
//  SwipeableFullscreenCover
//
//  Created by Demirhan Mehmet Atabey on 16.06.2024.
//

import SwiftUI

struct RootAttachmentView<Parent: View>: View {
  
  @State private var animate: Bool = false
  @State private var dragOffset: CGSize = .zero
  @ObservedObject var coordinator = SheetCoordinator()
  var parent: Parent
  
  var scaleEffectSize: CGFloat {
    min(1, (0.94) + (((dragOffset.height / UIScreen.main.bounds.height) * 0.1)))
  }
  
  var cornerRadiusSize: CGFloat {
    max(0, 20 + (((dragOffset.height / UIScreen.main.bounds.height) * 48)))
  }
  
  var body: some View {
    ZStack {
      if !coordinator.presentedSheets.isEmpty {
        Color.black.ignoresSafeArea()
      }
      parent
        .environmentObject(coordinator)
        .cornerRadius(coordinator.presentedSheets.isEmpty ? 0 : cornerRadiusSize)
        .scaleEffect(coordinator.presentedSheets.isEmpty ? 1 : scaleEffectSize, anchor: .bottom)
        .animation(.spring(response: 0.25, dampingFraction: 1.25), value: coordinator.presentedSheets.count)
        .animation(.spring(response: 0.25, dampingFraction: 1.25), value: animate)
        .overlay {
          Color.black.ignoresSafeArea().opacity((Double(1) - (scaleEffectSize * 1.5)))
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
                    var translation = val.translation.height * 0.95
                    if translation < 0 {
                      translation = 0
                    }
                    dragOffset = CGSize(width: val.translation.width, height: round(translation))
                  })
                  .onEnded { val in
                    print(val.velocity.height)
                    if val.translation.height > 400 || val.velocity.height > 300 {
                      coordinator.removeSheet(sheet)
                      dragOffset = .zero
                    } else {
                      animate.toggle()
                      dragOffset = .zero
                    }
                  }
              )
          }
          .zIndex(99)
          sheet.view
        }
      }
      .background(Color(UIColor.systemBackground))
      .cornerRadius(24)
      .offset(y: dragOffset.height)
      .animation(.default)
      .ignoresSafeArea()
      .transition(.move(edge: .bottom).animation(.default))
    }
  }
}

extension View {
  /// Attaches the swipeable fullscreencover to the root of the view. You should not use this modifier twice and if you attach to a different view, that view will act like root.
  public func attachFullscreenCoverToRootView() -> some View {
    RootAttachmentView(parent: self)
  }
}
