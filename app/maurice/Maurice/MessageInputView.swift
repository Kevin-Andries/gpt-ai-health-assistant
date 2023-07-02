import CardinalKitFHIR
import CardinalKitSecureStorage
import OpenAI
import SwiftUI
import RevenueCat

struct MessageInputView: View {
    @EnvironmentObject var user: User
    @Binding var query: String
    @Binding var messages: [Message]
    @EnvironmentObject var secureStorage: SecureStorage<FHIR>
    @State private var userText = ""
    @State private var isQuerying = false
    @State private var showingSheet = false
    @State private var showErrorAlert = false
    @State private var showMaxFreeCapacityAlert = false
    
    var body: some View {
        HStack {
            TextField(
                isQuerying ? "Maurice is typing 🤔..." : "Type a message...",
                text: $userText,
                axis: .vertical
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .lineLimit(1...5)
            .disabled(isQuerying == true)
            
            if isQuerying {
                ProgressView()
                    .padding(.horizontal, 10)
            } else {
                Button(action: {
                    Purchases.shared.getCustomerInfo { customerInfo, error in
                        // If user has reached maximum free capacity and is not premium
                        if user.userData.total_requests_count >= 20 && !(customerInfo?.entitlements.all["premium"]?.isActive == true) {
                            UIApplication.shared.hideKeyboard()
                            showMaxFreeCapacityAlert = true
                            return
                        }
                        
                        // Add new message to the list
                        let newMessage = Message(message: userText)
                        messages.append(newMessage)
                        
                        isQuerying = true
                        query = userText
                        userText = ""
                        
                        Api.askAssistant(token: user.firebaseAuthToken!, query: query) { responseObject in
                            let message = responseObject.message
                            let newTotalRequestsCount = responseObject.total_requests_count
                            messages.append(message)
                            isQuerying = false
                            user.userData.total_requests_count = newTotalRequestsCount
                            
                            if newTotalRequestsCount >= 20 && !(customerInfo?.entitlements.all["premium"]?.isActive == true) {
                                UIApplication.shared.hideKeyboard()
                                showMaxFreeCapacityAlert = true
                            }
                        }
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .padding(.horizontal, 10)
                        .foregroundColor(
                            userText.isEmpty ? Color(.systemGray6) : Color(.blue)
                        )
                }
                .disabled(userText.isEmpty)
                
            }
        }
        .padding(10)
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Oops..."),
                message: Text("Something went wrong :/ Please try again"),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showMaxFreeCapacityAlert) {
            Alert(
                title: Text("You have reached the message limit"),
                message: Text("Go premium to continue and unlock the full potential of Maurice <3"),
                primaryButton: .cancel(Text("Go premium")) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        user.showGoPremiumSheet = true
                    }
                },
                secondaryButton: .default(Text("Cancel")) {
                    showMaxFreeCapacityAlert = false
                }
            )
        }
    }
}
