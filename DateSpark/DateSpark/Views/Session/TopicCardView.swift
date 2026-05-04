import SwiftUI

struct TopicCardView: View {
    let topic: Topic
    @Binding var isFlipped: Bool
    var onFlip: () -> Void
    var onNext: () -> Void
    var onFavorite: () -> Void

    var body: some View {
        ZStack {
            cardFront
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? -90 : 0), axis: (x: 0, y: 1, z: 0))

            cardBack
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : 90), axis: (x: 0, y: 1, z: 0))
        }
        .animation(.spring(duration: 0.5, bounce: 0.3), value: isFlipped)
    }

    private var cardFront: some View {
        VStack(spacing: 20) {
            depthBadge
            Spacer()
            Text(topic.text)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .minimumScaleFactor(0.7)
                .lineLimit(5)
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "hand.tap")
                    .font(.caption2)
                Text("Tap to reveal follow-up")
                    .font(.caption)
            }
            .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(hex: topic.depth.colorHex).gradient)
        )
        .onTapGesture { onFlip() }
    }

    private var cardBack: some View {
        VStack(spacing: 20) {
            depthBadge
            Spacer()
            VStack(spacing: 12) {
                Text("FOLLOW-UP")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.7))

                Text(topic.followUp.isEmpty ? "Share your thoughts on this!" : topic.followUp)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .minimumScaleFactor(0.7)
                    .lineLimit(5)
            }
            Spacer()
            HStack(spacing: 40) {
                Button(action: onFavorite) {
                    Image(systemName: topic.isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                Button(action: onNext) {
                    Image(systemName: "arrow.right")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(hex: topic.depth.colorHex).gradient)
        )
    }

    private var depthBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: topic.depth.emoji)
                .font(.caption2)
            Text(topic.depth.rawValue)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
    }
}
