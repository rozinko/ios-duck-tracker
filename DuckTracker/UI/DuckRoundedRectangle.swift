import SwiftUI

struct DuckRoundedRectangle: Shape {
    var topLeadingRadius: CGFloat = 0
    var bottomLeadingRadius: CGFloat = 0
    var bottomTrailingRadius: CGFloat = 0
    var topTrailingRadius: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // go to start position (before top leading corner)
        path.move(to: CGPoint(x: rect.minX + abs(topLeadingRadius), y: rect.minY))

        // make top leading corner
        if topLeadingRadius > 0 {
            path.addArc(
                center: CGPoint(x: rect.minX + topLeadingRadius, y: rect.minY + topLeadingRadius),
                radius: topLeadingRadius,
                startAngle: .degrees(-90),
                endAngle: .degrees(-180),
                clockwise: true)
        } else if topLeadingRadius < 0 {
            path.addArc(
                center: CGPoint(x: rect.minX, y: rect.minY),
                radius: -topLeadingRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false)
        }

        // go to next (before bottom leading position)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY -  abs(bottomLeadingRadius)))

        // make bottom leading corner
        if bottomLeadingRadius > 0 {
            path.addArc(
                center: CGPoint(x: rect.minX + bottomLeadingRadius, y: rect.maxY - bottomLeadingRadius),
                radius: bottomLeadingRadius,
                startAngle: .degrees(180),
                endAngle: .degrees(90),
                clockwise: true)
        } else if bottomLeadingRadius < 0 {
            path.addArc(
                center: CGPoint(x: rect.minX, y: rect.maxY),
                radius: -bottomLeadingRadius,
                startAngle: .degrees(-90),
                endAngle: .degrees(0),
                clockwise: false)
        }

        // go to next (before bottom trailing position)
        path.addLine(to: CGPoint(x: rect.maxX - abs(bottomTrailingRadius), y: rect.maxY))

        // make bottom trailing corner
        if bottomTrailingRadius > 0 {
            path.addArc(
                center: CGPoint(x: rect.maxX - bottomTrailingRadius, y: rect.maxY - bottomTrailingRadius),
                radius: bottomTrailingRadius,
                startAngle: .degrees(90),
                endAngle: .degrees(0),
                clockwise: true)
        } else if bottomTrailingRadius < 0 {
            path.addArc(
                center: CGPoint(x: rect.maxX, y: rect.maxY),
                radius: -bottomTrailingRadius,
                startAngle: .degrees(-180),
                endAngle: .degrees(-90),
                clockwise: false)
        }

        // go to next (before top trailing position)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + abs(topTrailingRadius)))

        // make top trailing corner
        if topTrailingRadius > 0 {
            path.addArc(
                center: CGPoint(x: rect.maxX - topTrailingRadius, y: rect.minY + topTrailingRadius),
                radius: topTrailingRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(-90),
                clockwise: true)
        } else if topTrailingRadius < 0 {
            path.addArc(
                center: CGPoint(x: rect.maxX, y: rect.minY),
                radius: abs(topTrailingRadius),
                startAngle: .degrees(-90),
                endAngle: .degrees(-180),
                clockwise: false)
        }

        // close path
        path.closeSubpath()

        return path
    }
}

#Preview {
    ZStack {
        Color.red.ignoresSafeArea(.all)

        VStack(spacing: 25) {
            HStack(spacing: 15) {
                Rectangle()
                    .frame(width: 100, height: 100)
                    .clipShape(DuckRoundedRectangle())

                Rectangle()
                    .frame(width: 100, height: 100)
                    .clipShape(DuckRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 15))
            }
            HStack(spacing: 15) {
                Rectangle()
                    .frame(width: 100, height: 100)
                    .clipShape(DuckRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 15))

                Rectangle()
                    .frame(width: 100, height: 100)
                    .clipShape(DuckRoundedRectangle(topLeadingRadius: -15, bottomLeadingRadius: 0, bottomTrailingRadius: 15, topTrailingRadius: 0))
            }
            HStack(spacing: 15) {
                Rectangle()
                    .frame(width: 100, height: 100)
                    .clipShape(DuckRoundedRectangle(topLeadingRadius: -15, bottomLeadingRadius: -25, bottomTrailingRadius: -35, topTrailingRadius: -45))

                Rectangle()
                    .frame(width: 100, height: 100)
                    .clipShape(DuckRoundedRectangle(topLeadingRadius: 2, bottomLeadingRadius: 15, bottomTrailingRadius: 2, topTrailingRadius: -45))
            }
        }
    }
}
