import Foundation
import SwiftUI

struct Name: View {
    @EnvironmentObject var user: User
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    @State private var firstName = ""
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                Text("Enter your name")
                    .bold()
                    .font(.system(size: 36))
                TextField(
                    "John",
                    text: $firstName
                )
                .textFieldStyle(.roundedBorder)
            }
            Button(action: {
                completedOnboardingFlow = true
                user.userData.first_name = firstName
                Api.updateUserData(
                    token: user.firebaseAuthToken!,
                    firstName: firstName,
                    foodAllergies: "",
                    foodPreferences: "") {
                    }
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
            .disabled(firstName.isEmpty)
        }
        .padding()
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}

#if DEBUG
struct Name_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        Name(onboardingSteps: $path)
    }
}
#endif
