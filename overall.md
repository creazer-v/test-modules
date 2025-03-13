# Saddle - Migration API Modules

## Core Concepts Overview

### Router System: `backend/app/api/v1/router.py`

The router system is a fundamental component of the FastAPI application, providing centralized routing and API endpoint organization. The `router.py` module serves as the main configuration hub for all API routes.

#### Router Configuration
```python
from fastapi import APIRouter
from app.api.v1.endpoints import auth, github, bitbucket, migration, bulk_migration, teams

api_router = APIRouter()

# Authentication Routes
api_router.include_router(
    auth.router,
    prefix="/auth",
    tags=["auth"]
)

# GitHub Integration Routes
api_router.include_router(
    github.router,
    prefix="/github",
    tags=["github"]
)

# Bitbucket Integration Routes
api_router.include_router(
    bitbucket.router,
    prefix="/bitbucket",
    tags=["bitbucket"]
)

# Migration Routes
api_router.include_router(
    migration.router,
    prefix="/migration",
    tags=["migration"]
)

# Bulk Migration Routes
api_router.include_router(
    bulk_migration.router,
    prefix="/migration/bulk",
    tags=["bulk-migration"]
)

# Teams Management Routes
api_router.include_router(
    teams.router,
    prefix="/teams",
    tags=["teams"]
)
```

#### Key Benefits

1. **Modular Organization**
   - Separates routes by functionality
   - Enables independent module development
   - Simplifies maintenance and testing
   - Provides clear code structure

2. **API Versioning**
   - Supports multiple API versions
   - Enables backward compatibility
   - Facilitates API evolution
   - Manages breaking changes

3. **Documentation Benefits**
   - Automatic Swagger UI grouping
   - Clear endpoint categorization
   - Organized API documentation
   - Logical operation tagging

4. **URL Structure**
   - Consistent endpoint patterns
   - Clear route hierarchies
   - Feature-based organization
   - Version-prefixed paths

#### Route Prefixes and Tags

Each router is mounted with specific configurations:
- `/auth` - Authentication and session management
- `/github` - GitHub repository operations
- `/bitbucket` - Bitbucket project management
- `/migration` - Single repository migrations
- `/migration/bulk` - Bulk repository migrations
- `/teams` - Team and permission management

#### Integration with Main Application

The router is integrated into the main FastAPI application:
```python
from fastapi import FastAPI
from app.api.v1.router import api_router

app = FastAPI()
app.include_router(api_router, prefix="/api/v1")
```

This creates the final URL structure:
```
/api/v1/auth/*      - Authentication endpoints
/api/v1/github/*    - GitHub operations
/api/v1/bitbucket/* - Bitbucket operations
/api/v1/migration/* - Migration management
/api/v1/teams/*     - Team management
```

#### Best Practices

1. **Route Organization**
   - Group related endpoints
   - Use consistent naming
   - Maintain clear hierarchy
   - Follow REST principles

2. **Version Management**
   - Clear version prefixes
   - Consistent URL structure
   - Planned deprecation
   - Migration paths

3. **Documentation**
   - Descriptive tags
   - Grouped endpoints
   - Clear descriptions
   - Example responses

4. **Maintenance**
   - Modular updates
   - Easy extensions
   - Simple testing
   - Clear dependencies

### Understanding FastAPI, Uvicorn, and Asynchronous Programming

#### The FastAPI + Uvicorn Stack
FastAPI and Uvicorn work together as a powerful combination for building high-performance web applications:

```
┌─────────────────┐     ┌──────────────┐     ┌─────────────┐
│ Your FastAPI    │     │   Uvicorn    │     │   Client    │
│   Application   │ ←── │    Server    │ ←── │  Requests   │
└─────────────────┘     └──────────────┘     └─────────────┘
```

1. **FastAPI**
   - Modern Python web framework
   - Handles API logic, routing, and data validation
   - Built for high performance and easy development
   - Uses Python type hints for automatic validation

2. **Uvicorn**
   - ASGI server implementation
   - Manages HTTP connections and request handling
   - Provides the runtime environment for FastAPI
   - Handles multiple requests concurrently

3. **Why They Work Well Together**
   - FastAPI is built on ASGI standards
   - Uvicorn provides optimal ASGI implementation
   - Both support modern async Python features
   - Combined for maximum performance

#### Understanding Async/Await in Our Application

1. **What is Async Programming?**
```python
# Synchronous (Blocking) Code
def get_user_data():
    data = database.fetch()  # Waits here, blocking other operations
    return data

# Asynchronous (Non-blocking) Code
async def get_user_data():
    data = await database.fetch()  # Allows other operations while waiting
    return data
```

2. **Key Concepts**
   - **async**: Marks a function as asynchronous
   - **await**: Pauses execution until an async operation completes
   - **Non-blocking**: Other code can run while waiting
   - **Concurrency**: Handle multiple operations simultaneously

3. **Benefits in Our Application**
   - Handle multiple migrations simultaneously
   - Efficient database and API operations
   - Better resource utilization
   - Improved response times

4. **Real-World Example**
```python
# Multiple operations can run concurrently
async def migrate_repository():
    source = await fetch_source_repo()      # Start fetch
    target = await create_target_repo()     # While waiting, start creation
    result = await perform_migration()       # Then perform migration
    return result
```

#### Why This Stack?

1. **Performance Benefits**
   - Handle thousands of concurrent connections
   - Minimal CPU and memory overhead
   - Fast response times
   - Efficient resource utilization

2. **Development Benefits**
   - Clear, maintainable code structure
   - Automatic API documentation
   - Type safety and validation
   - Modern Python features

3. **Production Benefits**
   - Easy scaling
   - Reliable error handling
   - Comprehensive monitoring
   - Security features

## File Structure and Function Documentation

### Backend Files

#### 1. `backend/main.py`
The main entry point of the FastAPI application.

**Key Components:**

1. **Application Setup**
```python
app = FastAPI(
    title="Saddle - Migration API Modules",
    description="API for managing Bitbucket and GitHub repositories",
    version="1.0.0"
)
```
- Initializes the FastAPI application
- Sets up application metadata
- Configures API documentation

2. **Router Configuration**
```python
app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(bulk_migration.router, prefix="/api/v1/migration", tags=["migration"])
app.include_router(migration_history.router, prefix="/api/v1/migration", tags=["migration"])
```
- Mounts authentication endpoints
- Configures migration endpoints
- Sets up history tracking endpoints

3. **Health Check Function**
```python
@app.get("/health", tags=["health"])
async def health_check():
    return {"status": "healthy"}
```
- Provides application health status
- Used for monitoring and load balancing

4. **Redis Session Management**
- **Startup Handler** (`startup_db_client`):
  - Initializes Redis connection
  - Tests connection validity
  - Sets up session management
  - Implements error handling

- **Shutdown Handler** (`shutdown_db_client`):
  - Gracefully closes Redis connection
  - Ensures proper resource cleanup

