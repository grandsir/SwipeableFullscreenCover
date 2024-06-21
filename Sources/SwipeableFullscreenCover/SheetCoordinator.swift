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
internal class SheetCoordinator: ObservableObject {
  
  @Published var presentedSheets: [SheetPresentation] = []
  
  var content: AnyView = AnyView(EmptyView())
  var onDismiss: (() -> ())?
  
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
    print("Presented sheets: \(presentedSheets.count)")
  }
  
  
  func removeSheet(_ sheet: SheetPresentation) {
    presentedSheets.removeAll(where: { $0 == sheet })
    sheet.onDismiss?()
  }
}
