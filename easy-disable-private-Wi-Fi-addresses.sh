#!/bin/bash
# Jamf 專用腳本：關閉指定 SSID 的 Private Wi-Fi Address (macOS 14+)
# ------------------------------------------------------------
# 功能：
#   - 修改 macOS 已知 Wi-Fi 網路的設定，把「專用 Wi-Fi 位址」關閉 (off)
#   - 適用於 macOS 14 (Sonoma) 以上版本
#   - 透過 Jamf Policy 部署，無需額外輸出 log
#
# Jamf Script 參數使用方式：
#   - Parameter 4: 目標 SSID，可輸入單一或多個 (以逗號分隔)，例如 "SSID1,SSID2"
#   - Parameter 5: Wi-Fi 介面名稱 (預設為 en0，大部分 MacBook 使用 en0)
#
# 範例：
#   在 Jamf Policy 的 Script 參數填：
#     $4 = "OfficeWiFi,GuestWiFi"
#     $5 = "en0"
#   腳本會將這兩個 SSID 的「專用 Wi-Fi 位址」全部關閉，並重啟 Wi-Fi 生效
# ------------------------------------------------------------

# 讀取 Jamf 傳入的參數，若未指定則使用預設值
TARGET_SSIDS="${4:-YourNetworkName}"   # 預設 SSID 名稱
WIFI_INTERFACE="${5:-en0}"             # 預設 Wi-Fi 介面 (en0)

# macOS 儲存 Wi-Fi 設定的檔案路徑
PLIST="/Library/Preferences/com.apple.wifi.known-networks.plist"

# 將多個 SSID 拆成陣列 (以逗號分隔)
IFS=',' read -ra SSIDS <<< "$TARGET_SSIDS"

# 逐一處理每個 SSID
for ssid in "${SSIDS[@]}"; do
  # 在 Plist 裡，Wi-Fi 設定的 key 命名規則如下：
  # wifi.network.ssid.<SSID名稱>
  # 我們要設定的屬性是：PrivateMACAddressModeUserSetting
  key="wifi.network.ssid.${ssid}:PrivateMACAddressModeUserSetting"

  # 檢查該 SSID 是否存在於已知網路列表中
  if /usr/libexec/PlistBuddy -c "Print :wifi.network.ssid.${ssid}" "$PLIST" &>/dev/null; then
    # 嘗試修改為 off，如果屬性不存在就新增
    /usr/libexec/PlistBuddy -c "Set :$key off" "$PLIST" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :$key string off" "$PLIST" 2>/dev/null
  fi
done

# 重新載入 macOS 偏好設定服務 (確保設定立即生效)
killall -HUP cfprefsd 2>/dev/null

# 重新載入 Wi-Fi 服務
killall -HUP airportd 2>/dev/null
sleep 2

# 關閉並重新開啟 Wi-Fi (避免設定沒套用)
networksetup -setairportpower "$WIFI_INTERFACE" off
sleep 2
networksetup -setairportpower "$WIFI_INTERFACE" on
