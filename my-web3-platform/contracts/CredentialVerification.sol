// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CredentialVerification {

    // Structure to represent a digital certificate
    struct Certificate {
        address recipient;      // Address of the certificate recipient
        string courseName;      // Name of the course or degree
        uint256 issueDate;      // Timestamp of when the certificate was issued
        bool isValid;           // Flag indicating whether the certificate is valid
    }

    // Mapping to store certificates by their unique identifier (e.g., certificate hash)
    mapping(bytes32 => Certificate) public certificates;

    // Event to notify when a new certificate is issued
    event CertificateIssued(address indexed recipient, string courseName, uint256 issueDate, bytes32 certificateHash);

    // Function to issue a new digital certificate
    function issueCertificate(address recipient, string memory courseName) public {
        require(recipient != address(0), "Invalid recipient address");
        
        // Generate a unique identifier for the certificate (you might want to use a hash of the certificate details)
        bytes32 certificateHash = keccak256(abi.encodePacked(recipient, courseName, block.timestamp));

        // Check if the certificate already exists
        require(certificates[certificateHash].recipient == address(0), "Certificate already issued");

        // Create the certificate
        Certificate memory newCertificate = Certificate({
            recipient: recipient,
            courseName: courseName,
            issueDate: block.timestamp,
            isValid: true
        });

        // Store the certificate in the mapping
        certificates[certificateHash] = newCertificate;

        // Emit an event to notify the issuance of a new certificate
        emit CertificateIssued(recipient, courseName, block.timestamp, certificateHash);
    }

    // Function to verify the authenticity of a certificate
    function verifyCertificate(bytes32 certificateHash) public view returns (bool) {
        // Check if the certificate exists
        return certificates[certificateHash].isValid;
    }
}
