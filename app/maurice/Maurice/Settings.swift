import Foundation
import SwiftUI
import FirebaseAuth
import RevenueCat

struct SettingsView: View {
    @EnvironmentObject var user: User
    let onClose: () -> Void
    @State private var showSignOutAlert = false
    @State private var showDeleteAccountFlow = false
    @State private var showDeleteAccountAlert = false
    @State private var showConfirmationDeleteAccountAlert = false
    @State private var isPremium = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Link("Privacy policy",
                         destination: URL(string: "https://mauriceai.com/privacy-policy.html")!
                    )
                    Link("Terms & Conditions (Apple)",
                         destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
                    )
                    Link("Terms & Conditions (MauriceAI)",
                         destination: URL(string: "https://mauriceai.com/terms-and-conditions.html")!
                    )
                }
                Section {
                    Text("hello@mauriceai.com")
                    Text("We will be happy to help!")
                    Link("mauriceai.com",
                         destination: URL(string: "https://mauriceai.com")!
                    )
                } header: {
                    Text("Get in touch")
                }
                Section {
                    if isPremium {
                        Text("Manage your subscription from the App Store")
                    } else {
                        Text("Unlock full potential & unlimited messages!")
                        Button("Go premium") {
                            onClose()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                user.showGoPremiumSheet = true
                            }
                        }
                    }
                } header: {
                    Text("Subscription")
                }
                Section {
                    Button("Log Out") {
                        showSignOutAlert = true
                    }.alert(isPresented: $showSignOutAlert) {
                        Alert(
                            title: Text("Log out?"),
                            primaryButton: Alert.Button.default(Text("Yes"), action: {
                                user.signOut()
                            }),
                            secondaryButton: Alert.Button.cancel(Text("No"), action: {
                                
                            })
                        )
                    }
                    .foregroundColor(.red)
                    
                    Button("Delete my account") {
                        showDeleteAccountFlow = true
                        showDeleteAccountAlert = true
                    }
                    .alert(isPresented: $showDeleteAccountFlow) {
                        if showDeleteAccountAlert && !showConfirmationDeleteAccountAlert {
                            return Alert(
                                title: Text("Delete your account?"),
                                message: Text("All your data will be deleted.\nThis action is irreversible.\nDon't forget to cancel your subscription in the App Store settings."),
                                primaryButton: Alert.Button.default(Text("Yes"), action: {
                                    showConfirmationDeleteAccountAlert = true
                                    showDeleteAccountAlert = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        showDeleteAccountFlow = true
                                    }
                                }),
                                secondaryButton: Alert.Button.cancel(Text("No"), action: {
                                    showDeleteAccountAlert = false
                                })
                            )
                        }
                        
                        return Alert(
                            title: Text("Are you sure you want to delete your account?"),
                            primaryButton: Alert.Button.default(Text("Yes"), action: {
                                user.deleteUserAccount()
                                showConfirmationDeleteAccountAlert = false
                            }),
                            secondaryButton: Alert.Button.cancel(Text("No"), action: {
                                showConfirmationDeleteAccountAlert = false
                            })
                        )
                    }
                    .foregroundColor(.red)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        onClose()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Purchases.shared.getCustomerInfo { customerInfo, error in
                DispatchQueue.main.async {
                    if customerInfo?.entitlements.all["premium"]?.isActive == true {
                        isPremium = true
                    }
                }
            }
        }
    }
}
