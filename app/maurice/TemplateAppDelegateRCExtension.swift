import Foundation
import SwiftUI
import RevenueCat

extension TemplateAppDelegate: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        print("EVENT: customerInfo object updated")
        print(customerInfo)
    }
}
