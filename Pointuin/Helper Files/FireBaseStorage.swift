//
//  FireBaseStorage.swift
//  Tinder App
//
//  Created by Kingsley Charles on 17/04/2021.
//
import UIKit
import Foundation
import FirebaseStorage

extension UIButton {
    
    func saveFirebaseStorage(for image: UIImage, completion: @escaping (String) -> ()) {
            let filename = UUID().uuidString
            guard let uploadData = image.jpegData(compressionQuality: 0.25) else {return}
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let storeImage = storageRef.child("images/\(filename)")
            storeImage.putData(uploadData, metadata: nil) { (metadata, err) in
                if let err = err {
                    print(err)
                    return
                }
                
                storeImage.downloadURL { (url, err) in
                    guard let url = url?.absoluteString else {return}
                    completion(url)
                }
            }
        }
    
    
}
