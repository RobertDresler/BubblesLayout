import SwiftUI
import BubblesLayout

struct PreviewView: View {

    private struct BubbleItem: Identifiable {
        let id: UUID
        let name: String
        let size: CGFloat
    }

    @State private var bubbles: [BubbleItem] = []
    @State private var bubblesCount: Double = 5

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Beginning")
                bubblesLayout
                    .padding(.horizontal, 4)
                Text("End")
            }
        }
            .safeAreaInset(edge: .bottom) { countSlider }
            .onChange(of: configCount) { setBubbles(for: $0) }
            .onAppear { setBubbles(for: configCount) }
    }

    private var bubblesLayout: some View {
        BubblesLayout(minSpacing: 8) {
            ForEach(bubbles) {
                bubble(for: $0)
            }
        }
    }

    private var countSlider: some View {
        VStack {
            Text("Count: \(Int(bubblesCount))")
                .frame(maxWidth: .infinity)
            #if !os(tvOS)
            Slider(value: $bubblesCount, in: 1...100, step: 1)
            #endif
        }
    }

    private var configCount: Int {
        Int(bubblesCount)
    }

    private func setBubbles(for count: Int) {
        let names = [
            "Apple Inc. (AAPL)",
            "Microsoft Corp. (MSFT)",
            "Tesla Inc. (TSLA)",
            "Amazon.com Inc. (AMZN)",
            "Alphabet Inc. (GOOGL)",
            "NVIDIA Corp. (NVDA)",
            "Meta Platforms Inc. (META)",
            "Berkshire Hathaway (BRK.A)",
            "Visa Inc. (V)",
            "Johnson & Johnson (JNJ)"
        ]
        bubbles = Array(
            Array(repeating: names, count: count / names.count + 1)
                .flatMap { $0 }
                .map { name in
                    BubbleItem(
                        id: UUID(),
                        name: name,
                        size: (
                            Array(repeating: 260, count: 1)
                            + Array(repeating: 220, count: 3)
                            + Array(repeating: 160, count: 6)
                            + Array(repeating: 120, count: 9)
                        ).randomElement() ?? 1
                    )
                }
                .prefix(count)
        )
    }

    private func bubble(for bubble: BubbleItem) -> some View {
        Text(bubble.name)
            .minimumScaleFactor(0.1)
            .frame(width: bubble.size, height: bubble.size)
            .background([.green, .blue, .yellow, .red].randomElement() ?? .green)
            .clipShape(Circle())
    }

}

#Preview {
    PreviewView()
}