5. **Server Configuration**
```python
uvicorn.run(
    "main:app",
    host="0.0.0.0",
    port=8000,
    reload=True,
    log_level="debug"
)
```
- Configures Uvicorn ASGI server
- Sets development server parameters
- Enables hot reloading

**Dependencies:**
- FastAPI framework
- Uvicorn ASGI server
- Redis client
- Custom modules:
  - `app.core.config`
  - `app.api.v1.router`
  - `app.api.v1.endpoints`
  - `app.core.cors`
  - `app.core.session`

**Error Handling:**
- Graceful Redis connection failure handling
- Session management fallback mechanisms
- Comprehensive error logging

**API Endpoints:**
1. Authentication (`/api/v1/auth/*`)
2. Bulk Migration (`/api/v1/migration/*`)
3. Migration History (`/api/v1/migration/*`)
4. Health Check (`/health`)

[Note: Additional files will be documented here as they are added to the project]

## Directory Structure
```
backend/
├── main.py              # Main application entry point
├── app/
│   ├── core/           # Core functionality
│   ├── api/            # API endpoints
│   │   └── v1/        # Version 1 API
│   └── ...
```

## Uvicorn Server Details

### What is Uvicorn?
Uvicorn is a lightning-fast ASGI (Asynchronous Server Gateway Interface) server implementation, used to run Python web applications. It's built on top of uvloop and httptools, making it one of the fastest Python servers available.

### Configuration in Our Application
```python
uvicorn.run(
    "main:app",
    host="0.0.0.0",
    port=8000,
    reload=True,
    log_level="debug"
)
```

### Key Features Used:
1. **Hot Reload**
   - Automatically detects code changes
   - Restarts server to apply changes
   - Ideal for development workflow

2. **Host Configuration**
   - `0.0.0.0` allows external access
   - Suitable for both development and production
   - Can be restricted to `127.0.0.1` for local-only access

3. **Logging Levels**
   - Debug level provides detailed information
   - Helps in troubleshooting and development
   - Can be adjusted for production (info/warning)

4. **Performance Features**
   - Async request handling
   - Built on uvloop for enhanced performance
   - Efficient HTTP parsing with httptools

### Production vs Development Settings
```python
# Development
uvicorn.run(
    "main:app",
    host="0.0.0.0",
    port=8000,
    reload=True,
    log_level="debug"
)

# Production (Recommended)
uvicorn.run(
    "main:app",
    host="0.0.0.0",
    port=8000,
    reload=False,
    workers=4,
    log_level="info"
)
```

### Best Practices:
1. **Security**
   - Disable reload in production
   - Use appropriate host binding
   - Configure SSL/TLS in production

2. **Performance**
   - Adjust worker count based on CPU cores
   - Use process manager (e.g., Gunicorn)
   - Enable uvloop for better performance

3. **Logging**
   - Use appropriate log levels
   - Configure log formatting
   - Set up log rotation

4. **Monitoring**
   - Enable access logging
   - Monitor worker processes
   - Track response times

## FastAPI Framework Details

### What is FastAPI?
FastAPI is a modern, fast (high-performance) web framework for building APIs with Python 3.6+ based on standard Python type hints. It's designed to be easy to use, fast to code, ready for production, and automatically documented.

### Key Features in Our Implementation

1. **API Documentation**
```python
app = FastAPI(
    title="Saddle - Migration API Modules",
    description="API for managing Bitbucket and GitHub repositories",
    version="1.0.0"
)
```
- Automatic interactive API documentation (Swagger UI at `/docs`)
- Alternative documentation with ReDoc at `/redoc`
- OpenAPI (formerly Swagger) specification at `/openapi.json`

2. **Type Hints and Validation**
```python
from pydantic import BaseModel

class MigrationRequest(BaseModel):
    source_repo: str
    target_repo: str
    branch: str = "main"
```
- Automatic request and response validation
- JSON Schema generation
- Type checking at runtime

3. **Async Support**
```python
@app.get("/health")
async def health_check():
    return {"status": "healthy"}
```
- Native async/await support
- High concurrency handling
- Non-blocking operations

4. **Router Organization**
```python
app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(bulk_migration.router, prefix="/api/v1/migration", tags=["migration"])
```
- Modular routing system
- API versioning support
- Endpoint grouping and tagging

### Advanced Features Used

1. **Dependency Injection**
- Built-in dependency injection system
- Reusable components
- Simplified testing
```python
async def get_current_user(token: str = Depends(oauth2_scheme)):
    return await verify_token(token)
```

2. **Security Features**
- OAuth2 with Password flow
- JWT tokens
- HTTP Basic auth
```python
from fastapi.security import OAuth2PasswordBearer
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
```

3. **CORS Middleware**
```python
from fastapi.middleware.cors import CORSMiddleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

4. **Exception Handling**
```python
from fastapi import HTTPException

@app.exception_handler(CustomException)
async def custom_exception_handler(request, exc):
    return JSONResponse(
        status_code=418,
        content={"message": str(exc)},
    )
```

### Performance Benefits

1. **Speed Comparisons**
- One of the fastest Python frameworks available
- On par with NodeJS and Go for many operations
- Minimal overhead in request processing

2. **Resource Optimization**
- Efficient memory usage
- Low CPU overhead
- Optimal request handling

### Development Features

1. **Interactive Documentation**
- Real-time API testing
- Request/response examples
- Authentication integration

2. **Code Generation**
- Client SDK generation
- API documentation export
- Type stubs for better IDE support

### Best Practices in Our Implementation

1. **Project Structure**
```
app/
├── api/
│   └── v1/
│       ├── endpoints/
│       └── router.py
├── core/
│   ├── config.py
│   └── security.py
└── models/
    └── migration.py
```

2. **Request Validation**
- Input data validation
- Response data validation
- Custom validators

3. **Error Handling**
- Consistent error responses
- Proper status codes
- Detailed error messages

4. **Security Measures**
- Rate limiting
- Input sanitization
- Secure headers

### Production Considerations

1. **Performance Tuning**
- Response caching
- Background tasks
- Connection pooling

2. **Monitoring**
- Request logging
- Performance metrics
- Error tracking

3. **Security**
- API key management
- Rate limiting
- Input validation

## Application Entry Point: `backend/app/main.py`

### Overview
The main entry point for the FastAPI application, handling core setup, logging configuration, and health checks.

### Key Components

1. **Imports and Initial Setup**
```python
from fastapi import FastAPI
from app.core.config import settings
from app.api.v1.router import api_router
from app.core.cors import setup_cors
import logging
```
- Essential FastAPI components
- Configuration settings
- API routing
- CORS setup
- Logging functionality

2. **Logging Configuration**
```python
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)
```
- Configures application-wide logging
- Sets INFO level logging
- Defines timestamp and message format
- Creates module-specific logger

3. **GitHub Integration Check**
```python
if not settings.GITHUB_PRIVATE_KEY_PATH.exists():
    logger.error(f"GitHub private key not found at: {settings.GITHUB_PRIVATE_KEY_PATH}")
    raise FileNotFoundError(f"GitHub private key not found at: {settings.GITHUB_PRIVATE_KEY_PATH}")
