import Foundation
import SwiftUI
import RevenueCat

struct MyDataView: View {
    @EnvironmentObject var user: User
    let onClose: () -> Void
    let onCloseAndSave: () -> Void
    
    @State private var firstname = ""
    @State private var foodPreferences = ""
    @State private var foodAllergies = ""
    @State private var isPremium = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $firstname)
                    if firstname.isEmpty {
                        Text("Maurice needs to know your name!")
                            .foregroundColor(.red)
                    }
                } header: {
                    Text("Personal information")
                }
                
                Section {
                    TextEditor(text: $foodPreferences)
                        .frame(height: 100)
                    
                } header: {
                    Text("Food preferences")
                }
                
                Section {
                    TextEditor(text: $foodAllergies)
                        .frame(height: 100)
                } header: {
                    Text("Food allergies")
                }
                
                Section {
                    if !isPremium {
                        Text("Unlock full potential & unlimited messages!")
                        Button("Go premium") {
                            onClose()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                user.showGoPremiumSheet = true
                            }
                        }
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onClose()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onCloseAndSave()
                        
                        if firstname == user.userData.first_name &&
                            foodPreferences == user.userData.health_info.preferences &&
                            foodAllergies == user.userData.health_info.allergies {
                            return
                        }
                            
                        
                        Api.updateUserData(token: user.firebaseAuthToken! , firstName: firstname, foodAllergies: foodAllergies, foodPreferences: foodPreferences, completion: {
                            DispatchQueue.main.async {
                                user.userData.first_name = firstname
                                user.userData.health_info.preferences = foodPreferences
                                user.userData.health_info.allergies = foodAllergies
                            }
                        })
                        
                    }
                    .disabled(firstname.isEmpty)
                }
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            firstname = user.userData.first_name
            foodPreferences = user.userData.health_info.preferences
            foodAllergies = user.userData.health_info.allergies
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
