# 🔒 Jamf Script: Disable Private Wi-Fi Address for Specific SSIDs (macOS 14+)

## 🇨🇳 中文說明 (Chinese Documentation)

## 🌟 簡介
此 Shell 腳本專為 Jamf 部署設計，用於在 macOS 14 (Sonoma) 及更高版本上，針對特定的已知 Wi-Fi 網路，**強制關閉**其「專用 Wi-Fi 位址」(Private Wi-Fi Address) 功能。

這對於企業或教育機構的網路管理非常有用，因為許多網路需要設備使用真實或靜態的 MAC 位址進行網路存取控制 (NAC) 或 DHCP 綁定。

## ✨ 主要功能
* 修改 macOS 已知 Wi-Fi 網路的設定檔 (`com.apple.wifi.known-networks.plist`)。
* 將目標 SSID 的 `PrivateMACAddressModeUserSetting` 屬性設為 `off`。
* 自動重啟相關服務 (cfprefsd, airportd) 並重新開啟 Wi-Fi 介面，確保設定立即生效。

## ⚙️ Jamf Policy 部署說明
此腳本設計為透過 Jamf Policy 部署，並利用 Jamf 的 Script 參數功能傳遞必要的資訊。

### Jamf Script 參數 (Parameters)

| 參數編號 | 描述 | 預設值 | 範例輸入 |
| :--- | :--- | :--- | :--- |
| **$4** | **目標 SSID(s)**：要關閉「專用 Wi-Fi 位址」的 Wi-Fi 名稱。可輸入單一或多個，多個請用逗號 (`,`) 分隔。 | `YourNetworkName` | `OfficeWiFi,GuestWiFi,Lab_WiFi` |
| **$5** | **Wi-Fi 介面名稱**：通常為 `en0`，但在舊機型或特殊配置上可能不同。 | `en0` | `en0` |

### 執行範例
在 Jamf Policy 的 Script 參數中，依序填入：
* **Parameter 4:** `OfficeWiFi,GuestWiFi`
* **Parameter 5:** `en0`

腳本將會處理 `OfficeWiFi` 和 `GuestWiFi` 這兩個網路。

## ⚠️ 系統要求
* macOS 14 (Sonoma) 或更高版本。
* 需要 Jamf Pro 環境以利用其參數傳遞功能。

---

## 🇬🇧 English Documentation

## 🌟 Overview
This Shell script is designed for Jamf deployment to **forcefully disable** the "Private Wi-Fi Address" feature for specific known Wi-Fi networks on macOS 14 (Sonoma) and later.

This is highly useful for corporate or educational network administration, where many networks require devices to use their true or static MAC addresses for Network Access Control (NAC) or DHCP binding.

## ✨ Key Features
* Modifies the macOS known Wi-Fi networks configuration file (`com.apple.wifi.known-networks.plist`).
* Sets the `PrivateMACAddressModeUserSetting` property to `off` for the target SSIDs.
* Automatically restarts relevant services (`cfprefsd`, `airportd`) and cycles the Wi-Fi interface to ensure the setting takes effect immediately.

## ⚙️ Jamf Policy Deployment Guide
The script is intended to be deployed via a Jamf Policy, leveraging Jamf's Script Parameters functionality to pass necessary information.

### Jamf Script Parameters

| Parameter No. | Description | Default Value | Example Input |
| :--- | :--- | :--- | :--- |
| **$4** | **Target SSID(s)**: The Wi-Fi name(s) for which the Private Wi-Fi Address should be disabled. Enter single or multiple SSIDs separated by a comma (`,`). | `YourNetworkName` | `OfficeWiFi,GuestWiFi,Lab_WiFi` |
| **$5** | **Wi-Fi Interface Name**: Usually `en0` on most MacBooks, but may differ on older models or specific configurations. | `en0` | `en0` |

### Execution Example
In the Jamf Policy's Script Parameters section, fill in the following:
* **Parameter 4:** `OfficeWiFi,GuestWiFi`
* **Parameter 5:** `en0`

The script will process both `OfficeWiFi` and `GuestWiFi` networks.

## ⚠️ Requirements
* macOS 14 (Sonoma) or newer.
* Requires a Jamf Pro environment to utilize the parameter passing feature.

---