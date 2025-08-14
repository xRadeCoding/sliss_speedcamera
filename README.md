# FiveM Speed Camera System

Welcome to **Speed Camera** – a lightweight yet powerful system to automatically catch speeding players on your FiveM server and fine them in real-time.

Tested on **ESX 1.12.3** with **ox_lib 3.30.6**, but it should work seamlessly with other recent ESX versions.

Whether your server enforces strict roleplay traffic laws or you simply want to add more realism to your gameplay, this resource does exactly what you need – without unnecessary complexity.

---

## Features

> - **Unlimited cameras** – place as many as you like, each with its own custom speed limit.
> - **Automatic fines** – money is taken from the player’s bank first, then from cash; if both are empty, a bill is sent i nstead.
> - **Optimized performance** – designed to run smoothly even on high-population servers.
> - **Anti-spam cooldown** – prevents players from receiving multiple fines in quick succession.
> - **Fully customizable** – adjust fine rates, maximum fines, and speed limits per camera.
> - **Simple configuration** – all settings are neatly stored in one config file.

---

## Installation

1. **Download or clone** the resource into your `resources` folder:

git clone https://github.com/your-username/sliss_speedcams.git

2. **Dependencies** (make sure these are running before this resource):

- [ESX (tested on 1.12.3)][esx]
- [ox_lib (tested on 3.30.6)][oxlib]

3. **Add to your `server.cfg`**:

ensure sliss_speedcams

4. **Configure your cameras** in `shared/config.lua`:

> - Set the **coordinates** (`coords`) for each speed camera using `vector3(x, y, z)`.
> - Define the **maximum speed** (`maxSpeed`) allowed for that camera in km/h.
> - Optionally, set **Notify** (`true`/`false`) to control whether the player receives a notification when fined.
> - Adjust the **fine price per km/h** over the limit and the **maximum fine** allowed in the `CONST`.


---

## Example Config
```
Config.SpeedCams = {
    {
        coords    = vector3(0.0, 0.0, 0.0),
        maxSpeed  = 100,   -- km/h
        Notify    = true   -- Show notification when player is fined
    },
    {
        coords    = vector3(0.0, 0.0, 0.0),
        maxSpeed  = 100,   -- km/h
        Notify    = false  -- Do not show notification when player is fined
    }
}

CONST = {
    PRICE_PER_KMH = 10,     -- €10 per km/h over the limit
    MAX_SINGLE_FINE = 2000  -- Maximum fine per violation
}
```
[esx]: https://github.com/esx-framework/esx_core "ESX (tested on 1.12.3)"
[oxlib]: https://github.com/overextended/ox_lib "ox_lib (tested on 3.30.6)"