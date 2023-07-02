import CardinalKit
import CardinalKitFHIR
import CardinalKitHealthKit
import CardinalKitHealthKitToFHIRAdapter
import CardinalKitSecureStorage
import HealthKit
import SwiftUI
import FirebaseCore

class TemplateAppDelegate: CardinalKitAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: FHIR()) {
            SecureStorage()
            if HKHealthStore.isHealthDataAvailable() {
                healthKit
            }
        }
    }

    private var healthKit: HealthKit<FHIR> {
        HealthKit {
            CollectSamples(
                [
                    HKQuantityType(.stepCount),
                    HKQuantityType(.activeEnergyBurned),
                    HKQuantityType(.appleExerciseTime),
                    HKQuantityType(.bodyMass),
                    HKQuantityType(.heartRate),
                    HKCategoryType(.sleepAnalysis)
                ],
                deliverySetting: .manual()
            )
        } adapter: {
            HealthKitToFHIRAdapter()
        }
    }
    
    
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Configure RevenueCat
        initRevenueCat()

        return true
    }
}
