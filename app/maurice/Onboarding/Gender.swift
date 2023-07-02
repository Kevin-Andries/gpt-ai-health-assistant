import Foundation
import SwiftUI

struct Gender: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @State private var gender = ""
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                Text("What's your gender?")
                    .bold()
                    .font(.system(size: 36))
                TextField(
                    "Female",
                    text: $gender
                )
                .textFieldStyle(.roundedBorder)
            }
            Button(action: {
//                onboardingSteps.append(.age)
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
            .disabled(gender.isEmpty)
        }
        .padding()
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}

#if DEBUG
struct Gender_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        Gender(onboardingSteps: $path)
    }
}
#endif
