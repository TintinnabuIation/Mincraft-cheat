# Java-Only Setup Guide (No Native Build Tools Required)

If you don't have Visual Studio 2022 and CMake installed, you can still use VapeV4 with the Java-only version.

## Quick Setup

### 1. Build the Java Injection JAR
```powershell
.\gradlew.bat injectionJar
```

This creates: `build/libs/vape421-product-recovery-4.21-recovered-injection.jar`

### 2. Your Files Are Ready!

The injection JAR contains:
- Complete VapeV4 Java code
- All dependencies
- Bytecode manipulation libraries
- Ready for injection

## How to Use Without Native Injector

### Option 1: Using Java Agent (Recommended)

1. **Add to Minecraft Launch Arguments**:
   ```
   -javaagent:path/to/vape421-product-recovery-4.21-recovered-injection.jar
   ```

2. **Launch Minecraft Forge** with the agent

### Option 2: Manual Class Loading

1. **Create a simple loader mod** for Forge:
   ```java
   public class VapeLoader {
       @Mod.EventHandler
       public void init(FMLInitializationEvent event) {
           try {
               // Load the injection JAR
               URL jarUrl = new File("path/to/vape421-product-recovery-4.21-recovered-injection.jar").toURI().toURL();
               URLClassLoader loader = new URLClassLoader(new URL[]{jarUrl}, getClass().getClassLoader());
               
               // Load the main class
               Class<?> vapeClass = loader.loadClass("gg.vape.Vape");
               Method initMethod = vapeClass.getMethod("init");
               initMethod.invoke(null);
           } catch (Exception e) {
               e.printStackTrace();
           }
       }
   }
   ```

### Option 3: Using Existing Mod Loaders

Some advanced mod loaders support external JAR loading:
- **Forge** with custom mod loading
- **Fabric** with mod loading capabilities
- **Lunar Client** (if supported)

## Configuration

### Set Environment Variables
```powershell
set VAPE_ONLINE_BASE_URL=http://127.0.0.1:8080
set VAPE_ENABLE_TOKEN_CONTROLLER=1
```

### For Microsoft Authentication
Add JVM argument:
```
-Dvape.allowInsecureSSL=true
```

## Limitations of Java-Only Version

### What Works:
- ✅ All VapeV4 modules and features
- ✅ Account authentication (except The Altening)
- ✅ Profile management
- ✅ Settings synchronization
- ✅ All cheat functionality

### What Requires Native Components:
- ❌ Native injection via Vape421Injector.exe
- ❌ Native token controller (but Java version works)
- ❌ Some low-level system hooks (but Java alternatives available)

## Troubleshooting

### "ClassNotFoundException"
- Ensure the injection JAR path is correct
- Check that you're using the `-injection.jar` version

### "Access Denied"
- Run Minecraft with appropriate permissions
- Check antivirus isn't blocking the JAR

### "Mod Loading Failed"
- Ensure you're using a supported Forge version
- Check that the loader mod is compatible

## Why Native Components?

The native components provide:
- DLL injection into any Java process
- System-level hooks and integration
- More robust injection mechanism

But the Java-only version provides:
- Full VapeV4 functionality
- Easier setup (no C++ tools needed)
- Cross-platform compatibility
- Safer for development/testing

## Recommendation

For most users, the Java-only version is sufficient:
- Easier to set up
- No external tools required
- Full feature set available
- Safer for development

Only use native components if you need:
- Process injection into arbitrary processes
- Maximum integration with the system
- The specific native injector workflow

## Next Steps

1. Build the injection JAR: `.\gradlew.bat injectionJar`
2. Choose your injection method (Java agent recommended)
3. Configure environment variables
4. Test in a safe environment

The Java-only version provides complete VapeV4 functionality without requiring complex native build tools!