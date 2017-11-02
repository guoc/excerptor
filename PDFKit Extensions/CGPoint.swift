import Foundation

extension CGPoint {
    func pointByOffsetting(dx: CGFloat, dy: CGFloat) -> CGPoint { // swiftlint:disable:this identifier_name
        return CGPoint(x: x + dx, y: y + dy)
    }
}