else:
    logger.info(f"Found GitHub private key at: {settings.GITHUB_PRIVATE_KEY_PATH}")
```
- Validates GitHub private key presence
- Early failure if key is missing
- Logs key status for debugging

4. **FastAPI Application Initialization**
```python
app = FastAPI(
    title=settings.APP_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json"
)
```
- Creates FastAPI instance
- Sets application title from settings
- Configures OpenAPI documentation URL

5. **CORS and Router Setup**
```python
setup_cors(app)
app.include_router(api_router, prefix=settings.API_V1_STR)
```
- Enables Cross-Origin Resource Sharing
- Mounts API routes with version prefix

6. **Health Check Endpoint**
```python
@app.get("/health/app")
async def app_health_check():
    """Health check endpoint for the app module"""
    return {
        "status": "healthy",
        "component": "app",
        "version": settings.APP_NAME
    }
```
- Provides application health status
- Returns component information
- Includes version details

### Configuration Details

1. **Environment Variables**
- `APP_NAME`: Application name from settings
- `API_V1_STR`: API version prefix
- `GITHUB_PRIVATE_KEY_PATH`: Path to GitHub credentials

2. **Logging Levels**
- Default: INFO
- Format: Timestamp - Module - Level - Message
- Captures startup and runtime information

3. **API Structure**
- Base URL: Determined by deployment
- API Version: v1 (configurable)
- OpenAPI Docs: `{base_url}/api/v1/openapi.json`

### Security Features

1. **GitHub Integration**
- Private key validation
- Secure key path handling
- Startup validation checks

2. **CORS Configuration**
- Configured through separate module
- Customizable origin policies
- Security headers management

### Health Monitoring

1. **Health Check Response**
```json
{
    "status": "healthy",
    "component": "app",
    "version": "<app_name>"
}
```

2. **Monitoring Points**
- Application status
- Component identification
- Version tracking

### Best Practices Implemented

1. **Error Handling**
- Graceful startup validation
- Comprehensive error logging
- Clear error messages

2. **Configuration Management**
- Centralized settings
- Environment-based configuration
- Secure credential handling

3. **Code Organization**
- Modular structure
- Clear separation of concerns
- Maintainable architecture

4. **Logging Strategy**
- Structured log format
- Appropriate log levels
- Useful debug information

## Authentication Module: `backend/app/api/v1/endpoints/auth.py`

### Overview
This module handles authentication for both Bitbucket and GitHub integrations, managing user sessions and credential validation.

### Key Components

1. **Models and Dependencies**
```python
class BitbucketCredentials(BaseModel):
    username: str
    password: str

class GitHubCallbackRequest(BaseModel):
    code: str
    state: str
```
- Pydantic models for request validation
- Type-safe credential handling
- OAuth callback data structure

### Authentication Endpoints

1. **Bitbucket Authentication**
```python
@router.post("/bitbucket")
async def bitbucket_auth(credentials: BitbucketCredentials, response: Response)
```
- Validates Bitbucket credentials
- Creates authenticated session
- Returns success status and username
- Implements secure credential storage

2. **GitHub OAuth Flow**
```python
@router.get("/github/app")
async def github_app_init(request: Request)

@router.post("/github/callback")
async def github_callback(request: Request, callback_data: GitHubCallbackRequest)
```
- Initializes GitHub OAuth flow
- Handles OAuth callbacks
- Manages state for CSRF protection
- Stores tokens securely

3. **Session Management**
```python
@router.get("/session")
async def get_session_info(session: Optional[Dict[str, Any]])

@router.get("/logout")
async def logout(request: Request, response: Response)
```
- Retrieves current session info
- Handles user logout
- Cleans up session data
- Manages session cookies

### Repository Access Endpoints

1. **Bitbucket Projects**
```python
@router.get("/bitbucket/projects")
async def get_bitbucket_projects(auth: Tuple[str, str])
```
- Lists accessible projects
- Requires authenticated session
- Returns project identifiers

2. **Repository Operations**
```python
@router.get("/bitbucket/projects/{project_key}/repos")
@router.get("/bitbucket/projects/{project_key}/repos/{repo_slug}")
```
- Lists repositories in projects
- Retrieves repository details
- Handles path parameters
- Validates access rights

### Security Features

1. **Token Management**
```python
async def get_github_token(authorization: Optional[str], x_github_token: Optional[str])
```
- Supports multiple auth methods
- Bearer token handling
- Personal Access Token (PAT) support
- Secure token validation

2. **Session Security**
```python
async def get_bitbucket_auth(session: Dict[str, Any])
```
- Session-based authentication
- Credential encryption
- Secure storage handling
- Access control enforcement

### Error Handling

1. **Authentication Errors**
```python
HTTPException(
    status_code=401,
    detail="Invalid credentials"
)
```
- Unauthorized access handling
- Invalid credential responses
- Session validation errors
- Token verification failures

2. **Operation Errors**
```python
HTTPException(
    status_code=500,
    detail=f"Failed to fetch projects: {str(e)}"
)
```
- Service operation failures
- API integration errors
- Resource access issues
- Detailed error messages

### Logging and Monitoring

1. **Authentication Events**
```python
logger.info("Successfully obtained user OAuth token")
logger.error(f"Failed to connect: {str(e)}")
```
- Authentication attempts
- Token operations
- Session management
- Error tracking

2. **Security Events**
```python
logger.warning(f"State mismatch: received {state}")
```
- CSRF attempts
- Invalid tokens
- Session tampering
- Security violations

### Integration Features

1. **Bitbucket Integration**
- Project listing
- Repository access
- Credential validation
- Access control

2. **GitHub Integration**
- OAuth flow
- Token management
- App installation
- Repository permissions

### Best Practices

1. **Security**
- CSRF protection
- Token encryption
- Secure sessions
- Access control

2. **Error Handling**
- Graceful failures
- Detailed logging
- User feedback
- Security considerations

3. **Code Organization**
- Modular design
- Clear responsibilities
- Consistent patterns
- Maintainable structure

4. **Documentation**
- Inline comments
- Function documentation
- Usage examples
- Security notes

### API Endpoints Summary

1. **Authentication**
- POST `/bitbucket` - Bitbucket login
- GET `/github/app` - GitHub OAuth init
- POST `/github/callback` - OAuth callback
- GET `/logout` - User logout
- GET `/session` - Session info

2. **Repository Access**
- GET `/bitbucket/projects` - List projects
- GET `/bitbucket/projects/{project_key}/repos` - List repositories
- GET `/bitbucket/projects/{project_key}/repos/{repo_slug}` - Repository details

### Response Examples

1. **Successful Authentication**
```json
{
    "status": "success",
    "message": "Authentication successful",
    "credentials": {
        "username": "user123"
    }
}
```

2. **Session Information**
```json
{
    "authenticated": true,
    "bitbucket_authenticated": true,
    "github_authenticated": true,
    "bitbucket_username": "user123"
}
```

3. **Health Check**
```json
{
    "status": "healthy",
    "component": "auth",
    "version": "1.0.0"
}
```

## Bitbucket Module: `backend/app/api/v1/endpoints/bitbucket.py`

### Overview
This module manages Bitbucket-specific operations, providing endpoints for project and repository management with support for pagination and archived repositories.

### Key Components

1. **Module Setup**
```python
from fastapi import APIRouter, HTTPException
from typing import List, Optional
from app.schemas.git import ProjectResponse, RepositoryResponse, ErrorResponse
from app.clients.bitbucket_client import BitbucketClient
```
- FastAPI router configuration
- Type hints for better code safety
- Response models for data validation
- BitbucketClient for API interactions

### Endpoint Documentation

1. **Project Listing**
```python
@router.get("/projects",
         response_model=ProjectResponse,
         responses={500: {"model": ErrorResponse}})
