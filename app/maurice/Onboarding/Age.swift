import Foundation
import SwiftUI

struct Age: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @State private var age = 18
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                Text("Enter your age")
                    .bold()
                    .font(.system(size: 36))
                Picker(selection: $age,label: EmptyView()) {
                    ForEach(18..<100){ number in
                        Text("\(number)").tag("\(number)")
                    }
                }
            }
            Button(action: {
//                onboardingSteps.append(.height)
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
struct Age_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        Age(onboardingSteps: $path)
    }
}
#endif
