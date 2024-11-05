//
//  aegis_benchmarkApp.swift
//  aegis-benchmark
//
//  Created by Frank Denis on 10/21/24.
//

import SwiftUI
import CryptoKit

@main
struct aegis_benchmarkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    static func main() {
        let ret_init = aegis_init()
        _ = ret_init
        let size = 262144
        let iterations = 10_000_00
        let state = UnsafeMutableRawBufferPointer.allocate(
            byteCount: size, alignment: 64)
        let c = state.baseAddress
        let m = state.baseAddress
        let mac = state.baseAddress
        let key = state.baseAddress
        let nonce = state.baseAddress
        let ad = state.baseAddress
        
        var now = NSDate()
        var rounds = 0
        while rounds < iterations {
            aegis128x2_encrypt_detached(
                c, mac, 32, m, size, ad, 0, nonce, key)
            rounds += 1
        }
        var elapsed = -(now.timeIntervalSinceNow)
        var throughput =
            ((Double(size) * Double(iterations) / elapsed) * 8 / 1_000_000_000)
        print("AEGIS-128X2: \(throughput) Gb/s")
        
        now = NSDate()
        rounds = 0
        while rounds < iterations {
            aegis256x2_encrypt_detached(
                c, mac, 32, m, size, ad, 0, nonce, key)
            rounds += 1
        }
        elapsed = -(now.timeIntervalSinceNow)
        throughput =
            ((Double(size) * Double(iterations) / elapsed) * 8 / 1_000_000_000)
        print("AEGIS-256X2: \(throughput) Gb/s")
                
        var key2 = SymmetricKey(size: .bits128)
        let nonce2 = AES.GCM.Nonce.init()
        let plain =  Array<UInt8>(repeating:0, count:size)
        now = NSDate()
        rounds = 0
        
        while rounds < iterations {
            _ = try! AES.GCM.seal(plain, using: key2, nonce: nonce2)
            rounds += 1
        }
        elapsed = -(now.timeIntervalSinceNow)
        throughput =
            ((Double(size) * Double(iterations) / elapsed) * 8 / 1_000_000_000)
        print("AES128-GCM: \(throughput) Gb/s")
        
        key2 = SymmetricKey(size: .bits256)
        now = NSDate()
        rounds = 0
        
        while rounds < iterations {
            _ = try! AES.GCM.seal(plain, using: key2, nonce: nonce2)
            rounds += 1
        }
        elapsed = -(now.timeIntervalSinceNow)
        throughput =
            ((Double(size) * Double(iterations) / elapsed) * 8 / 1_000_000_000)
        print("AES256-GCM: \(throughput) Gb/s")
    }
}
