import SwiftUI

struct BubblesSizeCalculatingLayout: Layout {

    var onSizesCalculated: ([CGSize]) -> Void

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        CGSize(width: 1, height: 1)
    }


    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        onSizesCalculated(subviews.map { $0.sizeThatFits(.unspecified) })
    }

}
