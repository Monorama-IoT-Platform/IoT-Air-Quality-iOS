struct SignupRegisterRequest: Codable {
    let name: String
    let email: String
    let gender: String
    let phoneNumber: String
    let nationalCode: String
    let dateOfBirth: String
    let bloodType: String
    let height: Double
    let weight: Double
}