#!/bin/bash

# مسیر فایل کانفیگ
CONFIG_FILE="V2rayNG/app/config.txt"

# بررسی وجود فایل کانفیگ
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    exit 1
fi

# خواندن متغیرها از فایل
# تذکر: فایل باید دقیقاً فرمت key=value داشته باشد و فاصله نداشته باشد
source "$CONFIG_FILE"

echo "--- Applying Configurations ---"
echo "App Name: $appname"
echo "App ID: $appid"
echo "Version: $appversion ($appversioncode)"
echo "Domain: $appdomain"

# مسیر فایل‌های هدف
STRINGS_XML="V2rayNG/app/src/main/res/values/strings.xml"
GRADLE_FILE="V2rayNG/app/build.gradle.kts"
API_SERVICE="V2rayNG/app/src/main/java/com/v2ray/ang/service/ApiService.kt"

# 1. تغییر نام برنامه در strings.xml
# پیدا کردن خطی که app_name دارد و جایگزینی مقدار داخل تگ
sed -i "s|<string name=\"app_name\" translatable=\"false\">.*</string>|<string name=\"app_name\" translatable=\"false\">$appname</string>|g" "$STRINGS_XML"

# 2. تغییر applicationId در build.gradle.kts
sed -i "s|applicationId = \".*\"|applicationId = \"$appid\"|g" "$GRADLE_FILE"

# 3. تغییر versionName در build.gradle.kts
sed -i "s|versionName = \".*\"|versionName = \"$appversion\"|g" "$GRADLE_FILE"

# 4. تغییر versionCode در build.gradle.kts
sed -i "s|versionCode = [0-9]*|versionCode = $appversioncode|g" "$GRADLE_FILE"

# 5. تغییر آدرس دامین در ApiService.kt
sed -i "s|private const val BASE_URL = \".*\"|private const val BASE_URL = \"$appdomain\"|g" "$API_SERVICE"

echo "--- Configuration Applied Successfully ---"