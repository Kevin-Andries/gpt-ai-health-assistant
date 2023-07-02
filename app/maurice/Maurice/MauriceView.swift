import HealthKit
import OpenAI
import SwiftUI
import CloudKit
import FirebaseAuth

struct MauriceView: View {
    @EnvironmentObject var user: User
    
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    @AppStorage(StorageKeys.firstLaunch) var firstLaunch = true
    @State private var loadingConversation = true
    
    @State private var query: String = ""
    @State private var messages: [Message] = []
    @State private var showMyDataSheet = false
    @State private var showDataSavedAlert = false
    @State private var showSettingsSheet = false
    
    func dismissMyData() {
        showMyDataSheet.toggle()
    }
    
    func dismissMyDataAndSave() {
        showMyDataSheet.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showDataSavedAlert.toggle()
        }
    }
    
    func dismissSettings() {
        showSettingsSheet = false
    }
    
    func displayWelcomeMessages() {
        let welcomeMsg1 = Message(author: "assistant", message: "Hi, I'm Maurice! It's so good to see you here!")
        let welcomeMsg2 = Message(author: "assistant", message: "From now on, I will be your personal nutritionist, available 24/7 to help you.")
        let welcomeMsg3 = Message(author: "assistant", message: "The more we talk, the more I will get to know you and tailor all my recommendations and advice to your needs specifically. You are my only and favourite patient :)")
        let welcomeMsg4 = Message(author: "assistant", message: "You can start by telling me which goals you have. It can be losing weight, eating healthier, building muscle, or anything!")
        let welcomeMsg5 = Message(author: "assistant", message: "Also, you can add your food preferences and allergies from your profile section, by clicking the profile icon in the top right corner of this app.")
        let welcomeMsg6 = Message(author: "assistant", message: "Let’s get started! What’s your goal these days?")
        
        DispatchQueue.main.async {
            messages.append(welcomeMsg1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            messages.append(welcomeMsg2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            messages.append(welcomeMsg3)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            messages.append(welcomeMsg4)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            messages.append(welcomeMsg5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            messages.append(welcomeMsg6)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if loadingConversation {
                    ProgressView()
                } else {
                    ChatView(messages: $messages)
                        .gesture(
                            TapGesture().onEnded {
                                UIApplication.shared.hideKeyboard()
                            }
                        )
                    MessageInputView(query: $query, messages: $messages)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettingsSheet = true
                    }) {
                        Image(systemName: "gear")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if loadingConversation {
                            return
                        }
                        
                        showMyDataSheet = true
                    }) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(loadingConversation ? .gray : .blue)
                    }
                }
            }
            .navigationBarTitle("Maurice")
            .navigationBarTitleDisplayMode(.inline)
        }.onChange(of: completedOnboardingFlow) { newCompletedOnboardingFlow in
            if !newCompletedOnboardingFlow { return }
            firstLaunch = false
            // Display welcome messages if conversation is empty (first launch)
            displayWelcomeMessages()
        }
        .onAppear {
            // Fetch conversation
            Api.fetchConversation(token: user.firebaseAuthToken!) { fetchedMessages in
                loadingConversation = false
                
                if !completedOnboardingFlow {
                    return
                }
                
                // Display welcome messages if conversation is empty (not first launch)
                if fetchedMessages.count == 0 {
                    displayWelcomeMessages()
                    return
                }
                
                for message in fetchedMessages {
                    DispatchQueue.main.async {
                        messages.append(message)
                    }
                }
            }
        }
        .sheet(isPresented: $showMyDataSheet) {
            MyDataView(onClose: dismissMyData, onCloseAndSave: dismissMyDataAndSave)
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsView(onClose: dismissSettings)
        }
        .sheet(isPresented: $user.showGoPremiumSheet) {
            GoPremiumView()
        }
    }
}
