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
  
  @Published internal var presentedSheets: [SheetPresentation] = []
  @Published internal var configuration: Configuration = .init()
  @Published internal var isScrollEnabled: Bool = false
  @Published internal var dragState: DragGesture.DragState = .none
  @Published internal var dragHeight: CGFloat = .zero

  private var onDismiss: (() -> ())?
  
  func updateSheetCoordinator<T: View, R: Equatable>(
    id: R,
    isPresented: Bool,
    content: () -> T,
    onDismiss: (() -> ())? = nil
  ) {
    if isPresented {
      presentedSheets.append(
        SheetPresentation(
          id: AnyEquatable(id),
          view: AnyView(erasing: content()),
          onDismiss: onDismiss
        )
      )
    } else {
      presentedSheets.removeAll { p in
        p.id == AnyEquatable(id)
      }
    }
  }
  
  func updateSheetConfiguration(
    configuration: Configuration
  ) {
    self.configuration = configuration
  }
  
  func removeSheet(_ sheet: SheetPresentation) {
    presentedSheets.removeAll(where: { $0 == sheet })
    sheet.onDismiss?()
  }
  
  func onDragChange(val: CGFloat) {
    withAnimation(.linear(duration: 0.05)) {
      if val > 0 {
        dragHeight = val
      }
    }
  }
  
  func onDragEnd(val: DragGesture.Value) {
    if val.translation.height > 400 || abs(val.velocity.height) > 600 {
      if let sheet = presentedSheets.first {
        removeSheet(sheet)
      }
      self.isScrollEnabled = true
      dragHeight = 0.0
    } else {
      withAnimation(.spring(response: 0.3, dampingFraction: 1.2)) {
        dragHeight = .zero
      }
    }
  }
}
