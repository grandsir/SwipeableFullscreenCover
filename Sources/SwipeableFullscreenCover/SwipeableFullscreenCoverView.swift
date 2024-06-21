//
//  SwipeableFullscreenCoverView.swift
//  SwipeableFullscreenCover
//
//  Created by Demirhan Mehmet Atabey on 13.06.2024.
//

import SwiftUI

/// A wrapper to present swipable fullscreen cover.
public struct SwipeableFullscreenCoverView<Parent: View, SheetContent: View, R: Equatable>: View {
  @EnvironmentObject var sheetCoordinator: SheetCoordinator
  
  @Binding public var isPresented: Bool
  public let content: () -> SheetContent
  public let parent: Parent
  public var onDismiss: (() -> Void)?
  public var id: R
  
  public var body: some View {
    parent
      .onChange(
        of: isPresented,
        perform: onPresentationChange
      )
  }
  
  func onPresentationChange(_ b: Bool) {
    sheetCoordinator.updateSheetCoordinator(
      id: id,
      isPresented: isPresented,
      content: content,
      onDismiss: {
        self.isPresented = false
        onDismiss?()
      }
    )
  }
}
