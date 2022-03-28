//
//  FIRDatabase.swift
//  Tinder App
//
//  Created by Kingsley Charles on 15/05/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import RxSwift

extension Firestore {
    
    static let db = Firestore.firestore()
    
    func getUserUpdates(uid: String,completion: @escaping (User?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                
                guard let dictionary = document.data() else {
                    print("Document data was empty.")
                    let error = NSError(domain: "com.lbta.swipematch", code: 500, userInfo: [NSLocalizedDescriptionKey: "No user found in Firestore"])
                    completion(nil, error)
                    return
                }
                
                let user = User(uid: uid, dictionary: dictionary)
                completion(user, nil)
            }
    }
    
    
    func checkSessionExists(displayName: String, sessionID: String, passCode: String, completion: @escaping (Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection("sessions").document(sessionID).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch card user:", err)
                completion(err)
                return
            }
            
            guard let document = snapshot?.data() else {return}
            let isSession = document["passcode"] as? String ?? "" == passCode
            
            if isSession {
                self.saveInfoToFirestore(sessionID: sessionID, username: displayName, completion: completion)
                return
            }  else {
                
                let err1: Error = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Pascode doesn't match"])
                completion(err1)
            }
        }
    }
    
    fileprivate func saveInfoToFirestore(sessionID: String, username: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let sessionsRef = db.collection("sessions").document(sessionID)
        
        sessionsRef.updateData([
            "displayNames": FieldValue.arrayUnion([username]),
            "userIds": FieldValue.arrayUnion([uid])
        ]) { err in
            if let err = err {
                completion(err)
                return
            }
            self.addSessionToUserFile(uid: uid, sessionID: sessionID, completion: completion)
        }
        
    }
    
    fileprivate func addSessionToUserFile(uid: String, sessionID: String, completion: @escaping (Error?) -> ())
    {
        let db = Firestore.firestore()
        db.collection("sessions").document(sessionID).getDocument { (snapshot, err) in
            
            if let err = err {
                print("Failed to fetch card user:", err)
                completion(err)
                return
            }
            
            guard let document = snapshot?.data() else {return}
            let status = document["sessionStatus"] as? String ?? "inactive"
            let team = document["team"] as? String ?? "My Team"
            let dict = ["sessionID": sessionID, "sessionStatus": status, "team": team]
            self.updateUserData(uid: uid, dictionary: dict, completion: completion)
            
            //                completion(nil) Might be needed not sure
        }
    }
    
    
    
    func getSessionStory(uid: String,completion: @escaping (String?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        self.getUserUpdates(uid: uid) { user, err in
            
            if let err = err {
                completion(nil, err)
            }
            
            guard let sessionID = user?.sessionID else {return}
            db.collection("sessions").document(sessionID).getDocument { (snapshot, err) in
                
                if let err = err {
                    print("Failed to fetch session:", err)
                    completion(nil, err)
                    return
                }
                
                guard let document = snapshot?.data() else {return}
                guard let story = document["storySummary"] as? String else {return}
                
                completion(story, nil)
            }
            
        }
    }
    
    
    func updateUserData(uid: String, dictionary: [String: Any], completion: @escaping (Error?) -> () ) {
        
        let db = Firestore.firestore()
        let query = db.collection("users").document(uid)
        
        query.updateData(dictionary) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completion(err)
                return
            }
            
            completion(nil)
        }
    }
    
    func getUserProfileDetails(completion: @escaping (Error?, String?) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.db.collection("user").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch card user:", err)
                completion(err,nil)
                return
            }
            
            guard let document = snapshot?.data() else {return}
            let imageUrl = document["profileImageUrl"] as? String ?? ""
            completion(nil, imageUrl)
        }
    }
    
    func saveDocument(collection: String,document: String, data: [String: Any]) {
        
        Firestore.db.collection(collection).document(document).setData(data) { err in
            if err != nil {
                return
            }
            
            
        }
        
    }
}