async def get_bitbucket_projects(
    start: Optional[int] = 0,
    max_projects: Optional[int] = 1500
)
```
**Features:**
- Paginated project retrieval
- Configurable batch size
- Error response modeling
- Default limit of 1500 projects

2. **Repository Listing**
```python
@router.get("/projects/{project_key}/repositories",
         response_model=RepositoryResponse,
         responses={500: {"model": ErrorResponse}})
async def get_bitbucket_repositories(
    project_key: str,
    start: Optional[int] = 0,
    max_repos: Optional[int] = 1500
)
```
**Features:**
- Project-specific repository listing
- Pagination support
- Customizable batch size
- Error handling

3. **Repository Details**
```python
@router.get("/projects/{project_key}/repositories/{repo_slug}")
async def get_bitbucket_repository_details(
    project_key: str,
    repo_slug: str
)
```
**Features:**
- Detailed repository metadata
- Technical information retrieval
- Administrative data access
- Comprehensive error handling

4. **All Project Repositories**
```python
@router.get("/projects/{project_key}/repositories/all")
async def get_all_project_repositories(
    project_key: str,
    include_archived: bool = False
)
```
**Features:**
- Complete repository listing
- Optional archived repository inclusion
- Bulk data retrieval
- Project-wide overview

### Response Models

1. **Project Response**
```python
class ProjectResponse(BaseModel):
    projects: List[str]
```
- List of project identifiers
- Validated response format
- Type-safe project data

2. **Repository Response**
```python
class RepositoryResponse(BaseModel):
    repositories: List[str]
```
- Repository list container
- Validated repository data
- Type-safe response format

3. **Error Response**
```python
class ErrorResponse(BaseModel):
    detail: str
```
- Standardized error format
- Clear error messaging
- Consistent error handling

### Pagination Features

1. **Project Pagination**
- Start index parameter
- Configurable batch size
- Default limits
- Efficient data retrieval

2. **Repository Pagination**
- Project-specific pagination
- Customizable page size
- Start position control
- Resource-efficient loading

### Error Handling

1. **Exception Management**
```python
try:
    client = BitbucketClient()
    projects = client.get_projects()
except Exception as e:
    raise HTTPException(status_code=500, detail=str(e))
```
- Graceful error handling
- Clear error messages
- Status code mapping
- Exception tracking

2. **Error Responses**
- 500 Internal Server Error
- Detailed error messages
- Client-friendly responses
- Debugging information

### Performance Features

1. **Batch Processing**
- Configurable batch sizes
- Memory-efficient pagination
- Optimized data retrieval
- Resource management

2. **Archived Repository Handling**
- Optional archive inclusion
- Filtered repository lists
- Efficient data access
- Storage optimization

### Best Practices

1. **Code Organization**
- Clear endpoint structure
- Consistent error handling
- Type safety
- Documentation

2. **API Design**
- RESTful endpoints
- Clear parameter naming
- Consistent response format
- Proper HTTP methods

3. **Performance**
- Efficient pagination
- Optimized queries
- Resource management
- Batch processing

4. **Documentation**
- Detailed docstrings
- Clear parameter descriptions
- Response format examples
- Usage guidelines

### Example Usage

1. **List Projects**
```http
GET /projects?start=0&max_projects=100
```
```json
{
    "projects": [
        "PROJECT1",
        "PROJECT2",
        "PROJECT3"
    ]
}
```

2. **List Repositories**
```http
GET /projects/PROJECT1/repositories?start=0&max_repos=50
```
```json
{
    "repositories": [
        "repo1",
        "repo2",
        "repo3"
    ]
}
```

3. **Repository Details**
```http
GET /projects/PROJECT1/repositories/repo1
```
```json
{
    "slug": "repo1",
    "name": "Repository One",
    "description": "Main repository",
    "archived": false,
    "private": true
}
```

### Integration Points

1. **BitbucketClient**
- API communication
- Authentication handling
- Request formatting
- Response parsing

2. **Response Models**
- Data validation
- Type checking
- Response formatting
- Error handling

3. **Error Management**
- Exception handling
- Status codes
- Error messages
- Debugging info

## Bulk Migration Module: `backend/app/api/v1/endpoints/bulk_migration.py`

### Overview
This module handles bulk repository migrations from Bitbucket to GitHub, managing parallel transfers with real-time progress tracking and status streaming.

### Key Components

1. **Module Setup and Constants**
```python
from fastapi import APIRouter, BackgroundTasks, HTTPException, Depends
from app.utils.logging import MigrationLogger
from app.clients.bitbucket_client import BitbucketClient
from app.clients.github_client import GitHubClient

# Constants for migration steps
STEP_CLONING = "Cloning repository"
STEP_PUSHING = "Pushing content"
STEP_COMPLETING = "Completing"
STEP_INITIALIZING = "Initializing"
```
- FastAPI router setup
- Migration status tracking
- Step definitions
- Client integrations

### Core Features

1. **Migration Status Management**
```python
migration_statuses: Dict[str, dict] = {}
BULK_LOGS_DIR = Path("migration-history/logs/bulk")
```
- In-memory status tracking
- Persistent logging
- Progress monitoring
- Error tracking

2. **Bulk Migration Initialization**
```python
@router.post("/bulk/start")
async def start_bulk_migration(
    request: BulkMigrationRequest, 
    background_tasks: BackgroundTasks,
    session: Optional[Dict[str, Any]] = Depends(get_current_session)
)
```
**Features:**
- Validates authentication
- Initializes migration tracking
- Starts background tasks
- Manages session state

3. **Status Monitoring**
```python
@router.get("/bulk/{bulk_id}/status")
async def get_bulk_migration_status(bulk_id: str)
```
**Features:**
- Real-time status updates
- Progress calculation
- Time tracking
- Error reporting

### Migration Process

1. **Repository Processing**
```python
async def process_repository_batches(
    repositories, 
    total_repos, 
    bulk_dir, 
    bulk_log_dir, 
    bulk_id, 
    status, 
    request_dict, 
    bitbucket_client, 
    github_user_client, 
    github_app_client, 
    github_access_token,
    logger
)
```
**Features:**
- Batch processing
- Concurrent migrations
- Progress tracking
- Resource management

2. **Clone and Push Operation**
```python
async def clone_and_force_push(
    source_url: str, 
    target_url: str, 
    logger: logging.Logger,
    bitbucket_client: BitbucketClient,
    repo_status: dict,
    repo_dir: Path
)
```
**Features:**
- Mirror cloning
- Force pushing
- SSL handling
- Progress updates

### Performance Optimizations

1. **Batch Processing**
```python
batch_size = 10
max_concurrent_batches = 5
```
- Controlled concurrency
- Resource optimization
- Memory management
- Load balancing

2. **Progress Tracking**
```python
def update_overall_progress(status, total_repos):
    """Update overall progress based on individual repository progress"""
    total_progress = 0
    for repo_status in status["repositories"].values():
        if repo_status["status"] == "completed":
            total_progress += 100
