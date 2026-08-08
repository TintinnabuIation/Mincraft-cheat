@echo off
REM VapeV4 Quick Start Script
REM This script helps you get VapeV4 working with proper security settings

echo ========================================
echo VapeV4 Quick Start Setup
echo ========================================
echo.

REM Check if JDK is installed
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Java not found. Please install JDK 21 or higher.
    echo Download from: https://adoptium.net/
    pause
    exit /b 1
)

echo [1/4] Java found
java -version

echo.
echo [2/4] Choose your configuration:
echo.
echo 1. Development Mode (SSL bypass enabled, token controller enabled)
echo 2. Production Mode (SSL bypass disabled, token controller disabled)
echo 3. Custom Mode (Configure manually)
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    echo.
    echo Setting up DEVELOPMENT MODE...
    echo.
    set VAPE_ENABLE_TOKEN_CONTROLLER=1
    set VAPE_ONLINE_BASE_URL=http://127.0.0.1:8080
    echo SSL bypass: ENABLED (will be set via JVM argument)
    echo Token controller: ENABLED
    echo API endpoint: http://127.0.0.1:8080
    echo.
    echo To run with SSL bypass, use: java -Dvape.allowInsecureSSL=true -jar build\libs\Vape-4.21-recovered.jar
    goto :build
)

if "%choice%"=="2" (
    echo.
    echo Setting up PRODUCTION MODE...
    echo.
    set VAPE_ENABLE_TOKEN_CONTROLLER=0
    echo SSL bypass: DISABLED
    echo Token controller: DISABLED
    echo API endpoint: Please set VAPE_ONLINE_BASE_URL environment variable
    echo.
    echo To set custom API: set VAPE_ONLINE_BASE_URL=https://your-api.com
    goto :build
)

if "%choice%"=="3" (
    echo.
    echo CUSTOM MODE - Manual Configuration
    echo.
    set /p token_controller="Enable token controller? (y/n): "
    if /i "%token_controller%"=="y" (
        set VAPE_ENABLE_TOKEN_CONTROLLER=1
    ) else (
        set VAPE_ENABLE_TOKEN_CONTROLLER=0
    )
    
    set /p api_url="Enter API URL (or press Enter for localhost): "
    if "%api_url%"=="" (
        set VAPE_ONLINE_BASE_URL=http://127.0.0.1:8080
    ) else (
        set VAPE_ONLINE_BASE_URL=%api_url%
    )
    
    echo.
    echo Configuration:
    echo Token controller: %VAPE_ENABLE_TOKEN_CONTROLLER%
    echo API endpoint: %VAPE_ONLINE_BASE_URL%
    echo.
    goto :build
)

echo Invalid choice. Please run the script again.
pause
exit /b 1

:build
echo.
echo [3/4] Building VapeV4...
echo.
call gradlew.bat clean build

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Build failed. Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo [4/4] Checking for native components...
echo.

if exist "build\injection\Vape421Injector.exe" (
    echo Native components found!
    echo.
    echo ========================================
    echo Setup Complete!
    echo ========================================
    echo.
    echo Your built JAR is located at: build\libs\vape421-product-recovery-4.21-recovered.jar
    echo Your injection bundle is at: build\injection\
    echo.
    echo Your current configuration:
    echo - Token controller: %VAPE_ENABLE_TOKEN_CONTROLLER%
    echo - API endpoint: %VAPE_ONLINE_BASE_URL%
    echo.
    echo To use VapeV4 with native injector:
    echo 1. Launch Minecraft Forge (supported versions: 1.7.10, 1.8.9, 1.12.2, 1.21.11, 26.2)
    echo 2. Run: cd build\injection
    echo 3. Run: .\Vape421Injector.exe
    echo 4. Select your Minecraft window and inject
) else (
    echo Native components not found (requires Visual Studio 2022 and CMake)
    echo.
    echo ========================================
    echo Java-Only Setup Complete!
    echo ========================================
    echo.
    echo Your injection JAR is located at: build\libs\vape421-product-recovery-4.21-recovered-injection.jar
    echo.
    echo Your current configuration:
    echo - Token controller: %VAPE_ENABLE_TOKEN_CONTROLLER%
    echo - API endpoint: %VAPE_ONLINE_BASE_URL%
    echo.
    echo To use VapeV4 without native injector:
    echo 1. Launch Minecraft Forge (supported versions: 1.7.10, 1.8.9, 1.12.2, 1.21.11, 26.2)
    echo 2. Add to launch arguments: -javaagent=path\to\build\libs\vape421-product-recovery-4.21-recovered-injection.jar
    echo 3. Or see JAVA_ONLY_SETUP.md for alternative methods
    echo.
    echo Note: The Java-only version provides full VapeV4 functionality!
    echo For native components, install Visual Studio 2022 and CMake, then run:
    echo .\gradlew.bat prepareInjectionBundle -PtargetRelease=8
)

echo.
echo For more information, see GETTING_STARTED.md
echo For Java-only setup, see JAVA_ONLY_SETUP.md
echo For security details, see SECURITY_NOTICES.md
echo.
pause