
import SwiftUI

// TODOX: fix go premium screen + display premium somewhere
// TODOX: find a way to make Maurice actually good!
// TODO: scroll fetch messages
// TODO: add firebase analytics
// TODO: support iOS 15

struct HomeView: View {
    @EnvironmentObject var user: User
    @State private var showSignInViewAfterLogOut = false

    var body: some View {
        HStack {
            if showSignInViewAfterLogOut {
                SignInView()
            } else {
                if user.loading && user.firebaseAuthToken == nil {
                    ProgressView()
                } else {
                    if user.firebaseAuthToken == nil {
                        SignInView()
                    } else {
                        MauriceView()
                    }
                }
            }
        }
        .onChange(of: user.firebaseAuthToken) { newFirebaseAuthToken in
            if user.firstCall {
                print("first call")
                return
            }
            
            if newFirebaseAuthToken != nil {
                return
            }
            
            DispatchQueue.main.async {
                showSignInViewAfterLogOut = true
            }
        }
    }
}
