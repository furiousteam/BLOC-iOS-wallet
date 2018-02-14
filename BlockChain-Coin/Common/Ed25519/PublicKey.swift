import CEd25519

public final class PublicKey: NSObject, NSCoding {
    private let buffer: [UInt8]
    
    public convenience init(_ bytes: [UInt8]) throws {
        guard bytes.count == 32 else {
            throw Ed25519Error.invalidPublicKeyLength
        }
        
        self.init(unchecked: bytes)
    }
    
    init(unchecked buffer: [UInt8]) {
        self.buffer = buffer
    }
    
    public var bytes: [UInt8] {
        return buffer
    }

    public func verify(signature: [UInt8], message: [UInt8]) throws -> Bool {
        guard signature.count == 64 else {
            throw Ed25519Error.invalidSignatureLength
        }

        return signature.withUnsafeBufferPointer { signature in
            message.withUnsafeBufferPointer { msg in
                buffer.withUnsafeBufferPointer { pub in
                    ed25519_verify(signature.baseAddress,
                                   msg.baseAddress,
                                   message.count,
                                   pub.baseAddress) == 1
                }
            }
        }
    }

    public func add(scalar: [UInt8]) throws -> PublicKey {
        guard scalar.count == 32 else {
            throw Ed25519Error.invalidScalarLength
        }
        
        var pub = buffer
        
        pub.withUnsafeMutableBufferPointer { pub in
            scalar.withUnsafeBufferPointer { scalar in
                ed25519_add_scalar(pub.baseAddress,
                                   nil,
                                   scalar.baseAddress)
            }
        }
        
        return PublicKey(unchecked: pub)
    }
    
    public init?(coder aDecoder: NSCoder) {
        guard let bytesData = aDecoder.decodeObject(forKey: "bytes") as? NSData else { return nil }
        
        self.buffer = Array(UnsafeBufferPointer(start: bytesData.bytes.assumingMemoryBound(to: UInt8.self), count: bytesData.length))
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(NSData(bytes: bytes, length: bytes.count), forKey: "bytes")
    }
}
