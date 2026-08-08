# Getting Started Guide - VapeV4

This guide will help you build, configure, and run VapeV4 after the security improvements.

## Prerequisites

### Required Software
- **JDK 21** (or higher) - For building the project
- **Visual Studio 2022** (optional) - For building native components
- **CMake 3.21+** (optional) - For native component builds
- **Gradle 8.8** - Included via Gradle Wrapper

### Minecraft Requirements
- Minecraft Forge (supported versions: 1.7.10, 1.8.9, 1.12.2, 1.21.11, 26.2)
- 64-bit JVM required
- Forge-enabled Lunar Client also supported

## Quick Start

### 1. Build the Java Layer
```powershell
# From the project root directory
.\gradlew.bat clean build
```

This will:
- Compile all Java source code
- Process resources
- Create the JAR file in `build/libs/`
- Run verification checks

### 2. Build the Native Components (Optional - Requires CMake and Visual Studio)

**Note**: Native components require:
- Visual Studio 2022 with C++ x64 toolchain
- CMake 3.21 or higher
- Windows SDK

If you don't have these, you can still use the Java-only version.

```powershell
# Only run this if you have Visual Studio 2022 and CMake installed
.\gradlew.bat buildNative
```

### 3. Create the Injection Bundle (Optional)

```powershell
# For Java 8 compatibility (Minecraft 1.8.9)
.\gradlew.bat prepareInjectionBundle -PtargetRelease=8
```

**If native build fails** (due to missing CMake/Visual Studio):
- The Java injection JAR will still be built successfully
- Located at: `build/libs/vape421-product-recovery-4.21-recovered-injection.jar`
- You can use this with alternative injection methods

The injection bundle (if successful) will be in `build/injection/`:
- `Vape421Native.dll`
- `Vape421Injector.exe`
- `README.md`

## Security Configuration

### ⚠️ Important Security Notes

Due to security improvements, some features are now **disabled by default** and require explicit opt-in.

### 1. SSL Certificate Bypass (Microsoft Authentication)

**Status**: DISABLED by default

**When needed**: Microsoft/Xbox Live authentication for Minecraft login

**How to enable**:
```powershell
# Set system property when running
java -Dvape.allowInsecureSSL=true -jar your-jar-file.jar
```

**⚠️ WARNING**: Only enable this for development/testing. Never use in production!

### 2. Native Token Controller

**Status**: DISABLED by default

**When needed**: When using the native token authentication system

**How to enable**:
```powershell
# Set environment variable before running
set VAPE_ENABLE_TOKEN_CONTROLLER=1
```

**⚠️ WARNING**: Only enable if you control the token controller and understand the risks.

### 3. API Endpoint Configuration

**Status**: Default localhost with warning

**When needed**: When connecting to Vape online services

**How to configure**:
```powershell
# Set your secure API endpoint
set VAPE_ONLINE_BASE_URL=https://your-secure-api.com
```

**Recommendation**: Always use HTTPS endpoints in production.

## Disabled Features

### The Altening API (License Keys)

**Status**: PERMANENTLY DISABLED

**Reason**: Insecure HTTP transmission of license keys

**Impact**: 
- License key generation no longer works
- License info fetching no longer works
- Alternative authentication methods required

**Workaround**: Use Microsoft/Xbox Live authentication instead.

## Usage Instructions

### Running in Development Mode

#### If Native Components Built Successfully:

1. **Build the project**:
   ```powershell
   .\gradlew.bat build
   ```

2. **Enable SSL bypass** (if using Microsoft auth):
   ```powershell
   set VAPE_ENABLE_TOKEN_CONTROLLER=1
   ```

3. **Launch Minecraft** with Forge
4. **Run the injector**:
   ```powershell
   cd build\injection
   .\Vape421Injector.exe <pid> .\Vape421Native.dll
   ```

#### If Native Build Failed (No CMake/Visual Studio):

1. **Build the Java injection JAR**:
   ```powershell
   .\gradlew.bat injectionJar
   ```

2. **The JAR is located at**: `build/libs/vape421-product-recovery-4.21-recovered-injection.jar`

