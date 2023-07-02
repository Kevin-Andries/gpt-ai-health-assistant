import Foundation
import SwiftUI

struct Height: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @State private var height = 170
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                Text("Enter your height (cm)")
                    .bold()
                    .font(.system(size: 36))
                Picker(selection: $height,label: EmptyView()) {
                    ForEach(100..<230){ number in
                        Text("\(number)").tag("\(number)")
                    }
                }
            }
            Button(action: {
//                onboardingSteps.append(.weight)
            }) {
               Text("Next")
                    .frame(width: 200)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .bold()
                    .padding(.top, 30)
                    .font(.system(size: 20))
            }
        }
        .padding()
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}

#if DEBUG
struct Height_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        Height(onboardingSteps: $path)
    }
}
#endif
