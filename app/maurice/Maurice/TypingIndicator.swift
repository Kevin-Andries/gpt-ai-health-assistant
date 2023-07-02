import SwiftUI

struct TypingIndicatorView: View {
    @State private var scale1: CGFloat = 1.0
    @State private var scale2: CGFloat = 1.0
    @State private var scale3: CGFloat = 1.0

    var body: some View {
        HStack {
            Circle()
                .scaleEffect(scale1)
                .frame(width: 10, height: 10)
            Circle()
                .scaleEffect(scale2)
                .frame(width: 10, height: 10)
            Circle()
                .scaleEffect(scale3)
                .frame(width: 10, height: 10)
        }
        .onAppear {
            let baseAnimation = Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)
            
            withAnimation(baseAnimation) {
                scale1 = 1.5
            }
            withAnimation(baseAnimation.delay(0.2)) {
                scale2 = 1.5
            }
            withAnimation(baseAnimation.delay(0.4)) {
                scale3 = 1.5
            }
        }
    }
}
