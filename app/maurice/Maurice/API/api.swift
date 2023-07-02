import Foundation
import RevenueCat

class Api {
    static var API_URL = ProcessInfo.processInfo.environment["API_URL"] ?? "https://maurice.herokuapp.com"
    
    static func fetchConversation(token: String, completion:@escaping ([Message]) -> ()) {
        guard let url = URL(string: "\(API_URL)/api/conversation") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add auth token to header
        request.addValue(token, forHTTPHeaderField: "auth_token")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Network error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            guard let data = data else {
                print("Data is nil")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            do {
                let messages = try JSONDecoder().decode([Message].self, from: data)
                DispatchQueue.main.async {
                    completion(messages)
                }
            } catch  {
                print("JSON decoding error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
    
    static func fetchUserData(token: String, completion:@escaping (UserDataObject?) -> ()) {
        guard let url = URL(string: "\(API_URL)/api/user") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add auth token to header
        request.addValue(token, forHTTPHeaderField: "auth_token")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if data == nil {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            do {
                let userDataObject = try JSONDecoder().decode(UserDataObject.self, from: data!)
                
                DispatchQueue.main.async {
                    completion(userDataObject)
                }
            } catch  {
                print("JSON decoding error")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    static func askAssistant(token: String, query: String, completion:@escaping (AssistantReponse) -> ()) {
        Purchases.shared.getCustomerInfo { customerInfo, getCustomerInfoError in
            var request = URLRequest(url: URL(string: "\(API_URL)/api")!)
            request.httpMethod = "POST"
            
            // Add auth token to header
            request.addValue(token, forHTTPHeaderField: "auth_token")
            // Add RevenueCat AppUserID
            request.addValue(customerInfo!.originalAppUserId, forHTTPHeaderField: "rc_app_user_id")
            
            // Set content type
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Add property to the body
            let body: [String: Any] = [
                "message": query
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error: Unable to create JSON data")
                return
            }
            
            URLSession.shared.dataTask(with: request) { (data, _, _) in
                do {
                    let responseObject = try JSONDecoder().decode(AssistantReponse.self, from: data!)
                    // TODO: display smth if error on assistant answer
                    DispatchQueue.main.async {
                        completion(responseObject)
                    }
                } catch {
                    print("Error decoding response from assistant")
                    return
                }
            }.resume()
        }
    }
    static func updateUserData(token: String, firstName: String, foodAllergies: String, foodPreferences: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "\(API_URL)/api/user/info") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        // Add auth token to header
        request.addValue(token, forHTTPHeaderField: "auth_token")
        
        // Set content type
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add property to the body
        let body: [String: Any] = [
            "first_name": firstName,
            "health_info": [
                "preferences": foodPreferences,
                "allergies": foodAllergies
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error: Unable to create JSON data")
            return
        }
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Network error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Response is not an HTTPURLResponse")
                return
            }
            
            if httpResponse.statusCode == 201 {
                print("Update successful")
                completion()
            } else {
                print("Update failed with status code: \(httpResponse.statusCode)")
            }
            
            DispatchQueue.main.async {}
        }.resume()
    }
    
    static func deleteUserAccount(token: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "\(API_URL)/api/user") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Add auth token to header
        request.addValue(token, forHTTPHeaderField: "auth_token")
        
        // Set content type
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (_, _, _) in
            completion()
            DispatchQueue.main.async {}
        }.resume()
    }
}
