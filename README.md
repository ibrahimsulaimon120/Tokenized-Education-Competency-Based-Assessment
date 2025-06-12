# Tokenized Education Competency-Based Assessment System

A comprehensive blockchain-based system for managing competency-based education assessments, built on the Stacks blockchain using Clarity smart contracts.

## Overview

This system provides a decentralized platform for educational institutions to manage competency assessments, track student progress, recommend learning pathways, and issue verifiable certifications. All data is stored on-chain, ensuring transparency, immutability, and verifiability.

## Features

### 🎓 Core Components

1. **Competency Assessor Verification**
    - Register and verify qualified assessors
    - Track assessor performance and ratings
    - Manage assessor authorization and deactivation

2. **Skill Evaluation System**
    - Submit and store competency evaluations
    - Track student progress across multiple attempts
    - Automated pass/fail determination based on configurable thresholds

3. **Mastery Tracking**
    - Monitor student progress across competencies
    - Define competency prerequisites and relationships
    - Track mastery status and completion dates

4. **Pathway Recommendations**
    - Create personalized learning pathways
    - Generate AI-driven recommendations based on student progress
    - Manage pathway prerequisites and difficulty levels

5. **Certification Issuance**
    - Issue blockchain-verified certifications
    - Create certification templates with requirements
    - Manage certification validity and revocation

## Smart Contracts

### Competency Assessor Contract (\`competency-assessor.clar\`)
Manages the registration, verification, and authorization of competency assessors.

**Key Functions:**
- \`register-assessor\`: Register as a new assessor
- \`verify-assessor\`: Verify assessor credentials (owner only)
- \`deactivate-assessor\`: Deactivate an assessor
- \`is-verified-assessor\`: Check if assessor is verified

### Skill Evaluation Contract (\`skill-evaluation.clar\`)
Handles competency evaluations and scoring.

**Key Functions:**
- \`submit-evaluation\`: Submit a competency evaluation
- \`get-evaluation\`: Retrieve evaluation details
- \`get-student-competency\`: Get student's competency record

### Mastery Tracking Contract (\`mastery-tracking.clar\`)
Tracks student progress and competency mastery.

**Key Functions:**
- \`register-student\`: Register a new student
- \`define-competency\`: Define a new competency
- \`update-mastery-progress\`: Update student's mastery progress

### Pathway Recommendation Contract (\`pathway-recommendation.clar\`)
Provides personalized learning pathway recommendations.

**Key Functions:**
- \`create-pathway\`: Create a new learning pathway
- \`generate-recommendations\`: Generate pathway recommendations
- \`enroll-in-pathway\`: Enroll student in a pathway

### Certification Issuance Contract (\`certification-issuance.clar\`)
Issues and manages competency certifications.

**Key Functions:**
- \`create-certification-template\`: Create certification template
- \`issue-certification\`: Issue a new certification
- \`verify-certification\`: Verify certification validity
- \`revoke-certification\`: Revoke a certification

## Installation

### Prerequisites
- Node.js (v16 or higher)
- Clarinet CLI
- Stacks CLI

### Setup

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd tokenized-education-assessment
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Initialize Clarinet project:
   \`\`\`bash
   clarinet new education-assessment
   cd education-assessment
   \`\`\`

4. Copy contract files to the \`contracts\` directory

5. Update \`Clarinet.toml\` with contract configurations

## Testing

Run the test suite using Vitest:

\`\`\`bash
npm test
\`\`\`

Run specific test files:
\`\`\`bash
npm test competency-assessor.test.js
npm test skill-evaluation.test.js
npm test mastery-tracking.test.js
npm test pathway-recommendation.test.js
npm test certification-issuance.test.js
\`\`\`

## Usage Examples

### Register as an Assessor
\`\`\`clarity
(contract-call? .competency-assessor register-assessor
"Dr. Jane Smith"
"Computer Science"
u4)
\`\`\`

### Submit an Evaluation
\`\`\`clarity
(contract-call? .skill-evaluation submit-evaluation
'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
"javascript-basics"
u85
u100
"Excellent understanding of core concepts")
\`\`\`

### Issue a Certification
\`\`\`clarity
(contract-call? .certification-issuance issue-certification
'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
(list "html-css" "javascript-basics" "react-fundamentals")
"Web Development"
(some u365))
\`\`\`

## Data Models

### Assessor Profile
- Name and specialization
- Certification level
- Active status and verification date
- Performance statistics

### Student Competency Record
- Current and best scores
- Number of attempts
- Mastery status and dates
- Progress tracking

### Certification
- Student and issuer information
- Competency requirements
- Validity period and status
- Blockchain verification hash

## Security Features

- **Access Control**: Role-based permissions for different user types
- **Data Integrity**: Immutable blockchain storage
- **Verification**: Cryptographic hashes for certification verification
- **Authorization**: Multi-level approval processes

## Roadmap

- [ ] Integration with external learning management systems
- [ ] Advanced analytics and reporting dashboard
- [ ] Mobile application for students and assessors
- [ ] AI-powered competency gap analysis
- [ ] Multi-institutional certification recognition
- [ ] Gamification features and achievement badges

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please open an issue in the GitHub repository or contact the development team.

---

**Built with ❤️ for the future of education**
