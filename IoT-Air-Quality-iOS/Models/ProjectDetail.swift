//
//  ProjectDetailDTO.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/26/25.
//



struct ProjectDetailDTO: Codable {
    let success: Bool
    let data: ProjectDetail
    let error: String?

    struct ProjectDetail: Codable {
        let projectTitle: String
        let participant: Int
        let description: String
        let startDate: String
        let endDate: String
        let createdDate: String
        let email: Bool
        let gender: Bool
        let phoneNumber: Bool
        let dataOfBirth: Bool
        let bloodType: Bool
        let height: Bool
        let weight: Bool
        let name: Bool
        let pm25Value: Bool
        let pm25Level: Bool
        let pm10Value: Bool
        let pm10Level: Bool
        let temperature: Bool
        let temperatureLevel: Bool
        let humidity: Bool
        let humidityLevel: Bool
        let co2Value: Bool
        let co2Level: Bool
        let vocValue: Bool
        let vocLevel: Bool
        let latitude: Bool
        let longitude: Bool
    }
}
