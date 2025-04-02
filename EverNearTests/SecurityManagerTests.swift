import XCTest
@testable import EverNear

class SecurityManagerTests: XCTestCase {
    
    var securityManager: SecurityManager!
    
    override func setUp() {
        super.setUp()
        securityManager = SecurityManager.shared
    }
    
    func testEncryptDecryptData() {
        // Given
        let originalString = "This is sensitive data that needs to be encrypted"
        let originalData = originalString.data(using: .utf8)!
        let encryptionKey = "TestEncryptionKey123"
        
        // When
        let encryptedData = securityManager.encryptData(originalData, withKey: encryptionKey)
        XCTAssertNotNil(encryptedData)
        
        let decryptedData = securityManager.decryptData(encryptedData!, withKey: encryptionKey)
        XCTAssertNotNil(decryptedData)
        
        // Then
        let decryptedString = String(data: decryptedData!, encoding: .utf8)
        XCTAssertEqual(decryptedString, originalString)
    }
    
    func testEncryptDecryptWithWrongKey() {
        // Given
        let originalString = "This is sensitive data that needs to be encrypted"
        let originalData = originalString.data(using: .utf8)!
        let encryptionKey = "CorrectKey123"
        let wrongKey = "WrongKey456"
        
        // When
        let encryptedData = securityManager.encryptData(originalData, withKey: encryptionKey)
        XCTAssertNotNil(encryptedData)
        
        let decryptedData = securityManager.decryptData(encryptedData!, withKey: wrongKey)
        XCTAssertNotNil(decryptedData)
        
        // Then
        let decryptedString = String(data: decryptedData!, encoding: .utf8)
        XCTAssertNotEqual(decryptedString, originalString)
    }
    
    func testBiometricAuthentication() {
        // Given
        let expectation = self.expectation(description: "Biometric authentication")
        
        // When
        securityManager.setupBiometricAuthentication { success, error in
            // Then
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSecureUserDefaults() {
        // Given
        let key = "secureTestKey"
        let stringValue = "Secure String Value"
        let boolValue = true
        let dataValue = "Test Data".data(using: .utf8)!
        
        // When - String
        securityManager.secureUserDefaults(key: key + "_string", value: stringValue)
        let retrievedString = securityManager.retrieveSecureUserDefaults(key: key + "_string") as? String
        
        // Then - String
        XCTAssertEqual(retrievedString, stringValue)
        
        // When - Bool
        securityManager.secureUserDefaults(key: key + "_bool", value: boolValue)
        let retrievedBool = securityManager.retrieveSecureUserDefaults(key: key + "_bool") as? Bool
        
        // Then - Bool
        XCTAssertEqual(retrievedBool, boolValue)
        
        // When - Data
        securityManager.secureUserDefaults(key: key + "_data", value: dataValue)
        let retrievedData = securityManager.retrieveSecureUserDefaults(key: key + "_data") as? Data
        
        // Then - Data
        XCTAssertEqual(retrievedData, dataValue)
    }
    
    func testAnonymizeData() {
        // Given
        let sensitiveData: [String: Any] = [
            "name": "John Doe",
            "email": "john@example.com",
            "phone": "123-456-7890",
            "address": "123 Main St",
            "location": "New York",
            "age": 35,
            "preferences": "Private data"
        ]
        
        // When
        let anonymizedData = securityManager.anonymizeData(sensitiveData)
        
        // Then
        XCTAssertEqual(anonymizedData["name"] as? String, "REDACTED")
        XCTAssertEqual(anonymizedData["email"] as? String, "REDACTED")
        XCTAssertEqual(anonymizedData["phone"] as? String, "REDACTED")
        XCTAssertEqual(anonymizedData["address"] as? String, "REDACTED")
        XCTAssertEqual(anonymizedData["location"] as? String, "REDACTED")
        XCTAssertEqual(anonymizedData["age"] as? Int, 35)
        XCTAssertEqual(anonymizedData["preferences"] as? String, "Private data")
    }
    
    func testCheckJailbreak() {
        // When
        let isJailbroken = securityManager.checkJailbreak()
        
        // Then
        // In a simulator or non-jailbroken device, this should return false
        XCTAssertFalse(isJailbroken)
    }
}