```
- Real-time updates
- Step progression
- Time tracking
- Status aggregation

### Error Handling

1. **Migration Errors**
```python
class MigrationError(Exception):
    """Custom exception for migration-specific errors"""
    pass
```
- Custom exceptions
- Error categorization
- Detailed messaging
- Recovery handling

2. **Status Updates**
```python
async with asyncio.Lock():
    status["repositories"][repo].update({
        "status": "failed",
        "current_step": STEP_FAILED,
        "error": str(e)
    })
```
- Atomic updates
- Error tracking
- Status synchronization
- Failure recovery

### Resource Management

1. **Directory Cleanup**
```python
async def cleanup_migration_directory(bulk_dir: Path, logger: logging.Logger):
    """Clean up the migration directory"""
    try:
        if bulk_dir.exists():
            shutil.rmtree(bulk_dir, ignore_errors=True)
```
- Resource cleanup
- Permission handling
- Error recovery
- Disk space management

2. **Connection Management**
```python
async def warm_up_connections(bulk_dir, bitbucket_client, request_dict, logger):
    """Pre-warm connections to Bitbucket and GitHub"""
```
- Connection pooling
- Authentication caching
- SSL configuration
- Performance optimization

### Status Response Format

1. **Migration Status**
```json
{
    "bulk_migration_id": "migration123",
    "total_repositories": 50,
    "completed": 30,
    "failed": 2,
    "in_progress": 8,
    "pending": 10,
    "overall_progress": 75,
    "start_time": "2024-01-01T00:00:00Z",
    "elapsed_time": 3600
}
```

2. **Repository Status**
```json
{
    "status": "in_progress",
    "current_step": "Cloning repository",
    "total_progress": 33,
    "steps_completed": 1,
    "total_steps": 3,
    "elapsed_time": 120
}
```

### Best Practices

1. **Concurrency Control**
- Batch size limits
- Resource monitoring
- Lock management
- Progress tracking

2. **Error Recovery**
- Graceful failures
- Cleanup procedures
- Status preservation
- Retry mechanisms

3. **Resource Optimization**
- Memory management
- Disk space cleanup
- Connection pooling
- Batch processing

4. **Security**
- Token management
- SSL verification
- Credential handling
- Access control

### Monitoring and Logging

1. **Progress Tracking**
```python
def calculate_elapsed_time(start_time_str: str, end_time_str: str = None) -> float:
    """Calculate elapsed time in seconds"""
    start_time = datetime.fromisoformat(start_time_str)
    end_time = datetime.fromisoformat(end_time_str) if end_time_str else datetime.now(UTC)
    return (end_time - start_time).total_seconds()
```
- Time tracking
- Progress calculation
- Status updates
- Performance metrics

2. **Logging Strategy**
```python
logger = MigrationLogger(f"{bulk_id}_{repo}", repo_log_file)
logger.info(f"Starting parallel migration for {repo}")
```
- Detailed logging
- Error tracking
- Performance monitoring
- Debug information

### Integration Points

1. **Authentication**
- Session management
- Token validation
- Credential handling
- Access control

2. **Git Operations**
- Repository cloning
- Force pushing
- Reference management
- Tag handling

3. **Client Integration**
- Bitbucket API
- GitHub API
- Status updates
- Error handling

### Example Usage

1. **Start Migration**
```http
POST /bulk/start
{
    "bulk_migration_id": "migration123",
    "source_project": "PROJECT1",
    "source_repositories": ["repo1", "repo2", "repo3"],
    "target_owner": "target-org",
    "visibility": "private"
}
```

2. **Check Status**
```http
GET /bulk/migration123/status
```

3. **Response Example**
```json
{
    "status": "in_progress",
    "total_repositories": 3,
    "completed": 1,
    "failed": 0,
    "in_progress": 1,
    "pending": 1,
    "overall_progress": 33
}
```

## Single Migration Module: `backend/app/api/v1/endpoints/migration.py`

### Overview
This module handles individual repository migrations from Bitbucket to GitHub, providing real-time status updates via Server-Sent Events (SSE) and comprehensive error handling.

### Key Components

1. **Module Setup and Models**
```python
class SourceRepository(BaseModel):
    project: str
    repository: str

class TargetRepository(BaseModel):
    owner: str
    name: str
    description: Optional[str] = None
    visibility: str = "private"

class MigrationRequest(BaseModel):
    source: SourceRepository
    target: TargetRepository
    repository_option: str
```
- Request validation models
- Type-safe data handling
- Configuration options
- Default values

### Core Features

1. **Migration Initialization**
```python
@router.post("/start", response_model=MigrationResponse)
async def start_migration(
    request: MigrationRequest,
    background_tasks: BackgroundTasks,
    session: Optional[Dict[str, Any]] = Depends(get_authenticated_session)
)
```
**Features:**
- Session validation
- Background task creation
- Status initialization
- Error handling

2. **Status Monitoring**
```python
@router.get("/status/{migration_id}")
async def get_migration_status(migration_id: str)
```
**Features:**
- Real-time SSE updates
- Progress tracking
- Error reporting
- Connection management

### Migration Process

1. **Repository Migration**
```python
async def perform_migration(
    migration_id: str,
    request: MigrationRequest,
    username: str,
    password: str,
    github_user_token: str,
    github_server_token: str
)
```
**Features:**
- Authentication handling
- Repository cloning
- Content pushing
- Progress updates

2. **Repository Size Management**
```python
async def get_repo_size(bitbucket_client: BitbucketClient, project: str, repository: str)
```
**Features:**
- Size calculation
- API integration
- Format conversion
- Error handling

### Status Management

1. **Status Updates**
```python
def update_status(
    migration_id: str,
    status: str,
    progress: int,
    details: str,
    current_step: str,
    error: str = None
)
```
**Features:**
- Progress tracking
- Step management
- Error recording
- Timing updates

2. **SSE Event Generation**
```python
async def generate_migration_events(migration_id: str, migration_started: bool)
```
**Features:**
- Real-time updates
- Connection management
- Error handling
- Status streaming

### Security Features

1. **Authentication Management**
```python
async def validate_github_access(token: str, owner: str, repo: str, logger: MigrationLogger)
```
**Features:**
- Token validation
- Access verification
- Error handling
- Secure logging

2. **Repository Access**
```python
async def create_github_repository(
    owner: str,
    name: str,
    description: str,
    visibility: str,
    token: str
)
```
**Features:**
- Permission checking
- Repository creation
- Error handling
- Access control

### Error Handling

1. **Custom Exceptions**
```python
class MigrationError(Exception):
    """Custom exception for migration-specific errors"""
    pass
