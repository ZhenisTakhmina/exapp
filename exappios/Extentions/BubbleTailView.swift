//
//  BubbleTailView.swift
//  exappios
//
//  Created by Tami on 31.08.2024.
//

import SwiftUI

struct BubbleTailShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let tailSize: CGFloat = 10
        
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: 15, height: 15))
        
        // Tail triangle
        path.move(to: CGPoint(x: rect.maxX - 20, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - 20 - tailSize, y: rect.maxY + tailSize))
        path.addLine(to: CGPoint(x: rect.maxX - 20 - tailSize * 2, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}
