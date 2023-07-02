import SwiftUI

struct OnboardingFlow: View {
    enum Step: String, Codable {
        case disclaimer
        case healthKitPermissions
        case signIn
        case name
    }

    @SceneStorage(StorageKeys.onboardingFlowStep) private var onboardingSteps: [Step] = []
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false


    var body: some View {
        NavigationStack(path: $onboardingSteps) {
            Welcome(onboardingSteps: $onboardingSteps)
                .navigationDestination(for: Step.self) { onboardingStep in
                    switch onboardingStep {
                    case .disclaimer:
                        Disclaimer(onboardingSteps: $onboardingSteps)
                    case .healthKitPermissions:
                        HealthKitPermissions(onboardingSteps: $onboardingSteps)
                    case .signIn:
                        SignInView(onboardingSteps: $onboardingSteps.asOptional())
                    case .name:
                        Name(onboardingSteps: $onboardingSteps)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled(!completedOnboardingFlow)
    }
}
