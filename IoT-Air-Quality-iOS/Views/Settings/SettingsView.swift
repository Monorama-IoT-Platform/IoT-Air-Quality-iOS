//
//  AirQualitySettingsView.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/28/25.
//


import SwiftUI

struct AirQualitySettingsView: View {
    @State private var selectedProject: String = ""
    @State private var projectList: [String] = ["Loading..."]
    @State private var showProjectInfo = false
    @StateObject private var viewModel = SignupTermsViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showingTermIndex: IdentifiableInt? = nil

    var body: some View {
        VStack(spacing: 0) {
            // 상단 바
            HStack {
                Spacer()
                Button("Logout") {
                    // 로그아웃 처리 예정
                }
                .padding()
            }

            // 로고 및 드롭다운
            VStack(spacing: 8) {
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("Project Selection")
                    .font(.headline)
                HStack {
                    Picker("Select a project", selection: $selectedProject) {
                        ForEach(projectList, id: \ .self) { project in
                            Text(project)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)

                    Button(action: {
                        showProjectInfo = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .padding()

            // Kibana / Metadata 버튼
            VStack(spacing: 16) {
                Button(action: {
                    // Kibana 웹 링크 이동 예정
                }) {
                    HStack {
                        Image(systemName: "link")
                        Text("View data on Web")
                        Spacer()
                    }
                }
                .buttonStyle(.bordered)

                Button(action: {
                    // MetaData 입력 웹 링크 이동 예정
                }) {
                    HStack {
                        Image(systemName: "link")
                        Text("Input Meta Data on Web")
                        Spacer()
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()

            // 약관 및 버튼
            VStack(alignment: .leading, spacing: 10) {
                ForEach(0..<2, id: \ .self) { index in
                    HStack {
                        Text(viewModel.titleFor(index: index))
                        Spacer()
                        Button("[View]") {
                            showingTermIndex = IdentifiableInt(value: index)
                        }
                        Toggle("", isOn: $viewModel.agreements[index])
                            .labelsHidden()
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

                Button(action: {
                    viewModel.determineNextScreen(appState: appState)
                }) {
                    Text("Register")
                        .font(.title)
                        .frame(maxWidth: .infinity, minHeight: 55)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.allAgreed)
            }
            .padding(.horizontal)

            Spacer()

            // 하단 탭바
            HStack {
                Spacer()
                VStack {
                    Image(systemName: "house")
                    Text("Home").font(.caption)
                }
                Spacer()
                VStack {
                    Image(systemName: "clock")
                    Text("History").font(.caption)
                }
                Spacer()
                VStack {
                    Image(systemName: "gear")
                    Text("Setting").font(.caption)
                }
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGray6))
        }
        .sheet(item: $showingTermIndex) { identifiable in
            ScrollView {
                if viewModel.terms[identifiable.value] == nil {
                    VStack {
                        Spacer(minLength: 100)
                        ProgressView("Loading...")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text(viewModel.contentFor(index: identifiable.value))
                        .padding()
                }
            }
        }
        .onAppear {
            viewModel.loadTerms()
            // 실제 프로젝트 목록 API 연동 필요
            projectList = ["Asthma Study", "School Air Quality"]
            selectedProject = projectList.first ?? ""
        }
        .sheet(isPresented: $showProjectInfo) {
            VStack {
                Text("Project Info for \(selectedProject)")
                    .font(.title)
                    .padding()
                Spacer()
            }
        }
    }
}

struct AirQualitySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AirQualitySettingsView()
            .environmentObject(AppState())
    }
}
