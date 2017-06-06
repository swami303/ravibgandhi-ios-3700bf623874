//
//  XMPPController.swift
//  CrazyMessages
//
//  Created by Andres on 7/21/16.
//  Copyright © 2016 Andres. All rights reserved.
//

import Foundation
import XMPPFramework

enum XMPPControllerError: Error {
	case wrongUserJID
}

class XMPPController: NSObject {
	var xmppStream: XMPPStream
	
	let hostName: String
	let userJID: XMPPJID
	let hostPort: UInt16
	let password: String
	let custObj: customClassViewController = customClassViewController()
	init(hostName: String, userJIDString: String, hostPort: UInt16 = 5222, password: String) throws {
        guard let userJID = XMPPJID(string: userJIDString) else {
			throw XMPPControllerError.wrongUserJID
		}
		
		self.hostName = hostName
		self.userJID = userJID
		self.hostPort = hostPort
		self.password = password
		
		// Stream Configuration
		self.xmppStream = XMPPStream()
		self.xmppStream.hostName = hostName
		self.xmppStream.hostPort = hostPort
		self.xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
		self.xmppStream.myJID = userJID
		
		super.init()
		
		self.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
	}
	
	func connect() {
		if !self.xmppStream.isDisconnected() {
			return
		}

        try! self.xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
        self.xmppStream.enableBackgroundingOnSocket = true;
	}
    func disConnect() {
        self.xmppStream.disconnect()
        let presence = XMPPPresence(type: "unavailable")
        self.xmppStream.send(presence)
    }
}

extension XMPPController: XMPPStreamDelegate {
	
	func xmppStreamDidConnect(_ stream: XMPPStream!) {
		print("Stream: Connected")
		try! stream.authenticate(withPassword: self.password)
	}
	
	func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
		self.xmppStream.send(XMPPPresence())
		print("Stream: Authenticated")
	}
	
	func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
		print("Stream: Fail to Authenticate")
	}
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!)
    {
        var deleObj: AppDelegate!
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        print("Did receive message \(message)")
        let state: UIApplicationState = UIApplication.shared.applicationState // or use  let state =  UIApplication.sharedApplication().applicationState
        if state == .background || state == .inactive
        {
            return
        }
        if state == .active
        {
            let dictMessage: NSDictionary!
            let body = message.elements(forName: "body")
            let strBody: String = body[0].stringValue!
            dictMessage = convertToDictionary(text: strBody) as NSDictionary!
            print(dictMessage)
            if dictMessage.object(forKey: "FromUserID") as! String == deleObj.currentUserIdForChat
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMsg"), object: dictMessage)
            }
            else
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showMsgNoti"), object: dictMessage)
            }
        }
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!)
    {
        print("Did send message \(message)")
        let dictMessage: NSDictionary!
        let body = message.elements(forName: "body")
        let strBody: String = body[0].stringValue!
        dictMessage = convertToDictionary(text: strBody) as NSDictionary!
        print(dictMessage)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMsg"), object: dictMessage)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
