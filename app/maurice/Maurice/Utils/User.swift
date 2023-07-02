import SwiftUI
import CloudKit
import FirebaseAuth

struct UserDataHealthInfoObject: Decodable {
    var preferences: String
    var allergies: String
}

struct UserDataObject: Decodable {
    var first_name: String
    var health_info: UserDataHealthInfoObject
    var total_requests_count: Int
}

class User: ObservableObject {
    @Published var firebaseUser: FirebaseAuth.User?
    @Published var firebaseAuthToken: String?
    @Published var userData: UserDataObject
    @Published var loading = true
    @Published var showGoPremiumSheet = false
    @Published var firstCall = true
    
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        self.userData = UserDataObject(
            first_name: "",
            health_info: UserDataHealthInfoObject(
                preferences: "",
                allergies: ""
            ),
            total_requests_count: 0
        )
        addUserStateChangeListener()
    }
    
    deinit {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func addUserStateChangeListener() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { auth, updatedUser in
            if updatedUser == nil {
                print("updated user is nil")
                self.loading = false
                return
            }
            
            self.firebaseUser = updatedUser
            self.fetchFirebaseAuthToken()
        }
    }
    
    private func fetchFirebaseAuthToken() {
        firebaseUser?.getIDToken { idToken, error in
            self.loading = false
            
            if let error = error {
                print("Error getting ID token: \(error)")
                return
            }
            
            if idToken == nil {
                print("id token is nil")
                return
            }
            
            print(idToken)
            
            self.firebaseAuthToken = idToken
            self.getUserData() // User is connected, we fetch their data from the backend
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.firstCall = false
            }
        }
    }
    
    func getUserData() {
        Api.fetchUserData(token: self.firebaseAuthToken!) { userDataObject in
            guard let userDataObject = userDataObject else { return }
            self.userData = userDataObject
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.firebaseUser = nil
                self.firebaseAuthToken = nil
            }
        } catch let error {
            print("Error signing out: \(error)")
        }
    }
    
    func deleteUserAccount() {
        Api.deleteUserAccount(token: self.firebaseAuthToken!) {
            self.firebaseUser?.delete()
            DispatchQueue.main.async {
                self.firebaseUser = nil
                self.firebaseAuthToken = nil
            }
        }
    }
}
