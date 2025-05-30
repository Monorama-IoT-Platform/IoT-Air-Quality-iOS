//
//  SignupTermsViewModel.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/26/25.
//

import Foundation

final class SignupTermsViewModel: ObservableObject {
    @Published var terms: [Term?] = [nil, nil] // 2개 고정
    @Published var agreements: [Bool] = Array(repeating: false, count: 2)

    var allAgreed: Bool {
        agreements.allSatisfy { $0 }
    }

    func loadTerms() {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("❌ Access token 없음")
            return
        }

        SignupTermsService.shared.fetchTerms(accessToken: accessToken) { fetchedTerms in
            DispatchQueue.main.async {
                if let fetchedTerms = fetchedTerms {
                    for term in fetchedTerms {
                        if term.type == "privacy-policy" {
                            self.terms[0] = term
                        } else if term.type == "terms-of-service" {
                            self.terms[1] = term
                        }
                    }
                } else {
                    print("❌ 약관 로딩 실패")
                }
            }
        }
    }

    func resetAgreements() {
        agreements = Array(repeating: false, count: 2)
    }

    func titleFor(index: Int) -> String {
        switch index {
        case 0: return "Privacy Policy"
        case 1: return "Terms of Service"
        default: return ""
        }
    }

    func contentFor(index: Int) -> String {
        terms[index]?.content ?? "(내용을 불러올 수 없습니다)"
    }
}

