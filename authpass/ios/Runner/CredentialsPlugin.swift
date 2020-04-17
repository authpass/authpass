//
//  CredentialsPlugin.swift
//  Runner
//
//  Created by Herbert Poul on 16.04.20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import AuthenticationServices

@available(iOS 12.0, *)
class CredentialsPlugin {
    let store = ASCredentialIdentityStore.shared
    
    init(_ channel: FlutterMethodChannel) {
        channel.setMethodCallHandler { (call, result) in
            switch(call.method) {
            case "isAvailable":
                result(1);
            case "isEnabled":
                self.store.getState { (state) in
                    result(state.isEnabled ? 1 : 0)
                }
            case "sync":
                self.store.removeAllCredentialIdentities { (done, err) in
                    if let err = err {
                        print("Error while removing credentials. \(err)")
                        result(FlutterError(code: "ERROR", message: "Error while removing credentials \(err)", details: nil))
                        return
                    }
                    let identity = ASPasswordCredentialIdentity(serviceIdentifier: ASCredentialServiceIdentifier(identifier: "", type: .domain), user: "", recordIdentifier: "")
                    self.store.saveCredentialIdentities([identity]) { (bool, err) in
                        if let err = err {
                            result(FlutterError(code: "ERROR", message: "Error while storing credentials. \(err)", details: nil))
                            return
                        }
                        result(1)
                    }
                }
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
