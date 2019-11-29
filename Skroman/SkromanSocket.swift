//
//  SkromanSocket.swift
//  Skroman
//
//  Created by ananadmahajan on 7/03/19.
//  Copyright © 2018 admin. All rights reserved.
//
import UIKit

protocol SkromanSocketDelegate: class {
    func success()
    func failure()
}

class SkromanSocket: NSObject {
    
    weak var delegate: SkromanSocketDelegate?
    var inputStream: InputStream!
    var outputStream: OutputStream!
    let maxReadLength = 1024*10
    
    func setupNetworkCommunication() {
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           "192.168.4.1" as CFString,
                                           54312,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        outputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .defaultRunLoopMode)
        outputStream.schedule(in: .current, forMode: .defaultRunLoopMode)
        
        inputStream.open()
        outputStream.open()
        
    }
    
    func configureDevice(jsonString: String) {
        
        let data = jsonString.data(using: .ascii)!
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
    
    func stopChatSession() {
        inputStream.close()
        outputStream.close()
    }
    
}

extension SkromanSocket: StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        SSLog(message: "aStream aStream : \(aStream.streamError)")
        
        
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            print("new message received")
            readAvailableBytes(stream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            stopChatSession()
        case Stream.Event.errorOccurred:
            print("error occurred")
            delegate?.failure()
        case Stream.Event.hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            
            if numberOfBytesRead < 0 {
                if let _ = inputStream.streamError {
                    stopChatSession()
                    delegate?.failure()
                    break
                }
            }
            
            processedMessageString(buffer: buffer, length: numberOfBytesRead)
        }
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>, length: Int) {
        guard let string = String(bytesNoCopy: buffer,
                                  length: length,
                                  encoding: .ascii,
                                  freeWhenDone: true) else {
                                    return
        }
        
        print("response")
        print(string)
        print()
        stopChatSession()
        
        // convert string to json
        // check success or failure
        // depending on that call delegate's success or failure
        
        self.delegate?.success()
        
        
//        let parameters = NSMutableDictionary()
//        parameters.setValue("123123", forKey: "dev_id")
//        parameters.setValue(VVBaseUserDefaults.getCurrentSSID(), forKey: "ssid")
//        parameters.setValue(VVBaseUserDefaults.getCurrentPASSWORD(), forKey: "password")
//        parameters.setValue("slide", forKey: "dev_type")
//        parameters.setValue("123444", forKey: "homeid")
//        parameters.setValue(VVBaseUserDefaults.getCurrentPIID(), forKey: "piid")
//        parameters.setValue("32413123", forKey: "roomid")
//        parameters.setValue("123123123", forKey: "name")
//
//        SSLog(message: parameters)
//
//        let str = Utility.JSONValue(object: parameters)
//        SSLog(message: str ?? "")
//
//        let jsonNew = Utility.convertToDictionary(text: str!)
//        SSLog(message: jsonNew)
//
//        if let name = jsonNew?["name"] { // The `?` is here because our `convertStringToDictionary` function returns an Optional
//            SSLog(message: name)
//        }
        
    }
    
}
