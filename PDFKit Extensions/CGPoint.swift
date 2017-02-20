import Foundation

extension CGPoint {
    // swiftlint:disable variable_name_min_length
    func pointByOffsetting(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
    // swiftlint:enable variable_name_min_length
}
