//
//  ViewExtension.swift
//  StepSquad
//
//  Created by Groo on 11/20/24.
//

import Foundation
import SwiftUICore
import SwiftUI

extension View {
    // MARK: 난이도 관련 진한 색 반환
    func getDifficultyColor(difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy: return .easy
        case .normal: return .normal
        case .hard: return .hard
        case .expert: return .expert
        case .impossible: return .impossible
        }
    }
    
    // MARK: 난이도 관련 연한 색 반환
    func getDifficultyPaleColor(difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy: return .easyPale
        case .normal: return .normalPale
        case .hard: return .hardPale
        case .expert: return .expertPale
        case .impossible: return .impossiblePale
        }
    }
}

extension View {
    // This function changes our View to UIView, then calls another function
    // to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        // here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    // This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
