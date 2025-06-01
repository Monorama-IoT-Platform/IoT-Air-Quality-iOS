//
//  SettingViewModel.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/28/25.
//
//

import Foundation
import Combine

struct EmptyData: Decodable {}

final class SettingsViewModel: ObservableObject {
    private let baseURL = APIConstants.baseURL

    @Published var projectList: [Project] = []
    @Published var agreements: [Bool] = Array(repeating: false, count: 5)
    @Published var terms: [Int: String] = [:]

    var allAgreed: Bool {
        agreements.allSatisfy { $0 }
    }

    func loadTerms() {
        for i in 0..<5 {
            terms[i] = "Sample content for term \(i + 1)."
        }
    }

    func contentFor(index: Int) -> String {
        return terms[index] ?? ""
    }

    func resetAgreements() {
        agreements = Array(repeating: false, count: 5)
    }

    func getProjectInfo(for title: String) -> Project? {
        return projectList.first(where: { $0.projectTitle == title })
    }

    func fetchProjects(completion: (() -> Void)? = nil) {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("❌ Access token 없음")
            return
        }

        guard let url = URL(string: "\(baseURL)/api/v1/air-quality-data/projects") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ 네트워크 오류: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ServerResponse<ProjectListData>.self, from: data)
                DispatchQueue.main.async {
                    self.projectList = decoded.data.projectList
                    print("✅ 불러온 프로젝트 목록:")
                    self.projectList.forEach { print("• \($0.projectTitle)") }
                    completion?()
                }
            } catch {
                print("❌ 디코딩 실패: \(error)")
            }
        }.resume()
    }

    func participateInProject(projectId: Int, completion: @escaping (Bool) -> Void) {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("❌ Access token 없음")
            completion(false)
            return
        }

        guard let url = URL(string: "\(baseURL)/api/v1/air-quality-data/projects/\(projectId)/participation") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ 참여 요청 실패: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ServerResponse<EmptyData>.self, from: data)
                completion(decoded.success)
            } catch {
                print("❌ 디코딩 실패: \(error)")
                completion(false)
            }
        }.resume()
    }
}
