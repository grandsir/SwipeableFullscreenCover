//
//  SwipeableFullscreenCoverView.swift
//  SwipeableFullscreenCover
//
//  Created by Demirhan Mehmet Atabey on 13.06.2024.
//

import SwiftUI

internal typealias Configuration = SwipeableFullscreenCoverConfiguration

/// A wrapper to present swipable fullscreen cover.
public struct SwipeableFullscreenCoverView<SheetContent: View, R: Equatable>: View {
  
  // MARK: - Wrapped Properties
  
  @EnvironmentObject var sheetCoordinator: SheetCoordinator
  @ObservedObject    var configuration = Configuration()
  
  @Binding public var isPresented: Bool
  @State private var i: Bool = false
  
  // MARK: - Properties
  
  public let content: () -> SheetContent
  public let parent: AnyView
  public var onDismiss: (() -> Void)?
  public var id: R
  
  // MARK: - Body View
  
  public var body: some View {
    parent
      .onChange(
        of: isPresented,
        perform: onPresentationChange
      )
      .onChange(of: configuration) { c in
        onConfigurationChange(c)
      }
  }

  // MARK: - Methods
  
  public func customBackground(_ view: @escaping () -> some View ) -> Self {
    self.configuration.backgroundView = AnyView(view())
    if isPresented {
      onConfigurationChange(configuration, skipI: true)
    }
    return self
  }
  
  
  private func onPresentationChange(_ b: Bool) {
    if b {
      sheetCoordinator.configuration = configuration
    }
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
  
  private func onConfigurationChange(_ c: Configuration, skipI: Bool = false) {
    guard !skipI || i else { return }
    i = true
    if isPresented {
      sheetCoordinator.updateSheetConfiguration(
        configuration: c
      )
    }
  }
}
