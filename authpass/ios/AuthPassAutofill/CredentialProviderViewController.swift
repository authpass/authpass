//
//  CredentialProviderViewController.swift
//  AuthPassAutofill
//
//  Created by Herbert Poul on 19.02.24.
//  Copyright © 2024 The Chromium Authors. All rights reserved.
//

import AuthenticationServices
import Flutter


class CredentialProviderViewController: ASCredentialProviderViewController {
    
    lazy var flutterEngine = FlutterEngine(name: "my flutter engine", project: nil, allowHeadlessExecution: false)
    
    override func viewDidLoad() {
        showFlutter()
    }
    
    func showFlutter() {
        print("CredentialProviderViewController calling flutterEngine.run()")
        flutterEngine.run(withEntrypoint: nil, initialRoute: "/autofill")
        print("CredentialProviderViewController flutterEngine.run() finished.")
        GeneratedPluginRegistrant.register(with: flutterEngine)
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        flutterViewController.isViewOpaque = false
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.view.frame = view.bounds
        self.view.layoutSubviews()
        print("CredentialProviderViewController showing flutter view.. \(flutterViewController.isDisplayingFlutterUI)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("CredentialProviderViewController viewWillAppear(\(animated)) -- \(flutterEngine.viewController?.isDisplayingFlutterUI)")
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("CredentialProviderViewController viewDidAppear(\(animated)) \(flutterEngine.viewController?.isDisplayingFlutterUI)")
        super.viewDidAppear(animated)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        print("CredentialProviderViewController viewIsAppearing(\(animated)) \(flutterEngine.viewController?.isDisplayingFlutterUI)")
        super.viewIsAppearing(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("CredentialProviderViewController viewWillTransition to: \(size)")
        super.viewWillTransition(to: size, with: coordinator)
    }

    /*
     Prepare your UI to list available credentials for the user to choose from. The items in
     'serviceIdentifiers' describe the service the user is logging in to, so your extension can
     prioritize the most relevant credentials in the list.
    */
    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
    }

    /*
     Implement this method if your extension supports showing credentials in the QuickType bar.
     When the user selects a credential from your app, this method will be called with the
     ASPasswordCredentialIdentity your app has previously saved to the ASCredentialIdentityStore.
     Provide the password by completing the extension request with the associated ASPasswordCredential.
     If using the credential would require showing custom UI for authenticating the user, cancel
     the request with error code ASExtensionError.userInteractionRequired.

    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
        let databaseIsUnlocked = true
        if (databaseIsUnlocked) {
            let passwordCredential = ASPasswordCredential(user: "j_appleseed", password: "apple1234")
            self.extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
        } else {
            self.extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code:ASExtensionError.userInteractionRequired.rawValue))
        }
    }
    */

    /*
     Implement this method if provideCredentialWithoutUserInteraction(for:) can fail with
     ASExtensionError.userInteractionRequired. In this case, the system may present your extension's
     UI and call this method. Show appropriate UI for authenticating the user then provide the password
     by completing the extension request with the associated ASPasswordCredential.

    override func prepareInterfaceToProvideCredential(for credentialIdentity: ASPasswordCredentialIdentity) {
    }
    */

    @IBAction func cancel(_ sender: AnyObject?) {
        self.extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue))
    }

    @IBAction func passwordSelected(_ sender: AnyObject?) {
        let passwordCredential = ASPasswordCredential(user: "j_appleseed", password: "apple1234")
        self.extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
    }

}
