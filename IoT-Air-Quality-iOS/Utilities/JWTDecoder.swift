import Foundation

struct JWTDecoder {
    static func decodeRole(from accessToken: String) -> String? {
        let segments = accessToken.split(separator: ".")
        guard segments.count == 3 else { return nil }

        let payloadSegment = segments[1]
        var base64 = String(payloadSegment)
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        while base64.count % 4 != 0 {
            base64 += "="
        }

        guard let payloadData = Data(base64Encoded: base64),
              let payloadJSON = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
              let role = payloadJSON["rol"] as? String ?? payloadJSON["role"] as? String else {
            return nil
        }

        return role
    }
}
