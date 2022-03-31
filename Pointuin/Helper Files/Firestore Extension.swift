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
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.db.collection("users").document(uid)
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
        
        Firestore.db.collection("sessions").document("\(sessionID)").getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch card user:", err)
                completion(err)
                return
            }
            print(snapshot?.data())
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
        let sessionsRef = db.collection("sessions").document("\(sessionID)")
        
        sessionsRef.updateData([
            "displayNames": FieldValue.arrayUnion([username]),
            "userIds": FieldValue.arrayUnion([uid])
        ]) { err in
            if let err = err {
                completion(err)
                return
            }
            self.addSessionToUserFile(uid: uid, sessionID: "\(sessionID)", completion: completion)
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
            let team = document["team"] as? String ?? ""
            let dict = ["sessionID": sessionID, "sessionStatus": status, "team": team]
            self.updateUserData(uid: uid, dictionary: dict, completion: completion)
            
            //                completion(nil) Might be needed not sure
        }
    }
    
    
    
    func getSessionStory(uid: String,completion: @escaping (String?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.getUserUpdates(uid: uid) { user, err in
            
            if let err = err {
                completion(nil, err)
            }
            
            guard let sessionID = user?.sessionID else {return}
            Firestore.db.collection("sessions").document(sessionID).getDocument { (snapshot, err) in
                
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
    
    func getUserProfileDetails(completion: @escaping (Error?, String?, String?) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.db.collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch card user:", err)
                completion(err,nil, nil)
                return
            }
            
            guard let document = snapshot?.data() else {return}
            let imageUrl = document["profileImageUrl"] as? String ?? ""
            let sessionID = document["sessionID"] as? String ?? nil
            completion(nil, imageUrl,sessionID )
        }
    }
    
    func saveDocument(collection: String,document: String, data: [String: Any]) {
        
        Firestore.db.collection(collection).document(document).setData(data) { err in
            if err != nil {
                return
            }
        }
    }
    
    
    func updateDocument(collection: String,document: String, data: [String: Any]) {
        let query = Firestore.db.collection(collection).document("\(document)")
        
        query.updateData(data) { err in
            if let err = err {
                print("Error updating document: \(err)")
                return
            }
        }
    }
    
    func deleteDocument(collection: String,document: String, data: [String: Any]) {
        let query = Firestore.db.collection(collection).document("\(document)")
        
        query.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    
    func getField(collection: String, document: String,field: String,completion: @escaping (Any?, Error?) -> ()) {
        
        Firestore.db.collection("\(collection)").document("\(document)").getDocument { (snapshot, err) in
            
            if let err = err {
                print("Failed to fetch information:", err)
                completion(nil, err)
                return
            }
            
            guard let document = snapshot?.data() else {return}
            guard let story = document[field] as? String else {return}
            
            completion(story, nil)
        }
    }
    
    
    func updateSessionStatusForUsers(documentID: String, updatedFieldName: String, completion: @escaping (Error?) -> ()) {
        
        self.getField(collection: "sessions", document: "\(documentID)", field: "\(updatedFieldName)") { fieldStatus, err in
            
            let defaultStatus = ""
            let dictionary = ["\(updatedFieldName)": defaultStatus]
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            if let err = err {
                print("Failed to get voting status :", err)
                self.updateUserData(uid: uid, dictionary: dictionary, completion: completion)
                completion(err)
                return
            }
            
            guard let status = fieldStatus as? String else {
                print("Failed to get voting status, the bool value failed :", err)
                self.updateUserData(uid: uid, dictionary: dictionary, completion: completion)
                completion(err)
                return
            }
            
            //This gets all the user uid and updates it
            self.readUpdateFirestoreArray(documentID: "\(documentID)", updatedField: "\(updatedFieldName)", fieldStatus: status, completion: completion)
            
        }
    }
    
    func readUpdateFirestoreArray(documentID: String, updatedField: String , fieldStatus: String ,completion: @escaping (Error?) -> ()) {
        
        Firestore.db.collection("sessions").document("\(documentID)").getDocument { (document, error) in
            
            if let err = error {
                print("Failed to get all user IDs, due to err :", err)
                completion(nil)
                return
            }
            guard let document = document else {return}
            if document.exists {
                
                //get all document data
                guard let documentData = document.data() else {return}
                
                //get value-array for key "userIds"
                guard let element = documentData["userIds"] as? [String] else {return} //print ->
                
                element.forEach({ uid in
                    self.updateUserData(uid: uid, dictionary: ["\(updatedField)": fieldStatus], completion: completion)
                })
            }
        }
    }
    
}

