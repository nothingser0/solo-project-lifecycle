# JSON Schemas

Validation schemas for solo-project-lifecycle template outputs.

## Available Schemas

### 1. **idea-brief.schema.json**
**Module**: M01 (Idea & Feasibility)  
**Purpose**: Validates project idea brief with feasibility scoring  
**Key fields**: projectName, elevatorPitch, coreLoop, scaleClassification, feasibilityScore

### 2. **scope-statement.schema.json**
**Module**: M02 (Discovery & Scope)  
**Purpose**: Validates project scope definition with boundaries  
**Key fields**: inScope, outOfScope, assumptions, constraints, successCriteria

### 3. **todo.schema.json**
**Module**: M06 (Development Execution)  
**Purpose**: Validates AI-generated development checklist  
**Key fields**: phases, tasks, completionStats, milestones, blockers

### 4. **uat-signoff.schema.json**
**Module**: M09 (UAT & Client Sign-Off)  
**Purpose**: Validates client acceptance testing sign-off  
**Key fields**: clientPIC, testResults, defectSummary, signoffStatus

### 5. **sit-workbook.schema.json**
**Module**: M07 (Quality Assurance)  
**Purpose**: Validates system integration testing workbook  
**Key fields**: testSuites, integrationTests, securityAudit, overallStatus

## Usage

### With AI Agents
Agents can validate generated documents before presenting to users:

```javascript
const schema = require('./schemas/idea-brief.schema.json');
const Ajv = require('ajv');
const ajv = new Ajv();
const validate = ajv.compile(schema);

const valid = validate(generatedDocument);
if (!valid) console.log(validate.errors);
```

### With IDEs
Add to VSCode settings for autocomplete:

```json
{
  "json.schemas": [
    {
      "fileMatch": ["**/IDEA_BRIEF.json"],
      "url": "./schemas/idea-brief.schema.json"
    },
    {
      "fileMatch": ["**/TODO.json"],
      "url": "./schemas/todo.schema.json"
    }
  ]
}
```

### With CI/CD
Validate documents before merging:

```bash
ajv validate -s schemas/uat-signoff.schema.json -d docs/pm/UAT_SIGNOFF_REPORT.json
```

## Schema Standards

- **JSON Schema Draft 07** specification
- All required fields explicitly marked
- Enums for controlled vocabularies
- Pattern validation for structured strings
- Format validation (date, email, uri)
- Minimum/maximum constraints for numbers

## Future Schemas

Planned additions:
- `fsd.schema.json` (Functional Specification)
- `prd.schema.json` (Product Requirements)
- `sow-contract.schema.json` (Statement of Work)
- `bast.schema.json` (Handover Certificate)
