# BME Formula Racing Team - Telemetry UI

A cross-platform telemetry application for real-time data visualization, logging, and analysis of the BME Formula Racing Team's race car. Built with Flutter for native performance on **Windows** and **Linux**.

---

## Features

* **Real-time Data Visualization**: Dynamically updating charts, graphs, and indicators for critical vehicle data.
* **Comprehensive Dashboards**: A tab-based interface organizes data by vehicle subsystem (HV, LV, MCU, Dynamics, etc.).
* **Live Logging & Alerts**: Integrated logging and alert panels to monitor the application's status and vehicle warnings in real-time.
* **Configurable Connection**: Easily configure settings like UDP port and data refresh rates.
* **Cross-Platform**: Single codebase supporting both Windows and Linux desktop builds.

---

## Getting Started

Follow these steps to get the telemetry application running on your system.

### Installation & Configuration

1.  **Download the Application**: Grab the latest release for your operating system (Windows or Linux) from the project's **Releases** page.
2.  **Locate the DBC File**: Specify your .dbc file to use in a dedicated dialog.
4.  **Configure Settings**:
    * Navigate to the **Config** tab.
    * In the **Settings** panel, enter the correct **UDP Port** the car is broadcasting to.
    * Adjust refresh rates and buffer times as needed for performance or battery life.
5.  **Connect**: Click the **Connect** button. The Telemetry Status panel should update, and the log should confirm a successful connection.

---

## UI Overview

The application is organized into several tabs, each focusing on a specific part of the car.

### ## Config
This is the tab to configure the application.
* **Settings**: Tweak performance and connection parameters like refresh times and the UDP port.
* **Telemetry Log & Alerts**: See status messages, connection errors, and critical vehicle alerts as they happen.
* **Telemetry Status**: A quick overview of the connection status, including RSSI and the number of signals being received.

### ## Overview
A high-level dashboard showing the most critical "at-a-glance" information.
* **Sensor Status**: Validity and plausibility checks for key sensors like APPS, STA, and BPS.
* **System and SC LEDs**: Status indicators for various safety control and system modules.
* **Dynamics and Control**: A G-G diagram (`Accel Front` vs. `Speed Vx`) and real-time values for dynamics and torque control.

### ## Other notable tabs
* **TCU (Torque Coupling Unit)**: Displays data related to torque vectoring and control algorithms.
* **MCU (Motor Controller Unit)**: Provides detailed information from all four motor controllers, including temperatures, velocities, and error states.
* **HV Accu (High Voltage Accumulator)**: Monitors the high-voltage battery system, including individual cell voltages, temperatures, state of charge (SoC), and fault states.
* **Dynamics**: A more in-depth view of the car's dynamics, including data from accelerometers, gyroscopes, and speed sensors.
* **Errors**: A centralized tab that aggregates all active errors from across the vehicle's systems for quick diagnosis.

---

## Building from Source (For Developers)

To build the application yourself, ensure you have the Flutter SDK installed.

1.  **Clone the repository:**

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Build the application:**
    * **For Windows:**
        ```sh
        flutter build windows --release
        ```
    * **For Linux:**
        ```sh
        flutter build linux --release
        ```

The compiled executable will be available in the `/build` directory.

## Credits

* **Author**: Dávid Gergely Molnár
* **Organization**: BME Formula Racing Team