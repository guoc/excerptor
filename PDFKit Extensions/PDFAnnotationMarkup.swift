import Foundation
import Quartz

extension PDFAnnotationMarkup {

// MARK: - Public

    var selectionText: String {
        get {
            let selections: [PDFSelection]
            if #available(OSX 10.11, *) {
                selections = rectsInPageCoordinate.map { (self.page?.selection(for: NSInsetRect($0, -1.0, -1.0))!)! }
            } else {
                selections = horizontalCentralLinesInPageCoordinate.map { (self.page?.selection(from: $0.startPoint, to: $0.endPoint)!)! }
            }
            let selectionStrings = selections.map({ $0.string ?? "" }).map({$0.trimmingCharacters(in: CharacterSet.newlines)})
            return selectionStrings.joined(separator: " ")
        }
    }


// MARK: - Private

    fileprivate var rects: [CGRect] {
        get {
            let quadrilateralPoints = self.quadrilateralPoints().map { ($0 as AnyObject).pointValue as NSPoint}
            assert(quadrilateralPoints.count % 4 == 0, "Incorrect number of annotation markup quadrilateral points")
            let groupedQuadrilateralPoints = [Int](0..<quadrilateralPoints.count/4).map { [NSPoint](quadrilateralPoints[$0*4..<$0*4+4]) }
            let rectsInAnnotationCoordinate = groupedQuadrilateralPoints.map { self.smallestRectangleEnclosing($0) }
            return rectsInAnnotationCoordinate
        }
    }

    fileprivate var rectsInPageCoordinate: [CGRect] {
        get {
            let origin = self.bounds.origin
            return rects.map { $0.offsetBy(dx: origin.x, dy: origin.y) }
        }
    }

    fileprivate var horizontalCentralLines: [(startPoint: CGPoint, endPoint: CGPoint)] {
        get {
            return rects.map { (rect: CGRect) -> (startPoint: CGPoint, endPoint: CGPoint) in
                let x = rect.origin.x, y = rect.origin.y, width = rect.width, height = rect.height
                let startPoint = CGPoint(x: x, y: y + height / 2.0)
                let endPoint = CGPoint(x: x + width, y: y + height / 2.0)
                return (startPoint: startPoint, endPoint: endPoint)
            }
        }
    }

    fileprivate var horizontalCentralLinesInPageCoordinate: [(startPoint: CGPoint, endPoint: CGPoint)] {
        get {
            let origin = self.bounds.origin
            return horizontalCentralLines.map { ($0.startPoint.pointByOffsetting(dx: origin.x, dy: origin.y), $0.endPoint.pointByOffsetting(dx: origin.x, dy: origin.y)) }
        }
    }

// MARK: - Helper Methods

    fileprivate func smallestRectangleEnclosing(_ points: [CGPoint]) -> CGRect {

        guard let minX = (points.map { $0.x }).min(),
                  let maxX = (points.map { $0.x }).max(),
                  let minY = (points.map { $0.y }).min(),
                  let maxY = (points.map { $0.y }).max() else {
            exitWithError("Empty points array passed in smallestRectangleEnclosing")
        }

        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    fileprivate func smallestRectangleEnclosing(_ points: CGPoint...) -> CGRect {
        return smallestRectangleEnclosing(points)
    }

}
