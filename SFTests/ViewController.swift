//
//  ViewController.swift
//  SFTests
//
//  Created by Hasret Sariyer on 6.01.2021.
//

import UIKit

class ViewController: UIViewController {
    var publickey: SecKey?
    var privatekey: SecKey?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keySize = 1024
        let rsaPublicKeyData = (generateKeyPair(keySize))["public"]
        let exportImportManager = CryptoExportImportManager()
        
        let pemString = exportImportManager.exportRSAPublicKeyToPEM(rsaPublicKeyData!!, keyType: kSecAttrKeyTypeRSA as String, keySize: keySize)
        print(pemString)
    }
    
    func generateKeyPair(_ keySize: Int) -> Dictionary<String, Data?> {
        let publicKeyAttributes: [NSObject: NSObject] = [
                    kSecAttrIsPermanent: true as NSObject,
                    kSecAttrApplicationTag: "comm.exampleAab.ApublicKey" as NSObject,
                    kSecClass: kSecClassKey,
                    kSecReturnData: kCFBooleanTrue
                ]
        let privateKeyAttributes: [NSObject: NSObject] = [
            kSecAttrIsPermanent: true as NSObject,
            kSecAttrApplicationTag: "comm.exampleAab.AprivateKey" as NSObject,
            kSecClass: kSecClassKey,
            kSecReturnData: kCFBooleanTrue
        ]
        
        let keypairAttributes: [NSObject: NSObject] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: keySize as NSObject,
            kSecPublicKeyAttrs: publicKeyAttributes as NSObject,
            kSecPrivateKeyAttrs: privateKeyAttributes as NSObject
        ]
        let privatekeydata: Data?
        let publickeydata: Data?
        
        let status: OSStatus = SecKeyGeneratePair(keypairAttributes as CFDictionary, &publickey, &privatekey)
        
        if status == noErr && publickey != nil && privatekey != nil {
            var _publickey: AnyObject?
            var _privatekey: AnyObject?
            
            let statusPublic: OSStatus = SecItemCopyMatching(publicKeyAttributes as CFDictionary, &_publickey)
            let statusPrivate: OSStatus = SecItemCopyMatching(privateKeyAttributes as CFDictionary, &_privatekey)
            
            if statusPublic == noErr && statusPrivate == noErr {
                privatekeydata = _publickey as? Data
                publickeydata = _privatekey as? Data
                
                return ["public": publickeydata, "private": privatekeydata]
            }
        }
        return [:]
    }
}


