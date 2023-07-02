//
// This source file is part of the Stanford HealthGPT project
//
// SPDX-FileCopyrightText: 2023 Stanford University & Project Contributors
//

import CardinalKitFHIR
import CardinalKitHealthKit
import CardinalKitOnboarding
import SwiftUI


struct HealthKitPermissions: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @EnvironmentObject var healthKitDataSource: HealthKit<FHIR>
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    @State var healthKitProcessing = false

    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    Text("HealthKit Access")
                        .font(.system(size: 36))
                        .bold()
                        .padding(.bottom, 15)
                    Text("MauriceAI can access data from HealthKit to use in conversations with your nutritionist.")
                        .multilineTextAlignment(.center)
                    Text("It is totally optionnal.")
                    Spacer()
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.accentColor)
                    Text("HEALTHKIT_PERMISSIONS_DESCRIPTION")
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                    Spacer()
                }
            }, actionView: {
                OnboardingActionsView(
                    "HEALTHKIT_PERMISSIONS_BUTTON".moduleLocalized,
                    action: {
                        do {
                            healthKitProcessing = true
                            // HealthKit is not available in the preview simulator.
                            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                                try await _Concurrency.Task.sleep(for: .seconds(5))
                            } else {
                                try await healthKitDataSource.askForAuthorization()
                            }
                        } catch {
                            print("Could not request HealthKit permissions.")
                        }
                        healthKitProcessing = false
                        onboardingSteps.append(.signIn)
                    }
                )
                Button("Skip") {
                    healthKitProcessing = false
                    onboardingSteps.append(.signIn)
                }
                .padding(.top, 10)
            }
        )
            .navigationBarBackButtonHidden(healthKitProcessing)
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}
