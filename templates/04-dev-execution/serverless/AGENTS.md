# AI Agent Guidelines - Serverless Project

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **AWS Lambda**: https://docs.aws.amazon.com/lambda/
- **AWS SAM**: https://docs.aws.amazon.com/serverless-application-model/
- **Serverless Framework**: https://www.serverless.com/framework/docs
- **API Gateway**: https://docs.aws.amazon.com/apigateway/
- **DynamoDB**: https://docs.aws.amazon.com/dynamodb/

**Why**: Serverless platforms evolve rapidly. This project uses:
- Check serverless.yml or template.yaml for runtime versions
- Lambda runtimes: Node.js 20.x, Python 3.12, or custom

### Version-Specific Syntax Enforcement

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **Lambda Handler** | https://docs.aws.amazon.com/lambda/latest/dg/nodejs-handler.html | Handler signature changes |
| **API Gateway Events** | https://docs.aws.amazon.com/lambda/latest/dg/services-apigateway.html | Event structure evolves |
| **IAM Policies** | https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html | Policy syntax strictness |
| **CloudFormation** | https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/ | Resource types added |

**Enforcement Rules**:
1. Functions must be stateless (no local storage persistence)
2. Optimize for cold starts (minimize dependencies)
3. Use environment variables for configuration
4. Set appropriate timeout and memory limits

## Code Style Rules
1. **Stateless**: No shared state between invocations
2. **Idempotent**: Same input = same output (handle retries)
3. **Async**: Use async/await for I/O operations
4. **Error Handling**: Return proper HTTP status codes
5. **Logging**: Use structured logging (JSON)

## Infrastructure as Code
- **AWS SAM**: `template.yaml` defines resources
- **Serverless Framework**: `serverless.yml` configuration
- **Deploy**: `sam deploy` or `serverless deploy`
- **Local Testing**: `sam local start-api`

## Database
- **DynamoDB**: NoSQL database (pay-per-use)
- **RDS Proxy**: For relational databases (connection pooling)
- **No Long Connections**: Use connection pooling or DynamoDB

## Testing
- **Unit**: Jest or pytest for handler logic
- **Integration**: SAM local invoke or Serverless offline
- **E2E**: Deploy to test stage

## Security
- **IAM**: Least privilege principle (function-specific roles)
- **Secrets**: Use AWS Secrets Manager or Parameter Store
- **API Keys**: API Gateway API keys for public endpoints
- ❌ No secrets in environment variables (use Secrets Manager)

## Build Commands
- **SAM**: `sam build && sam deploy`
- **Serverless**: `serverless deploy`
- **Local**: `sam local start-api` or `serverless offline`
- **Logs**: `sam logs` or `serverless logs -f functionName`

## Performance
- **Cold Starts**: Minimize package size, use provisioned concurrency
- **Memory**: Right-size memory (CPU scales with memory)
- **Timeouts**: Set realistic timeout (max 15 minutes for Lambda)
- **Concurrent Executions**: Monitor throttling
