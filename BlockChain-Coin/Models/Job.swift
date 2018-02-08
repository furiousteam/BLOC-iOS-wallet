//
//  Job.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import NSData_FastHex

protocol JobModel {
    var id: String { get }
    var jobId: String { get }
    var blob: Data { get }
    var target: UInt64 { get }
    var nonce: UInt32 { get set }
}

class Job: JobModel, Decodable {
    let id: String
    let jobId: String
    var blob: Data
    let target: UInt64
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case job = "job"
    }
    
    enum JobCodingKeys: String, CodingKey {
        case blob = "blob"
        case jobId = "job_id"
        case target = "target"
    }

    init(id: String, jobId: String, blob: Data, target: UInt64) {
        self.id = id
        self.jobId = jobId
        self.blob = blob
        self.target = target
    }
    
    var nonce: UInt32 {
        get {
            let start = 39
            let sd = blob.subdata(in: start ..< start + MemoryLayout<UInt32>.size)
            let v = sd.withUnsafeBytes { (a: UnsafePointer<UInt32>) -> UInt32 in a.pointee }
            return v.littleEndian
        }
        
        set {
            let start = 39
            let range: Range<Data.Index> = start ..< start + MemoryLayout<UInt32>.size
            var newBytes = blob.subdata(in: range)
            newBytes.withUnsafeMutableBytes { (a: UnsafeMutablePointer<UInt32>) -> Void in
                a.pointee = newValue.littleEndian
            }
            blob.replaceSubrange(range, with: newBytes)
        }
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)

        let jobValues = try values.nestedContainer(keyedBy: JobCodingKeys.self, forKey: .job)
        jobId = try jobValues.decode(String.self, forKey: .jobId)
        
        let blobString = try jobValues.decode(String.self, forKey: .blob)
        blob = NSData(hexString: blobString) as Data
        
        let targetString = try jobValues.decode(String.self, forKey: .target)
        let targetLength = targetString.utf8.count
        let targetData = NSData(hexString: targetString) as Data
        
        if targetLength <= 8 {
            target = targetData.withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt64 in
                return 0xFFFFFFFFFFFFFFFF / (0xFFFFFFFF / UInt64(ptr.pointee))
            }
        } else if targetLength <= 16 {
            target = targetData.withUnsafeBytes { (ptr: UnsafePointer<UInt64>) -> UInt64 in
                return ptr.pointee
            }
        } else {
            target = 0
        }
    }
}
