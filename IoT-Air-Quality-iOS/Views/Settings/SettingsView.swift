//
//  SettingsView.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/28/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedProjectId: Int? = nil
    @State private var showProjectInfo = false
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showingTermIndex: IdentifiableInt? = nil

    let termsTitles = [
        "Privacy Policy",
        "Terms of Service",
        "Consent of Health",
        "Consent of Air Data",
        "Location Data Terms of Service"
    ]

    var body: some View {
        settingsContent
            .onAppear {
                viewModel.fetchProjects {
                    if let first = viewModel.projectList.first {
                        selectedProjectId = first.id
                    }
                }
                viewModel.loadTerms()
            }
    }

    var settingsContent: some View {
        VStack(spacing: 16) {
            // 로그아웃 버튼
            HStack {
                Spacer()
                Button("Logout") {
                    appState.isLoggedIn = false
                    appState.nextScreen = .login
                    TokenManager.shared.clearTokens()
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 15))
            }

            // 로고 및 드롭다운
            Image("app_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Spacer()

            Text("Project Selection")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)

            HStack {
                Picker("Select a project", selection: $selectedProjectId) {
                    ForEach(viewModel.projectList, id: \.id) { project in
                        Text(project.projectTitle).tag(project.id as Int?)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)

                Button(action: {
                    if let id = selectedProjectId {
                        viewModel.fetchProjectDetail(projectId: id) {
                            showProjectInfo = true
                        }
                    }
                }) {
                    Image(systemName: "info.circle")
                }
                .padding(.trailing, 20)
            }

            // Kibana / Metadata 버튼
            VStack(spacing: 16) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "link")
                        Text("View data on Web")
                    }
                }
                .buttonStyle(.bordered)

                Button(action: {}) {
                    HStack {
                        Image(systemName: "link")
                        Text("Input Meta Data on Web")
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()

            // 약관 및 버튼
            VStack(alignment: .leading, spacing: 10) {
                ForEach(0..<5, id: \ .self) { index in
                    HStack {
                        Text(termsTitles[index])
                        Spacer()
                        Button("[View]") {
                            showingTermIndex = IdentifiableInt(value: index)
                        }
                        Toggle("", isOn: $viewModel.agreements[index])
                            .labelsHidden()
                            .disabled(false)
                        // 프로젝트 등록 여부에 따라 달라져야 함. 현재 임시처리
//                            .disabled(viewModel.getProjectInfo(for: selectedProject) != nil)
                    }
                }
            }
            .padding(.horizontal)

            HStack(spacing: 16) {
                Button(action: {
                    viewModel.resetAgreements()
                }) {
                    Text("Reset")
                        .font(.title)
                        .frame(maxWidth: .infinity, minHeight: 55)
                }
                .buttonStyle(.bordered)
                // 프로젝트 등록 여부에 따라 달라져야 함. 현재 임시처리
//                .disabled(viewModel.getProjectInfo(for: selectedProject) != nil)

                Button(action: {
                    if let id = selectedProjectId {
                        viewModel.participateInProject(projectId: id) { success in
                            // 등록 결과 처리
                        }
                    }
                }) {
                    // + 눌렀을 때 DisconnectedView의 isProjectJoined가 바뀌어야 함.
                    // 프로젝트 등록 여부에 따라 달라져야 함. 현재 임시처리
//                    Text(viewModel.getProjectInfo(for: selectedProject) != nil ? "Registered" : "Register")
                    Text("Register")
                        .font(.title)
                        .frame(maxWidth: .infinity, minHeight: 55)
                }
                .buttonStyle(.borderedProminent)
                // 프로젝트 등록 여부에 따라 달라져야 함. 현재 임시처리
                .disabled(!viewModel.allAgreed /*|| viewModel.getProjectInfo(for: selectedProject) != nil*/)
            }
            .padding(.horizontal)

            Spacer()
        }
        .sheet(item: $showingTermIndex) { identifiable in
            ScrollView {
                Text(viewModel.contentFor(index: identifiable.value))
                    .padding()
            }
        }
        .sheet(isPresented: $showProjectInfo) {
            if let info = viewModel.selectedProjectDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Metadata Section
                        Text("📌 Project Information")
                            .font(.title2).bold()

                        ForEach(info.metadataFields, id: \.label) { field in
                            HStack {
                                Text(field.label)
                                Spacer()
                                Text(field.value)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Divider()

                        // Personal Info Section
                        Text("🔐 Personal Information").bold()

                        ForEach(info.personalFields, id: \.label) { field in
                            HStack {
                                Text(field.label)
                                Spacer()
                                Image(systemName: field.value ? "checkmark.square" : "square")
                                    .foregroundColor(.blue)
                            }
                        }

                        Divider()

                        // Health Data Section
                        Text("💓 Health Data").bold()

                        ForEach(info.healthFields, id: \.label) { field in
                            HStack {
                                Text(field.label)
                                Spacer()
                                Image(systemName: field.value ? "checkmark.square" : "square")
                                    .foregroundColor(.blue)
                            }
                        }

                        Divider()

                        // Air Quality Data Section
                        Text("🌫️ Air Quality Data").bold()

                        ForEach(info.airFields, id: \.label) { field in
                            HStack {
                                Text(field.label)
                                Spacer()
                                Image(systemName: field.value ? "checkmark.square" : "square")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                }
            } else {
                ProgressView()
            }
        }
    }
}

struct AirQualitySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppState())
    }
}
