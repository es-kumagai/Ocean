//
//  DataPacketStream.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/07/12
//  
//

import Foundation

public struct DataPacketStream<DataSequence> where DataSequence : AsyncSequence {
    
    public typealias DataConverter = (_ data: DataSequence.Element) throws -> Data
    public typealias DataSuffixFiller = (_ fillingSize: Int) -> Data
    
    public let source: DataSequence
    public let packetSize: Int
    public let dataConverter: DataConverter
    public let dataSuffixFiller: DataSuffixFiller
    
    public init(source: DataSequence, packetSize: Int, dataConverter: @escaping DataConverter, dataSuffixFiller: @escaping DataSuffixFiller) {

        self.source = source
        self.packetSize = packetSize
        self.dataConverter = dataConverter
        self.dataSuffixFiller = dataSuffixFiller
    }
}

extension DataPacketStream : AsyncSequence {
    
    public typealias Element = Data
        
    public struct Iterator {
        
        var source: DataSequence.AsyncIterator
        let packetSize: Int
        let dataConverter: DataConverter
        let dataSuffixFiller: DataSuffixFiller

        private var carriedData: Data
        
        init(source: DataSequence.AsyncIterator, packetSize: Int, dataConverter: @escaping DataConverter, dataSuffixFiller: @escaping DataSuffixFiller) {
 
            self.source = source
            self.packetSize = packetSize
            self.dataConverter = dataConverter
            self.dataSuffixFiller = dataSuffixFiller

            self.carriedData = Data(capacity: packetSize)
        }
    }
    
    public func makeAsyncIterator() -> Iterator {
        Iterator(source: source.makeAsyncIterator(), packetSize: packetSize, dataConverter: dataConverter, dataSuffixFiller: dataSuffixFiller)
    }
}

extension DataPacketStream.Iterator : AsyncIteratorProtocol {
    
    public mutating func next() async throws -> Data? {
        
        while carriedData.count < packetSize {
            
            guard let data = try await source.next() else {
                
                let carriedDataCount = carriedData.count
                
                return switch carriedDataCount {
                    
                case 0:
                    nil
                    
                default:
                    carriedData.extractAll() + dataSuffixFiller(packetSize - carriedDataCount)
                }
            }
            
            carriedData += try dataConverter(data)
        }
        
        return carriedData.extractFirst(packetSize)
    }
}

public extension DataPacketStream {
    
}

private extension DataPacketStream.Iterator {
    
}
