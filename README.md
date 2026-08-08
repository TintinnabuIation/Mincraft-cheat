# Vape 4.21

**Safe source , checked by barbykew**

A research recovery project of the Vape 4.21 Java layer and Windows x64 native bridge.

### This is the official Vape source code. 

> This project is for software recovery, compatibility analysis, and isolated environment testing only. Use only in isolated instances you own and are authorized to test. Verify your local laws, software licenses, and server rules.

## Current Status

| Scope | Status |
| --- | --- |
| Java Source | 2,939 sample-owned package sources, compiles normally with Gradle |
| Resources | 230 mappings, fonts, textures, shaders, sounds, and localization assets |
| Injection Payload | Self-contained Shadow JAR targeting Java 8 class-file major 52 |
| Native Bridge | Windows x64 JNI/JVMTI DLL with `LoadLibraryW` injector |
| Runtime Verification | Build and payload structure verified; full in-game behavior still needs further testing |

Currently supports **Minecraft 1.7.10 Forge, 1.8.9 Forge, 1.12.2 Forge, 1.21.11 Forge, and 26.2 Forge**.
1.21.11 has been verified on Forge 61.0.8, 26.2 on Forge 65.1.0. Injection into Forge-enabled Lunar Client instances is also supported.
Vanilla or Fabric is not supported. Minecraft 1.16.5 support is poor; some mappings, rendering, and module features may not work correctly. All target instances must use a 64-bit JVM.

## Requirements

To compile and verify the Java layer only:

- JDK 17 as Gradle toolchain; output compiles with `--release 8` by default
- Bundled Gradle Wrapper; build scripts require Gradle 8.8
- Network access to Maven Central and Gradle Plugin Portal

To build the native bundle:

- Windows x64
- Visual Studio 2022 C++ x64 toolchain and Windows SDK
- CMake 3.21 or higher
- A JDK with JNI/JVMTI headers; JDK 8 recommended when targeting 1.7.10, 1.8.9, and 1.12.2

## Quick Start

From the repo root in PowerShell:

```powershell
.\gradlew.bat clean build verifyInjectionPayload
```

This will:

1. Compile the recovered source and process all resources.
2. Check source counts and residual CFR decompilation markers.
3. Generate the injection JAR with runtime dependencies.
4. Confirm the payload contains required packages and all classes are loadable by Java 8.

Main Java artifacts are in `build/libs/`. To generate IntelliJ IDEA project configuration:

```powershell
.\gradlew.bat idea
```

## Building the Native Test Bundle

```powershell
.\gradlew.bat prepareInjectionBundle -PtargetRelease=8 `
  -PnativeJavaHome="C:\Program Files\Java\jdk1.8.0_301"
```

Full test bundle output in `build/injection/`:

```text
Vape421Native.dll
Vape421Injector.exe
README.md
```

The DLL embeds the Java injection JAR as `RCDATA`; no separate payload placement is needed. The native bridge only implements interfaces recovered from the sample's nine `RegisterNatives` entries. See [`native/README.md`](native/README.md) for more details.

## Running in an Isolated Environment

Launch a supported Forge instance with a 64-bit JVM (or a Forge-enabled Lunar Client), then execute from `build/injection/`:

```powershell
.\Vape421Injector.exe <pid> .\Vape421Native.dll
```

The injector only performs `LoadLibraryW`. Once loaded, the DLL waits for the JVM and Minecraft `Client thread`, loads the embedded JAR via its context ClassLoader, registers nine native methods, and calls `gg.vape.runtime.NativeBridge.start()`. Execution results are written to `vape421-native.log` in the DLL's directory.

## Common Verification Commands

| Command | Purpose |
| --- | --- |
| `.\gradlew.bat check` | Compile, source coverage, and recovery quality checks |
| `.\gradlew.bat injectionJar` | Build self-contained Java injection payload |
| `.\gradlew.bat verifyInjectionPayload` | Check dependency integrity and Java 8 bytecode version |
| `.\gradlew.bat buildNative` | Build x64 DLL and injector |
| `.\gradlew.bat prepareInjectionBundle` | Assemble native bundle for isolated testing |

## License

This repository is provided under [CC0 1.0 Universal](LICENSE). To the extent applicable, CC0 covers only what the repository contributors have the right to dispose of. Third-party libraries, trademarks, fonts, textures, and other existing materials remain subject to their respective rights.
