//
//  SignupTermsService.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/26/25.
//


import Foundation

final class SignupTermsService {
    static let shared = SignupTermsService()
    
    private let baseURL = APIConstants.baseURL
    
    private struct TermsWrapper: Decodable {
        let terms: [Term]
    }
    
    func fetchTerms(accessToken: String, completion: @escaping ([Term]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/air-quality-data/terms") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                print("❌ 약관 조회 실패: \(error?.localizedDescription ?? "unknown error")")
                completion(nil)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(ServerResponse<TermsWrapper>.self, from: data)
                completion(decoded.data.terms)
            } catch {
                print("❌ 약관 디코딩 실패: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
