////
////  SettingsViewModel.swift
////  IoT-Air-Quality-iOS
////
////  Created by HyungJun Lee on 5/21/25.
////
//
//import Foundation
//
//@MainActor
//final class SettingsViewModel: ObservableObject {
//    // MARK: - 기본 프로젝트 참여
//    @Published var projectList: [ProjectListDTO.Project] = []
//    @Published var selectedProjectId: Int?
//    @Published var isRegistered: Bool = false
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//
//    // MARK: - 약관 동의
//    struct Term: Identifiable {
//        let id = UUID()
//        let type: String
//        let title: String
//        let content: String
//    }
//
//    @Published var terms: [Term] = []
//    @Published var agreement: [String: Bool] = [:]
//    @Published var selectedTermContent: String?
//    @Published var showingTermSheet: Bool = false
//
//    // MARK: - WebView 열기 상태
//    enum WebType {
//        case kibana, metadata
//    }
//
//    @Published var openURL: URL? = nil
//    @Published var showProjectInfo: Bool = false
//
//    // MARK: - 조건 검사
//    var isAgreementComplete: Bool {
//        terms.allSatisfy { agreement[$0.type] == true }
//    }
//
//    // MARK: - 프로젝트 리스트 불러오기
//    func fetchProjects() async {
//        isLoading = true
//        errorMessage = nil
//        do {
//            let response: ProjectListDTO = try await APIClient.shared.request(
//                endpoint: AirQualityEndpoints.fetchProjects.path,
//                method: AirQualityEndpoints.fetchProjects.method.rawValue,
//                responseType: ProjectListDTO.self
//            )
//            self.projectList = response.data.projectList
//        } catch {
//            self.errorMessage = "프로젝트 목록을 불러오지 못했습니다."
//        }
//        isLoading = false
//    }
//
//    // MARK: - 약관 불러오기
//    func fetchTerms() async {
//        do {
//            let response: TermsDTO = try await APIClient.shared.request(
//                endpoint: AirQualityEndpoints.fetchTerms.path,
//                method: AirQualityEndpoints.fetchTerms.method.rawValue,
//                responseType: TermsDTO.self
//            )
//            self.terms = response.data.terms.map {
//                Term(type: $0.type, title: $0.title ?? $0.type, content: $0.content)
//            }
//            self.agreement = Dictionary(uniqueKeysWithValues: terms.map { ($0.type, false) })
//        } catch {
//            self.errorMessage = "약관 정보를 불러오지 못했습니다."
//        }
//    }
//
//    // MARK: - 프로젝트 참여 등록
//    func registerToSelectedProject() async {
//        guard let projectId = selectedProjectId else {
//            self.errorMessage = "프로젝트를 선택하세요."
//            return
//        }
//
//        isLoading = true
//        errorMessage = nil
//
//        do {
//            struct RegisterResponse: Codable {
//                let success: Bool
//                let data: RegisterResult
//                let error: String?
//
//                struct RegisterResult: Codable {
//                    let participated: Bool
//                }
//            }
//
//            let response: RegisterResponse = try await APIClient.shared.request(
//                endpoint: AirQualityEndpoints.joinProject(projectId: projectId).path,
//                method: AirQualityEndpoints.joinProject(projectId: projectId).method.rawValue,
//                responseType: RegisterResponse.self
//            )
//
//            isRegistered = response.data.participated
//        } catch {
//            self.errorMessage = "프로젝트 등록 중 오류가 발생했습니다."
//        }
//
//        isLoading = false
//    }
//
//    // MARK: - 초기화
//    func resetSelection() {
//        selectedProjectId = nil
//        agreement.keys.forEach { agreement[$0] = false }
//        isRegistered = false
//        errorMessage = nil
//    }
//
//    // MARK: - WebView 열기
//    @Published var openWebLink: IdentifiableURL? = nil
//    
//    func openWebView(type: WebType) {
//        let targetURL: URL?
//        switch type {
//        case .kibana:
//            targetURL = URL(string: "https://kibana.example.com")
//        case .metadata:
//            targetURL = URL(string: "https://metadata.example.com/form")
//        }
//        if let url = targetURL {
//            openWebLink = IdentifiableURL(url: url)
//        }
//    }
//
//}
