# Blockchain-Based Security Surveillance Network Coordination

A comprehensive blockchain solution for coordinating security surveillance networks, built on the Stacks blockchain using Clarity smart contracts.

## Overview

This system provides a decentralized platform for managing security surveillance networks, including provider verification, camera management, incident detection, response coordination, and evidence management with immutable chain of custody tracking.

## Features

### 🔐 Security Provider Verification
- Provider registration and verification system
- License validation and compliance tracking
- Rating and reputation management
- Automated verification workflows

### 📹 Camera Network Management
- Decentralized camera registration and management
- Access control and permission management
- Real-time status monitoring
- Location-based camera organization

### 🚨 Incident Detection & Reporting
- Automated incident detection and reporting
- Severity classification system
- Real-time incident status tracking
- Integration with camera networks

### 🚑 Response Coordination
- Response team registration and management
- Automated dispatch and assignment
- Priority-based response coordination
- Real-time status updates

### 📋 Evidence Management
- Immutable evidence collection and storage
- Chain of custody tracking
- Access logging and audit trails
- Cryptographic integrity verification

## Smart Contracts

### 1. Security Provider Verification (`security-provider-verification.clar`)
Manages the verification and registration of security service providers.

**Key Functions:**
- \`register-provider\`: Register a new security provider
- \`verify-provider\`: Verify a provider (owner only)
- \`rate-provider\`: Rate a verified provider
- \`get-provider-status\`: Get provider information
- \`is-verified-provider\`: Check verification status

### 2. Camera Network (`camera-network.clar`)
Manages surveillance camera networks and their configurations.

**Key Functions:**
- \`register-camera\`: Register a new camera
- \`update-camera-status\`: Update camera operational status
- \`grant-camera-access\`: Grant access permissions
- \`get-camera-info\`: Retrieve camera information
- \`has-camera-access\`: Check access permissions

### 3. Incident Detection (`incident-detection.clar`)
Handles security incident detection and reporting.

**Key Functions:**
- \`report-incident\`: Report a new security incident
- \`update-incident-status\`: Update incident status
- \`record-response\`: Record incident response
- \`get-incident\`: Retrieve incident details
- \`get-total-incidents\`: Get incident statistics

### 4. Response Coordination (`response-coordination.clar`)
Coordinates security responses and resource allocation.

**Key Functions:**
- \`register-team\`: Register a response team
- \`assign-team-to-incident\`: Assign team to incident
- \`update-response-status\`: Update response status
- \`update-team-availability\`: Manage team availability
- \`get-assignment\`: Retrieve assignment details

### 5. Evidence Management (`evidence-management.clar`)
Manages surveillance evidence with chain of custody tracking.

**Key Functions:**
- \`collect-evidence\`: Collect and register evidence
- \`update-evidence-status\`: Update evidence status
- \`log-evidence-access\`: Log evidence access
- \`get-evidence\`: Retrieve evidence records
- \`get-custody-entry\`: Get chain of custody entries

## Installation

### Prerequisites
- Node.js (v16 or higher)
- Clarinet CLI
- Stacks Wallet

### Setup
1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd blockchain-security-surveillance
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Initialize Clarinet project:
   \`\`\`bash
   clarinet new security-surveillance
   \`\`\`

4. Deploy contracts:
   \`\`\`bash
   clarinet deploy
   \`\`\`

## Testing

Run the test suite using Vitest:

\`\`\`bash
npm test
\`\`\`

Run specific test files:
\`\`\`bash
npm test security-provider-verification.test.js
npm test camera-network.test.js
npm test incident-detection.test.js
npm test response-coordination.test.js
npm test evidence-management.test.js
\`\`\`

## Usage Examples

### Register a Security Provider
\`\`\`clarity
(contract-call? .security-provider-verification register-provider "SEC-001-2024" "security@provider.com")
\`\`\`

### Register a Camera
\`\`\`clarity
(contract-call? .camera-network register-camera "CAM-001" "Main Street Corner")
\`\`\`

### Report an Incident
\`\`\`clarity
(contract-call? .incident-detection report-incident "INC-001" "CAM-001" u3 "Main Street" "Suspicious activity detected")
\`\`\`

### Collect Evidence
\`\`\`clarity
(contract-call? .evidence-management collect-evidence "EVD-001" "INC-001" "CAM-001" u1 "hash123..." "Security footage")
\`\`\`

## Data Models

### Provider Status
- \`0\`: Pending verification
- \`1\`: Verified
- \`2\`: Suspended

### Camera Status
- \`0\`: Offline
- \`1\`: Online
- \`2\`: Maintenance

### Incident Severity
- \`1\`: Low
- \`2\`: Medium
- \`3\`: High
- \`4\`: Critical

### Evidence Types
- \`1\`: Video
- \`2\`: Image
- \`3\`: Audio
- \`4\`: Document

## Security Considerations

- All contracts implement proper access controls
- Evidence integrity is maintained through cryptographic hashing
- Chain of custody is immutable and auditable
- Provider verification prevents unauthorized access
- Permission-based camera access control

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository or contact the development team.

## Roadmap

- [ ] Integration with IoT camera devices
- [ ] Mobile application for field personnel
- [ ] Advanced analytics and reporting
- [ ] Multi-chain deployment support
- [ ] AI-powered incident detection
- [ ] Real-time notification system
