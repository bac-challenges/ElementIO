import Foundation

struct Time {
    let h: Int
    let m: Int
}

extension Time {
    
    init(time: String) {
        
        let comp = time.split(separator: ":")
        
        self.init(h: Int(comp[0]) ?? -1,
                  m: Int(comp[1]) ?? -1)
    }
    
    func toString() -> String {
        "\(self.h):\(self.m)".replacingOccurrences(of: "-1", with: "*")
    }
}