3. **Use alternative injection methods**:
   - Use Java agents with `-javaagent` flag
   - Use manual class loading techniques
   - Use other Minecraft mod loaders that support external JARs

### Running in Production Mode

1. **Build with Java 8 target**:
   ```powershell
   .\gradlew.bat prepareInjectionBundle -PtargetRelease=8
   ```

2. **Configure secure API**:
   ```powershell
   set VAPE_ONLINE_BASE_URL=https://your-secure-api.com
   ```

3. **DO NOT enable SSL bypass** or token controller
4. **Launch Minecraft** and inject as above

## Minecraft Setup

### Supported Versions
- ✅ Minecraft 1.7.10 Forge
- ✅ Minecraft 1.8.9 Forge  
- ✅ Minecraft 1.12.2 Forge
- ✅ Minecraft 1.21.11 Forge (verified on 61.0.8)
- ✅ Minecraft 26.2 Forge (verified on 65.1.0)
- ⚠️ Minecraft 1.16.5 Forge (poor support)
- ❌ Vanilla/Fabric (not supported)

### Injection Process

1. **Launch** your supported Minecraft Forge instance
2. **Find the process ID** (the injector will show you a list)
3. **Run the injector**:
   ```powershell
   .\Vape421Injector.exe
   ```
4. **Select** your Minecraft window from the list
5. **Press Enter** to inject

## Troubleshooting

### Build Issues

**Problem**: "Cannot find Java installation matching requirements"
**Solution**: Install JDK 21 or update `build.gradle` to match your JDK version

**Problem**: "Compilation failed with errors"
**Solution**: Ensure you have all dependencies and JDK 21 installed

### Runtime Issues

**Problem**: "Token controller disabled for security"
**Solution**: Set `VAPE_ENABLE_TOKEN_CONTROLLER=1` if you need token authentication

**Problem**: "Permissive SSL trust manager is disabled"
**Solution**: Set `-Dvape.allowInsecureSSL=true` if you need Microsoft authentication

**Problem**: "VAPE_ONLINE_BASE_URL not set"
**Solution**: Set the environment variable or accept the localhost warning

### Injection Issues

**Problem**: "jvm.dll is not loaded"
**Solution**: Ensure Minecraft is actually running before injecting

**Problem**: "Loader token bootstrap is invalid"
**Solution**: This is expected if token controller is disabled (normal for most use cases)

## Advanced Configuration

### Building for Different Java Versions

**For Java 8 (Minecraft 1.8.9)**:
```powershell
.\gradlew.bat build -PtargetRelease=8
```

**For Java 21 (Modern)**:
```powershell
.\gradlew.bat build -PtargetRelease=21
```

### IntelliJ IDEA Setup

```powershell
.\gradlew.bat idea
```

Then open the generated `.ipr` file in IntelliJ IDEA.

### Verification Commands

```powershell
# Check source quality
.\gradlew.bat check

# Build injection payload only
.\gradlew.bat injectionJar

# Verify injection payload
.\gradlew.bat verifyInjectionPayload
```

## Security Best Practices

### ✅ DO
- Always use HTTPS for API endpoints
- Keep your JDK updated
- Run in isolated environments
- Monitor network traffic
- Keep native components updated

### ❌ DON'T
- Enable SSL bypass in production
- Enable token controller unless necessary
- Use default localhost endpoints in production
- Share your injection bundles
- Run on systems you don't control

## Getting Help

### Documentation
- `README.md` - Project overview
- `SECURITY_NOTICES.md` - Security changes and analysis
- `native/README.md` - Native component documentation

### Build Verification
```powershell
.\gradlew.bat check
```

### Debug Mode
Enable debug logging by setting:
```powershell
set VAPE_DEBUG=1
```

## Next Steps

1. **Build the project** using the commands above
2. **Configure security settings** based on your needs
3. **Test in a safe environment** before production use
4. **Monitor for issues** and check logs if problems occur
5. **Keep updated** with security patches

---

**Remember**: The security improvements require explicit opt-in for potentially dangerous operations. This is intentional to protect users. Only enable features you understand and trust.