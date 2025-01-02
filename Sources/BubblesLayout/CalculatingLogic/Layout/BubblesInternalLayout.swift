import SwiftUI

struct BubblesInternalLayout: Layout {

    let bubblesFrames: [BubbleCalculatedFrame]

    struct CacheData {
        let minOffset: CGFloat
    }

    func makeCache(subviews: Subviews) -> CacheData {
        CacheData(minOffset: bubblesFrames.map({ $0.frame.minY }).min() ?? 0)
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout CacheData
    ) -> CGSize {
        CGSize(
            width: proposal.width ?? 0,
            height: (bubblesFrames.map { $0.frame.maxY }.max() ?? 0) - cache.minOffset
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout CacheData
    ) {
        let minOffset = cache.minOffset
        subviews.enumerated().forEach { index, subview in
            guard index <= bubblesFrames.count - 1 else { return }
            let bubble = bubblesFrames[index]
            subview.place(
                at: CGPoint(
                    x: bounds.minX
                    + bubble.frame.origin.x
                    + bubble.frame.width / 2,
                    y: bounds.minY
                    + bounds.height
                    - bubble.frame.origin.y
                    - bubble.frame.height / 2
                    + minOffset
                ),
                anchor: .center,
                proposal: .unspecified
            )
        }
    }

}