```
- Migration-specific errors
- Detailed messages
- Error categorization
- Recovery handling

2. **Error Responses**
```python
HTTPException(
    status_code=401,
    detail="Missing Bitbucket credentials. Please authenticate first."
)
```
- Status codes
- Detailed messages
- Client feedback
- Recovery options

### Resource Management

1. **Directory Management**
```python
def cleanup_repo_directory(path: Path, logger: MigrationLogger)
```
**Features:**
- Resource cleanup
- Permission handling
- Error recovery
- Space management

2. **Connection Handling**
```python
async def test_github_access(owner: str, repo: str, github_token: str)
```
**Features:**
- Connection testing
- Authentication verification
- Error handling
- Access validation

### Status Response Format

1. **Migration Status**
```json
{
    "migration_id": "abc123",
    "status": "in_progress",
    "progress": {
        "percentage": 45,
        "current_step": "Cloning repository",
        "steps_completed": 2,
        "total_steps": 5
    },
    "timing": {
        "start_time": "2024-01-01T00:00:00Z",
        "elapsed_seconds": 120
    },
    "details": {
        "message": "Cloning source repository",
        "error": null
    }
}
```

2. **SSE Event Format**
```json
{
    "event": "migration_update",
    "data": {
        "status": "in_progress",
        "progress": 45,
        "current_step": "Cloning repository",
        "details": {
            "message": "Cloning source repository"
        }
    }
}
```

### Best Practices

1. **Git Operations**
- Mirror cloning
- Force push control
- Reference management
- Tag handling

2. **Error Recovery**
- Graceful failures
- Cleanup procedures
- Status preservation
- Retry mechanisms

3. **Resource Management**
- Memory optimization
- Disk space cleanup
- Connection pooling
- Process management

4. **Security**
- Token validation
- SSL verification
- Credential handling
- Access control

### Monitoring and Logging

1. **Migration Logger**
```python
def setup_migration_logger(migration_id: str) -> logging.Logger
```
**Features:**
- Dedicated loggers
- File handlers
- Console output
- Error tracking

2. **Progress Monitoring**
```python
def calculate_elapsed_time(start_time_str: str, end_time_str: str = None) -> float
```
**Features:**
- Time tracking
- Progress calculation
- Status updates
- Performance metrics

### Integration Points

1. **Bitbucket Integration**
- Authentication
- Repository access
- Size calculation
- Error handling

2. **GitHub Integration**
- Repository creation
- Access validation
- Content pushing
- Status updates

3. **Event Streaming**
- SSE management
- Connection handling
- Status updates
- Error reporting

### Example Usage

1. **Start Migration**
```http
POST /start
{
    "source": {
        "project": "PROJECT1",
        "repository": "repo1"
    },
    "target": {
        "owner": "target-org",
        "name": "repo1",
        "visibility": "private"
    },
    "repository_option": "new"
}
```

2. **Monitor Progress**
```http
GET /status/abc123
```

3. **SSE Updates**
```
event: migration_update
data: {
    "status": "in_progress",
    "progress": 45,
    "current_step": "Cloning repository",
    "details": {
        "message": "Cloning source repository"
    }
}
```

## Teams Module: `backend/app/api/v1/endpoints/teams.py`

### Overview
This module manages GitHub organization teams and repository permissions, providing endpoints for repository access control and team permission management.

### Key Components

1. **Module Setup and Models**
```python
class Repository(BaseModel):
    id: int
    name: str
    full_name: str
    description: Optional[str] = None
    private: bool
    visibility: str
    permissions: Optional[Dict[str, bool]] = None

class TeamPermissionUpdate(BaseModel):
    teamId: int
    permission: str

class BulkPermissionUpdate(BaseModel):
    repositories: List[str]
    teamIds: List[int]
    permission: str
