//
//  Helpers.swift
//  SwipeableFullscreenCover
//
//  Created by Demirhan Mehmet Atabey on 13.06.2024.
//

import SwiftUI

extension UIApplication {
  var firstKeyWindow: UIWindow? {
    let windowScenes = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
    let activeScene = windowScenes
      .filter { $0.activationState == .foregroundActive }
    let firstActiveScene = activeScene.first
    let keyWindow = firstActiveScene?.keyWindow
    
    return keyWindow
  }
}
