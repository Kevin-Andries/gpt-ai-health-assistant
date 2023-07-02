import Foundation
import SwiftUI

struct Weight: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @State private var weight = 70
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                Text("Enter your weight (kg)")
                    .bold()
                    .font(.system(size: 36))
                Picker(selection: $weight,label: EmptyView()) {
                    ForEach(30..<200){ number in
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
struct Weight_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        Weight(onboardingSteps: $path)
    }
}
#endif
