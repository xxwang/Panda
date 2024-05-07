import UIKit

public protocol Emitterable {}

public extension Emitterable where Self: UIViewController {

    func pd_startEmitting(position: CGPoint, images: [UIImage?]) {

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = position
        emitter.preservesDepth = true
        var cells = [CAEmitterCell]()
        for image in images {
            let cell = CAEmitterCell()
            cell.velocity = 150
            cell.velocityRange = 100
            cell.scale = 0.7
            cell.scaleRange = 0.3
            cell.emissionLongitude = -(Double.pi / 2)
            cell.emissionRange = -(Double.pi / 12)
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            cell.spin = Double.pi / 2
            cell.spinRange = Double.pi / 4
            cell.birthRate = 20
            cell.contents = image?.cgImage

            cells.append(cell)
        }
        emitter.emitterCells = cells
        view.layer.addSublayer(emitter)
    }

    func pd_stopEmitting() {
        view.layer.sublayers?
            .filter { $0.isKind(of: CAEmitterLayer.self) }
            .forEach { $0.removeFromSuperlayer() }
    }
}
