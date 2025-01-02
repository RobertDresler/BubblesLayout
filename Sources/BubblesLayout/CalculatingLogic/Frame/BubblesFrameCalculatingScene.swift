import SpriteKit

final class BubblesFrameCalculatingScene: SKScene {

    private final class BubbleNode: SKShapeNode {}

    /// This is needed since custom init doesn't work
    static func make(
        containerSize: CGSize,
        sizes: [CGSize],
        minSpacing: CGFloat,
        onBubblesCalculated: @escaping ([BubbleCalculatedFrame]) -> Void
    ) -> BubblesFrameCalculatingScene {
        let scene = BubblesFrameCalculatingScene()
        scene.size = containerSize
        scene.sizes = sizes
        scene.minSpacing = minSpacing
        scene.onBubblesCalculated = onBubblesCalculated
        scene.scaleMode = .aspectFit
        return scene
    }

    private var sizes: [CGSize]!
    private var minSpacing: CGFloat!
    private var onBubblesCalculated: (([BubbleCalculatedFrame]) -> Void)!

    override func didMove(to view: SKView) {
        setupPhysicsWorld()
        addBubblesNodes()
        waitForCalculationAndSendCallback()
    }

}

// MARK: Private Methods

private extension BubblesFrameCalculatingScene {
    func setupPhysicsWorld() {
        let additionalHeight = sizes.map { $0.width + minSpacing }.reduce(0, +)
        physicsBody = SKPhysicsBody(
            edgeLoopFrom: CGRect(
                x: frame.minX,
                y: frame.minY - additionalHeight,
                width: frame.width,
                height: frame.height + additionalHeight
            )
        )
        physicsWorld.gravity = CGVector(dx: 0, dy: 9.8)
        physicsWorld.speed = 10000
    }

    func addBubblesNodes() {
        sizes.enumerated().forEach { index, size in
            let radius: CGFloat = size.width / 2 + minSpacing / 2
            let circle = BubbleNode(circleOfRadius: radius)
            circle.fillColor = .blue
            circle.position = CGPoint(
                x: frame.width / 4 * CGFloat(index % 4),
                y: -sizes.prefix(index).map { $0.width * 0.5 + minSpacing }.reduce(0, +)
            )
            circle.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            circle.physicsBody?.isDynamic = true
            circle.physicsBody?.allowsRotation = false
            circle.physicsBody?.restitution = 1
            addChild(circle)
        }
    }

    func waitForCalculationAndSendCallback() {
        Task {
            try? await Task.sleep(for: .seconds(0.1))
            let calculatedBubbles = children.compactMap { $0 as? BubbleNode }.map { node in
                BubbleCalculatedFrame(
                    frame: CGRect(
                        origin: node.frame.origin,
                        size: CGSize(
                            width: node.frame.width - minSpacing,
                            height: node.frame.height - minSpacing
                        )
                    )
                )
            }
            onBubblesCalculated(calculatedBubbles)
        }
    }
}
