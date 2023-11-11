import xml.etree.ElementTree as ET

# XML verisini bir dize olarak tanımlayın
xml_data = """
<?xml version="1.0"?>
<root>
    <Device device_name="sdk_gphone64_x86_64" device_battery="88" />
    <SendFile file="C:/Users/Helmsys/Desktop/SUSAMAM.mp3" />
    <SendFile file="C:/Users/Helmsys/Desktop/sofia_mevzular.gif" />
    <SendFile file="C:/Users/Helmsys/Desktop/remedy.mp3" />
    <SendFile file="C:/Users/Helmsys/Desktop/twitter_yargi_dagitan_teyze.mp4" />
    <SendFile file="C:/Users/Helmsys/Desktop/survivor.gif" />
    <SendFile file="C:/Users/Helmsys/Desktop/BloodHole.png" />
    <SendFile file="C:/Users/Helmsys/Desktop/resim.jpg" />
    <SendFile file="C:/Users/Helmsys/Desktop/F4in7yLWoAAw-tH.jpg" />
    <SendFile file="C:/Users/Helmsys/Desktop/sample.pdf" />
    <SendFile file="C:/Users/Helmsys/Desktop/mobile_app_changelog.txt" />
    <GetFile file="SUSAMAM.mp3" />
    <GetFile file="remedy.mp3" />
</root>
"""

# XML'i işle
root = ET.fromstring(xml_data)

# Tüm <GetFile> etiketlerini bul
get_file_elements = root.findall(".//GetFile")

# En son <GetFile> etiketini seç
if get_file_elements:
    last_get_file = get_file_elements[-1]

    # En son <GetFile> etiketinin "file" özelliğini al
    file_attribute = last_get_file.get("file")

    print("En son GetFile etiketinin file özelliği:", file_attribute)
else:
    print("<GetFile> etiketi bulunamadı.")