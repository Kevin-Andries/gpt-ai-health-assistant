import Foundation
import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

struct SignInView: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]?
    @State private var currentNonce: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Text("Please sign in to speak with Maurice")
                .font(.headline)
                .foregroundColor(.gray)
            SignInWithAppleButton(.signIn, onRequest: { request in
                let nonce = FirebaseAuthFunctions.randomNonceString()
                currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = FirebaseAuthFunctions.sha256(nonce)
            }, onCompletion: { result in
                switch result {
                case .success(let authResult):
                    switch authResult.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        guard let nonce = currentNonce else {
                            fatalError("Invalid state: A login callback was received, but no login request was sent.")
                        }
                        guard let appleIDToken = appleIDCredential.identityToken else {
                            print("Unable to fetch identity token")
                            return
                        }
                        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                            return
                        }
                        
                        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                                       rawNonce: nonce,
                                                                       fullName: appleIDCredential.fullName)
                        
                        Auth.auth().signIn(with: credential) { (authResult, error) in
                            if error != nil {
                                print("error")
                                return
                            }
                            
                            print("Log in with apple")
                            onboardingSteps?.append(.name)
                        }
                        
                    default:
                        break
                    }
                    
                case .failure(let error):
                    print("Sign in with Apple error: \(error)")
                }
            })
            .signInWithAppleButtonStyle(.black)
            .frame(height: 45)
            .padding()
            VStack(alignment: .center, spacing: 2) {
                HStack {
                    Text("If you continue, you agree to our")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                    
                    Link("Terms & Conditions", destination: URL(string: "https://mauriceai.com/terms-and-conditions.html")!)
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Text("and our")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                    
                    Link("Privacy Policy", destination: URL(string: "https://mauriceai.com/privacy-policy.html")!)
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]?>) {
        self._onboardingSteps = onboardingSteps
    }
    init() {
        self.init(onboardingSteps: .constant(nil))
    }
}

extension Binding {
    func asOptional() -> Binding<Value?> {
        Binding<Value?>(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue ?? self.wrappedValue
            }
        )
    }
}
