# ProTankiAndroid

![Logo](icons/icon_96.png)
[![Version Badge](https://img.shields.io/github/v/release/pngdrift/protanki-android?style=plastic)](https://github.com/pngdrift/protanki-android/releases/latest)

Launcher to start [ProTanki](https://pro-tanki.online) on Android devices using Adobe AIR.

> [!NOTE]  
> There are no on-screen controls yet, so you’ll need a physical keyboard to play battles.
> Alternatively, you can try connecting a gamepad — see the control mapping below.

## 🎮 Gamepad Controls Mapping

| Action              | Gamepad Button           |
|---------------------|--------------------------|
| Move tank forward   | D-Pad Up                 |
| Move tank backward  | D-Pad Down               |
| Turn tank left      | D-Pad Left               |
| Turn tank right     | D-Pad Right              |
| Shoot               | Right Trigger (RT / R2)  |
| Rotate turret left  | Right Stick Left         |
| Rotate turret right | Right Stick Right        |
| Center turret       | Right Stick Click (R3)   |
| Move camera up      | Right Stick Up           |
| Move camera down    | Right Stick Down         |
| Use First Aid       | Left Bumper (LB / L1)    |
| Use Double Armor    | Y / Triangle             |
| Use Double Damage   | A / Cross                |
| Use Nitro           | B / Circle               |
| Drop Mine           | X / Square               |
| Drop Flag           | Right Bumper (RB / R1)   |
| Self-destruct       | Left Trigger (LT / L2)   |
| View the statistics | Select                   |

## 📱 Minimum System Requirements

- **Android version**: 5.1 or higher
- **RAM**: 1 GB  
- **Storage**: 400 MB available space

## 📲 Download

Download the latest APK from the [Releases](https://github.com/pngdrift/protanki-android/releases/latest) page.

## 🛠️ Building from source

### Prerequisites
- Download and install [AIR SDK](https://airsdk.dev/docs/basics/getting-started).
- Install [asconfigc](https://github.com/BowlerHatLLC/asconfigc/blob/main/README.md).
- Generate a certificate (see [certs/README.md](certs/README.md)).

### Build
Use the following command to build APK:
```
asconfigc --sdk-path %AIR_HOME% --air android
```

You will be prompted for the certificate password during the build process.

