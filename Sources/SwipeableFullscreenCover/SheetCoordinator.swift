//
//  SheetCoordinator.swift
//  SwipeableFullscreenCover
//
//  Created by Demirhan Mehmet Atabey on 29.05.2024.
//

import SwiftUI

struct SheetPresentation {
  var id: AnyEquatable
  var view: AnyView
  var onDismiss: (() -> ())?
}

extension SheetPresentation: Equatable {
  static public func == (lhs: SheetPresentation, rhs: SheetPresentation) -> Bool {
    return lhs.id == rhs.id
  }
}

/// An internal class that controls all SwipeableFullscreenCover's of app.
public class SheetCoordinator: NSObject, ObservableObject, UIScrollViewDelegate {
  
  @Published internal var present: Bool = true
  @Published internal var presentedSheets: [SheetPresentation] = []
  @Published internal var configuration: Configuration = .init()
  @Published internal var isScrollEnabled: Bool = false
  @Published internal var dragState: DragGesture.DragState = .none
  @Published internal var dragHeight: CGFloat = .zero

  private var onDismiss: (() -> ())?
  
  func removeSheet() {
    present = false
  }
  
  func onDragChange(val: CGFloat) {
    withAnimation(.linear(duration: 0.1)) {
      if val > 0 {
        dragHeight = val
      }
    }
  }
  
  func onDragEnd(val: DragGesture.Value) {
    if val.translation.height > 400 || abs(val.velocity.height) > 600 {
      self.isScrollEnabled = true
      removeSheet()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        withAnimation(.spring(response: 0.3, dampingFraction: 1.2)) {
          self.dragHeight = 0.0
          self.present = false
        }
      }
      
    } else {
      present = true
      withAnimation(.spring(response: 0.3, dampingFraction: 1.2)) {
        dragHeight = .zero
      }
    }
  }
}
