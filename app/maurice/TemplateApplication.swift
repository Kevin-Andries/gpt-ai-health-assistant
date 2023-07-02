import CardinalKit
import SwiftUI

@main
struct TemplateApplication: App {
    @UIApplicationDelegateAdaptor(TemplateAppDelegate.self) var appDelegate
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    @StateObject private var user = User()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(user)
                .sheet(isPresented: !$completedOnboardingFlow) {
                    OnboardingFlow()
                        .environmentObject(user)
                }
                .testingSetup()
                .cardinalKit(appDelegate)
        }
    }
}
