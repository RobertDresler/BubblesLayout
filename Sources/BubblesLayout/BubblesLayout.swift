import SwiftUI

// TODO: On iOS 18 use custom container https://developer.apple.com/documentation/SwiftUI/Creating-custom-container-views
public struct BubblesLayout<BubbleViews: View>: View {

    private let minSpacing: CGFloat
    private let startingAlignment: BubblesLayoutStartingAlignment
    @ViewBuilder private let bubbles: () -> BubbleViews
    @State private var bubblesFrames: [BubbleCalculatedFrame]?
    @State private var bubblesFramesNotCalculatedSizes: [CGSize]?

    public init(
        minSpacing: CGFloat = 0,
        startingAlignment: BubblesLayoutStartingAlignment = .center,
        @ViewBuilder bubbles: @escaping () -> BubbleViews
    ) {
        self.minSpacing = minSpacing
        self.startingAlignment = startingAlignment
        self.bubbles = bubbles
    }

    public var body: some View {
        Group {
            if let bubblesFramesNotCalculatedSizes {
                if let bubblesFrames {
                    BubblesInternalLayout(
                        bubblesFrames: bubblesFrames
                    ) {
                        bubbles()
                    }
                } else {
                    frameCalculatingView(for: bubblesFramesNotCalculatedSizes)
                }
            } else {
                Color.clear
            }
        }.background { sizeCalculatingLayout }
    }

    private func frameCalculatingView(for bubblesFramesNotCalculatedSizes: [CGSize]) -> some View {
        BubblesFrameCalculatingView(
            sizes: bubblesFramesNotCalculatedSizes,
            minSpacing: minSpacing,
            startingAlignment: startingAlignment,
            onBubblesCalculated: { newBubblesFrames in
                guard
                    newBubblesFrames.count != bubblesFrames?.count
                    || zip(newBubblesFrames, bubblesFrames ?? []).allSatisfy({ $0.frame == $1.frame })
                else { return }
                bubblesFrames = newBubblesFrames
            }
        ).opacity(0)
    }

    private var sizeCalculatingLayout: some View {
        BubblesSizeCalculatingLayout(
            onSizesCalculated: { sizes in
                Task { @MainActor in
                    guard sizes != bubblesFramesNotCalculatedSizes else { return }
                    bubblesFramesNotCalculatedSizes = sizes
                    bubblesFrames = nil
                }
            }
        ) {
            bubbles()
        }.opacity(0)
    }

}