```
- Data validation models
- Permission structures
- Repository metadata
- Bulk update support

### Core Features

1. **Repository Listing**
```python
@router.get("/organizations/{org}/repositories", response_model=RepositoryResponse)
async def list_organization_repositories(
    org: str,
    session: Dict[str, Any] = Depends(get_authenticated_session),
    private: bool = True,
    internal: bool = True,
    public: bool = True
)
```
**Features:**
- Visibility filtering
- Permission validation
- Repository counting
- Access control

2. **Repository Summary**
```python
@router.get("/organizations/{org}/repositories/summary")
async def get_repository_summary(org: str, session: Dict[str, Any])
```
**Features:**
- Repository statistics
- Permission counts
- Visibility breakdown
- Organization overview

### Permission Management

1. **Team Permissions**
```python
@router.get("/organizations/{org}/repositories/{repo}/teams")
async def get_repository_teams(org: str, repo: str, session: Dict[str, Any])
```
**Features:**
- Team listing
- Permission levels
- Access control
- Error handling

2. **Bulk Permission Updates**
```python
@router.put("/organizations/{org}/bulk-permissions")
async def update_bulk_repository_permissions(
    org: str,
    update: BulkPermissionUpdate,
    session: Dict[str, Any]
)
```
**Features:**
- Multiple repository updates
- Team permission management
- Batch processing
- Success tracking

### Repository Operations

1. **Repository Fetching**
```python
async def fetch_repositories_from_endpoint(url: str, headers: dict, params: dict)
```
**Features:**
- Pagination handling
- Error management
- Response processing
- Rate limiting

2. **Repository Filtering**
```python
async def filter_repositories_by_visibility(
    repos: List[dict],
    private: bool,
    internal: bool,
    public: bool
)
```
**Features:**
- Visibility filtering
- Permission validation
- Repository counting
- Access verification

### Team Management

1. **Team Access Control**
```python
@router.delete("/organizations/{org}/repositories/{repo}/teams/{team_id}")
async def remove_team_access(org: str, repo: str, team_id: int, session: Dict[str, Any])
```
**Features:**
- Access removal
- Permission cleanup
- Error handling
- Success verification

2. **Team Listing**
```python
@router.get("/organizations/{org}/teams")
async def get_organization_teams(org: str, session: Dict[str, Any])
```
**Features:**
- Team enumeration
- Access validation
- Error handling
- Response formatting

### Permission Mapping

1. **Permission Level Translation**
```python
async def map_permission_level(permission: str) -> str
```
**Features:**
- Permission mapping
- Level validation
- Standardization
- Error handling

2. **Team Permission Updates**
```python
async def update_team_repository_permission(
    team_id: int,
    org: str,
    repo: str,
    permission: str,
    headers: dict
)
```
**Features:**
- Permission validation
- Access control
- Error handling
- Success tracking

### Response Formats

1. **Repository Response**
```json
{
    "repositories": [
        {
            "id": 123,
            "name": "repo-name",
            "full_name": "org/repo-name",
            "description": "Repository description",
            "private": true,
            "visibility": "private",
            "permissions": {
                "admin": true,
                "push": true,
                "pull": true
            }
        }
    ],
    "total_count": 1,
    "private_count": 1,
    "internal_count": 0,
    "public_count": 0
}
```

2. **Team Permission Response**
```json
{
    "id": 456,
    "name": "team-name",
    "permission": "admin"
}
```

### Error Handling

1. **Authentication Errors**
```python
HTTPException(
    status_code=401,
    detail="Missing GitHub token in session. Please authenticate with GitHub first."
)
```
- Token validation
- Session checks
- Error messaging
- Status codes

2. **Operation Errors**
```python
HTTPException(
    status_code=500,
    detail=f"Error updating team permissions: {str(e)}"
)
```
- Operation failures
- Detailed messages
- Status codes
- Error tracking

### Best Practices

1. **Security**
- Token validation
- Permission checks
- Access control
- Error handling

2. **Performance**
- Batch processing
- Pagination
- Connection pooling
- Resource management

3. **Error Recovery**
- Graceful failures
- Status preservation
- Error tracking
- User feedback

4. **Code Organization**
- Modular design
- Clear responsibilities
- Type safety
- Documentation

### Example Usage

1. **List Repositories**
```http
GET /organizations/my-org/repositories?private=true&internal=true&public=false
```
```json
{
    "repositories": [
        {
            "id": 123,
            "name": "repo-1",
            "visibility": "private",
            "permissions": {
                "admin": true
            }
        }
    ],
    "total_count": 1,
    "private_count": 1
}
```

2. **Update Team Permissions**
```http
PUT /organizations/my-org/bulk-permissions
{
    "repositories": ["repo-1", "repo-2"],
    "teamIds": [123, 456],
    "permission": "write"
}
```
```json
{
    "results": [
        {
            "repository": "repo-1",
            "teams": [
                {
                    "teamId": 123,
                    "success": true
                },
                {
                    "teamId": 456,
                    "success": true
                }
            ]
        }
    ],
    "total_updates": 4,
    "successful": 4,
    "failed": 0
}
```

### Integration Points

1. **GitHub API**
- Repository management
- Team operations
- Permission control
- Error handling

2. **Authentication**
- Session management
- Token validation
- Access control
- Error handling

3. **Response Processing**
- Data validation
- Type conversion
- Error handling
- Response formatting

## Function-by-Function Documentation for `migration.py`

### Core Functions

1. **cleanup_repo_directory**
```python
def cleanup_repo_directory(path: Path, logger: MigrationLogger)
```
Purpose: Cleans up repository directory contents while preserving structure
- Handles file permissions
- Preserves directory structure
- Graceful error handling
- Detailed logging

2. **validate_github_access**
```python
async def validate_github_access(token: str, owner: str, repo: str, logger: MigrationLogger) -> bool
```
Purpose: Validates GitHub access with provided token
- Token validation
- Repository accessibility check
- Error handling
- Detailed logging

3. **clone_and_push_repository**
```python
async def clone_and_push_repository(migration_id: str, request: MigrationRequest, bitbucket_username: str, bitbucket_password: str)
```
Purpose: Handles core migration process
- Repository cloning
- GitHub push operations
- Progress tracking
- Error handling

### Status Management Functions

4. **start_migration**
```python
@router.post("/start", response_model=MigrationResponse)
async def start_migration(request: MigrationRequest, background_tasks: BackgroundTasks, session: Optional[Dict[str, Any]], bitbucket_username: Optional[str], bitbucket_password: Optional[str])
```
Purpose: Initializes migration process
- Migration initialization
- Credential validation
- Status tracking setup
- Background task management

5. **create_github_repository**
```python
async def create_github_repository(owner: str, name: str, description: str, visibility: str, token: str) -> bool
```
Purpose: Creates new GitHub repository
- Repository creation
- Error handling
- Access validation
- Response processing

### Logging and Monitoring Functions

6. **setup_migration_logger**
```python
def setup_migration_logger(migration_id: str) -> logging.Logger
```
Purpose: Sets up dedicated logger for specific migration
- Console logging
- File logging
- Migration-specific context
- Formatted output

7. **format_size_bytes**
```python
def format_size_bytes(size_bytes: float) -> str
```
Purpose: Converts bytes to human-readable format
- Unit conversion
- Decimal formatting
- Multiple unit support
- Human-readable output

### Repository Size Management Functions

8. **get_size_from_main_endpoint**
```python
async def get_size_from_main_endpoint(session: aiohttp.ClientSession, url: str, auth: aiohttp.BasicAuth) -> Optional[float]
```
Purpose: Extracts size information from main repository endpoint
- API integration
- Size extraction
- Error handling
- Multiple response formats

9. **get_size_from_sizes_endpoint**
```python
async def get_size_from_sizes_endpoint(session: aiohttp.ClientSession, url: str, auth: aiohttp.BasicAuth) -> Optional[float]
```
Purpose: Extracts size information from sizes endpoint
- Alternative size retrieval
- Error handling
- Response parsing
- Size validation

10. **get_repo_size**
```python
async def get_repo_size(bitbucket_client: BitbucketClient, project: str, repository: str) -> str
```
Purpose: Gets repository size from Bitbucket API
- Multiple endpoint support
- Error handling
- Size formatting
- Fallback mechanisms

### Migration Process Functions

11. **perform_migration**
```python
async def perform_migration(migration_id: str, request: MigrationRequest, username: str, password: str, github_user_token: str = None, github_server_token: str = None)
```
Purpose: Executes migration process
- Full migration process
- Progress tracking
- Error handling
- Status updates

### Status Streaming Functions

12. **create_status_update**
```python
async def create_status_update(migration_id: str, current_status) -> dict
```
Purpose: Creates status update dictionary for SSE events
- Time calculation
- Progress formatting
- Status details
- Error information

13. **should_start_migration**
```python
async def should_start_migration(migration_id: str, migration_started: bool) -> bool
```
Purpose: Checks if migration should be started
- Connection validation
- Start condition check
- Status verification
- Error prevention

14. **get_current_status_dict**
```python
async def get_current_status_dict(current_status) -> Optional[dict]
```
Purpose: Creates dictionary representation of current status
- Status formatting
- Data validation
- Error handling
- Optional handling

15. **check_migration_completion**
```python
async def check_migration_completion(status: str) -> Tuple[bool, bool]
```
Purpose: Checks migration completion status
- Status validation
- Stream control
- Completion detection
- Error handling

16. **create_update_data**
```python
async def create_update_data(migration_id: str, current_status) -> str
```
Purpose: Creates formatted update data for SSE
- Data formatting
- JSON serialization
- SSE compliance
- Error handling

17. **send_status_update**
```python
async def send_status_update(migration_id: str, current_status, last_status: dict) -> Tuple[Optional[str], dict, bool]
```
Purpose: Sends status update if changed
- Change detection
- Status comparison
- Update formatting
- Stream control

18. **initialize_migration**
```python
async def initialize_migration(migration_id: str, migration_started: bool) -> bool
```
Purpose: Initializes migration if needed
- Start condition check
- Task initialization
- Status update
- Error handling

19. **process_migration_status**
```python
async def process_migration_status(migration_id: str, current_status, last_status: dict) -> Tuple[Optional[str], dict, bool, bool]
```
Purpose: Processes migration status updates
- Status processing
- Update generation
- Stream control
- Error handling

20. **handle_error**
```python
async def handle_error(e: Exception) -> str
```
Purpose: Handles exceptions in event generator
- Error formatting
- Logging
- SSE compliance
- Client notification

21. **generate_migration_events**
```python
async def generate_migration_events(migration_id: str, migration_started: bool)
```
Purpose: Generates SSE events for migration status
- Event generation
- Status streaming
- Connection management
- Error handling

### API Endpoints

22. **get_migration_status**
```python
@router.get("/status/{migration_id}")
async def get_migration_status(migration_id: str, background_tasks: BackgroundTasks)
```
Purpose: Streams migration status via SSE
- SSE streaming
- Status updates
- Connection management
- Error handling

23. **stream_migration_status_options**
```python
@router.options("/status/{migration_id}")
async def stream_migration_status_options()
```
Purpose: Handles OPTIONS request for CORS
- CORS headers
- Preflight handling
- Access control
- Options response

24. **update_status**
```python
def update_status(migration_id: str, status: str, progress: int, details: str, current_step: str, error: str = None)
```
Purpose: Updates migration status
- Status tracking
- Progress updates
- Error handling
- Logging

25. **test_github_access**
```python
@router.post("/test-github-access")
async def test_github_access(owner: str, repo: str, github_token: str = Depends(get_github_token))
```
Purpose: Tests GitHub repository access
- Access validation
- Clone testing
- Error handling
- Detailed feedback

## Migration Module Walkthrough

### 1. Migration Flow Overview

The migration process follows this sequence:

```
[User Request] → [Initialize Migration] → [Clone Repository] → [Push to GitHub] → [Status Updates] → [Completion]
```

### 2. Key Components Interaction

1. **Request Handling**
   ```python
   @router.post("/start")
   async def start_migration(request: MigrationRequest, ...)
   ```
   - Receives migration request with source and target details
   - Validates user session and credentials
   - Generates unique migration ID
   - Initializes status tracking

2. **Status Management**
   ```python
   migration_status: Dict[str, MigrationStatus] = {}
   ```
   - In-memory status tracking
   - Real-time progress updates
   - Error state management
   - Completion tracking

3. **Server-Sent Events (SSE)**
   ```python
   @router.get("/status/{migration_id}")
   async def get_migration_status(...)
   ```
   - Real-time status streaming
   - Progress updates
   - Error notifications
   - Completion events

### 3. Step-by-Step Process

1. **Migration Initialization**
   - Validate credentials
   - Create migration ID
   - Set up logging
   - Initialize status tracking

2. **Repository Setup**
   - Create target repository (if new)
   - Validate access permissions
   - Set up temporary directories
   - Configure Git settings

3. **Clone Operation**
   - Set up Bitbucket credentials
   - Clone source repository
   - Track clone progress
   - Handle large repositories

4. **Push Operation**
   - Configure GitHub remote
   - Push default branch
   - Push all branches
   - Push tags

5. **Status Updates**
   - Track progress percentage
   - Monitor current step
   - Record timing information
   - Handle errors

6. **Cleanup**
   - Remove temporary files
   - Clean up credentials
   - Update final status
   - Log completion

### 4. Error Handling Strategy

1. **Authentication Errors**
   ```python
   if not username or not password:
       raise HTTPException(
           status_code=401,
           detail="Missing credentials"
       )
   ```
   - Credential validation
   - Token verification
   - Session checks
   - Permission validation

2. **Operation Errors**
   ```python
   try:
       repo = Repo.clone_from(...)
   except GitCommandError as e:
       raise MigrationError(f"Clone failed: {str(e)}")
   ```
   - Git operation failures
   - Network issues
   - Permission problems
   - Resource constraints

3. **Recovery Procedures**
   - Cleanup on failure
   - Status updates
   - Error logging
   - User notifications

### 5. Status Tracking System

1. **Progress Updates**
   ```json
   {
     "migration_id": "abc123",
     "status": "in_progress",
     "progress": 45,
     "current_step": "Cloning repository",
     "timing": {
       "start_time": "2024-01-01T00:00:00Z",
       "elapsed_seconds": 120
     }
   }
   ```

2. **Event Stream**
   ```
   event: migration_update
   data: {"status": "in_progress", "progress": 45, ...}
   ```

### 6. Security Measures

1. **Credential Handling**
   - Secure credential storage
   - Token validation
   - Session management
   - Access control

2. **Repository Access**
   - Permission validation
   - Token scopes
   - Organization access
   - Repository visibility

### 7. Performance Considerations

1. **Resource Management**
   - Temporary storage cleanup
   - Memory usage monitoring
   - Connection pooling
   - Batch operations

2. **Optimization Techniques**
   - Efficient cloning
   - Progress streaming
   - Status caching
   - Connection reuse

### 8. Example Usage Scenarios

1. **New Repository Migration**
```http
POST /start
{
    "source": {
        "project": "PROJECT1",
        "repository": "repo1"
    },
    "target": {
        "owner": "target-org",
        "name": "repo1",
        "visibility": "private"
    },
    "repository_option": "new"
}
```

2. **Existing Repository Update**
```http
POST /start
{
    "source": {
        "project": "PROJECT1",
        "repository": "repo1"
    },
    "target": {
        "owner": "target-org",
        "name": "existing-repo",
        "visibility": "private"
    },
    "repository_option": "existing"
}
```

### 9. Monitoring and Debugging

1. **Logging System**
   ```python
   logger = setup_migration_logger(migration_id)
   logger.info("Starting migration process")
   ```
   - Migration-specific logs
   - Error tracking
   - Performance metrics
   - Debug information

2. **Status Monitoring**
   ```http
   GET /status/abc123
   ```
   - Real-time updates
   - Progress tracking
   - Error reporting
   - Completion status

### 10. Best Practices Implementation

1. **Code Organization**
   - Modular functions
   - Clear responsibilities
   - Error handling
   - Status management

2. **Resource Management**
   - Cleanup procedures
   - Memory optimization
   - Connection handling
   - Error recovery

3. **Security Measures**
   - Credential protection
   - Access validation
   - Token management
   - Secure operations

4. **Performance Optimization**
   - Efficient operations
   - Resource cleanup
   - Status tracking
   - Error handling

This walkthrough provides a comprehensive understanding of how the migration module works, from initial request to completion, including error handling, security measures, and best practices.
