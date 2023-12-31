//
// This source file is part of the Stanford HealthGPT project
//
// SPDX-FileCopyrightText: 2023 Stanford University & Project Contributors & Project Contributors
//

import CardinalKitFHIR
import CardinalKitOnboarding
import SwiftUI


struct Disclaimer: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]

    var body: some View {
        SequentialOnboardingView(
            title: "INTERESTING_MODULES_TITLE".moduleLocalized,
            subtitle: "INTERESTING_MODULES_SUBTITLE".moduleLocalized,
            content: [
                .init(
                    title: "INTERESTING_MODULES_AREA1_TITLE".moduleLocalized,
                    description: "INTERESTING_MODULES_AREA1_DESCRIPTION".moduleLocalized
                ),
                .init(
                    title: "INTERESTING_MODULES_AREA2_TITLE".moduleLocalized,
                    description: "INTERESTING_MODULES_AREA2_DESCRIPTION".moduleLocalized
                ),
            ],
            actionText: "INTERESTING_MODULES_BUTTON".moduleLocalized,
            action: {
                onboardingSteps.append(.healthKitPermissions)
            }
        )
    }


    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}


#if DEBUG
struct Disclaimer_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []


    static var previews: some View {
        Disclaimer(onboardingSteps: $path)
    }
}
#endif
