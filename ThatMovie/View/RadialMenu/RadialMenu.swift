//
//  RadialMenu.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 04.02.2024.
//


import SwiftUI

// The button data holder
struct RadialMenuButton {
    let color: Color
    let image: String
    let size: CGFloat
    let ignoreAutoclose: Bool
    let action: () -> Void
    
    init(color: Color = Color("PrimaryBackground"), image: String, size: CGFloat, ignoreAutoclose: Bool = false, action: @escaping () -> Void) {
        self.color = color
        self.image = image
        self.size = size
        self.ignoreAutoclose = ignoreAutoclose
        self.action = action
    }
}

struct RadialMenu: ViewModifier {
    @Binding var isHidden: Bool
    let anchorPosition: AnchorPosition
    let distance: CGFloat
    let autoClose: Bool
    let buttons: [RadialMenuButton]
    
    func body(content: Content) -> some View {
        ZStack {
            content
            radialMenu
        }
    }
    
    // This might look complicated, but it just figures out the angle
    // between subsequent menu items. Since their spread can be on any
    // arc, it needs to do the check to prevent first and last item
    // from overlapping.
    private var angleDelta: Double {
        let span = anchorPosition.endAngle - anchorPosition.startAngle
        let n = buttons.count
        let nMinus1 = n - 1
        let candidate = span / Double(nMinus1)
        let point0 = pointFor(angleDelta: candidate, index: 0)
        let point1 = pointFor(angleDelta: candidate, index: 1)
        let pointN = pointFor(angleDelta: candidate, index: nMinus1)
        return (hypot(point0.x - point1.x, point0.y - point1.y) > hypot(point0.x - pointN.x, point0.y - pointN.y))
        ? span / Double(n)
        : candidate
    }
    
    // The offset from the anchor point for the button at the given index.
    private func pointFor(angleDelta: Double, index: Int) -> CGPoint {
        let angle = anchorPosition.startAngle + angleDelta * Double(index)
        return CGPoint(x: (distance * cos(angle)), y: distance * sin(angle))
    }
    
    @ViewBuilder private var radialMenu: some View {
        let angle = angleDelta
        ZStack {
            ForEach(0..<buttons.count, id: \.self) { i in
                radialMenuButton(buttons[i],
                                 offset: pointFor(angleDelta: angle, index: i))
            }
        }
    }
    
    private func radialMenuButton(_ button: RadialMenuButton,
                                  offset: CGPoint) -> some View {
        return Image(systemName: button.image)
            .imageScale(.large)
            .frame(width: button.size, height: button.size)
            .background(Circle().fill(button.color.opacity(0.2)))
            .tint(button.color)
            .shadow(color: .gray, radius: 2, x: 1, y: 1)
            .onTapGesture {
                button.action()
                if (autoClose && !button.ignoreAutoclose) {
                    isHidden.toggle()
                }
            }
            .offset(x: isHidden ? 0 : offset.x,
                    y: isHidden ? 0 : offset.y)
            .opacity(isHidden ? 0 : 1)
            .animation(.spring().speed(1), value: isHidden)
    }
    
    enum AnchorPosition {
        case topLeft,
             topRight,
             bottomLeft,
             bottomRight,
             center,
             custom(Angle, Angle)
        
        var startAngle: Double {
            switch self {
            case .topLeft:
                return 0
            case .topRight:
                return .pi / 2
            case .bottomLeft:
                return 3 * .pi / 2
            case .bottomRight:
                return .pi - 0.1
            case .center:
                return -.pi / 2
            case .custom(let startAngle, _):
                return startAngle.radians
            }
        }
        
        var endAngle: Double {
            switch self {
            case .center:
                return 3 * .pi / 2
            case .custom(_, let endAngle):
                return endAngle.radians
            default:
                return startAngle + .pi / 2
            }
        }
    }
}


extension View {
    func radialMenu(isHidden: Binding<Bool>,
                    anchorPosition: RadialMenu.AnchorPosition,
                    distance: CGFloat,
                    autoClose: Bool,
                    buttons: [RadialMenuButton]) -> some View {
        
        self.modifier(RadialMenu(isHidden: isHidden,
                                 anchorPosition: anchorPosition,
                                 distance: distance,
                                 autoClose: autoClose,
                                 buttons: buttons))
    }
}
