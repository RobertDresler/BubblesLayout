import SwiftUI
import SpriteKit

struct BubblesFrameCalculatingView: View {

    let sizes: [CGSize]
    let minSpacing: CGFloat
    let onBubblesCalculated: ([BubbleCalculatedFrame]) -> Void

    var body: some View {
        GeometryReader { geometry in
            SpriteView(scene: scene(size: geometry.size))
        }
            .frame(height: 1000)
            .id(sizes.count)
    }

    private func scene(size: CGSize) -> SKScene {
        BubblesFrameCalculatingScene.make(
            containerSize: size,
            sizes: sizes,
            minSpacing: minSpacing,
            onBubblesCalculated: onBubblesCalculated
        )
    }

}
