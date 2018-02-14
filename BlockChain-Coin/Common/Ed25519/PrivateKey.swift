import CEd25519

public final class PrivateKey: NSObject, NSCoding {
    private let buffer: [UInt8]
    
    public init(_ bytes: [UInt8]) throws {
        guard bytes.count == 64 else {
            throw Ed25519Error.invalidPrivateKeyLength
        }
        
        self.buffer = bytes
    }
    
    init(unchecked buffer: [UInt8]) {
        self.buffer = buffer
    }
    
    public var bytes: [UInt8] {
        return buffer
    }
    
    public func add(scalar: [UInt8]) throws -> PrivateKey {
        guard scalar.count == 32 else {
            throw Ed25519Error.invalidScalarLength
        }

        var priv = buffer
        
        priv.withUnsafeMutableBufferPointer { priv in
            scalar.withUnsafeBufferPointer { scalar in
                ed25519_add_scalar(nil,
                                   priv.baseAddress,
                                   scalar.baseAddress)
            }
        }
        
        return PrivateKey(unchecked: priv)
    }
    
    public init?(coder aDecoder: NSCoder) {
        guard let bytesData = aDecoder.decodeObject(forKey: "bytes") as? NSData else { return nil }
        
        self.buffer = Array(UnsafeBufferPointer(start: bytesData.bytes.assumingMemoryBound(to: UInt8.self), count: bytesData.length))
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(NSData(bytes: bytes, length: bytes.count), forKey: "bytes")
    }
}
