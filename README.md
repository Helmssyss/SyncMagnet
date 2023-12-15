# SyncMagnet

### This repo is still under development.

For Windows only

## ANDROID
<div align = "center">
   <img src="https://github.com/Helmssyss/SyncMagnet/assets/84701901/2291d11d-ff3e-4615-8ad0-a635f8534a81" width=30% height=30%>
   <img src="https://github.com/Helmssyss/SyncMagnet/assets/84701901/cea5c156-7cdc-45e3-ab72-d8de38fd2e6c" width=30% height=30%>
   <img src="https://github.com/Helmssyss/SyncMagnet/assets/84701901/85e05e70-d8a0-4153-a4a5-0db150079c44" width=30% height=30%>

   
   <img src="https://github.com/Helmssyss/SyncMagnet/assets/84701901/12a9d0b1-f7a4-44b9-abfb-bb261897e211" width=30% height=30%>
   <img src="https://github.com/Helmssyss/SyncMagnet/assets/84701901/3fb68bdb-cdf8-4a40-833d-bd5a4e1a12f3" width=30% height=30%>
   <img src="https://github.com/Helmssyss/SyncMagnet/assets/84701901/9b917cd8-db7e-42c6-80db-13b9834f8829" width=30% height=30%>


   <img src="https://github.com/Helmssyss/SyncMagnet/assets/84701901/27446b7a-6426-4ec4-a608-9cb4b9420fd7" width=30% height=30%>
   <img src="https://github.com/Helmssyss/SyncMagnet/assets/84701901/ab7b4e86-4c17-4743-9f9d-77cfc56aba58" width=30% height=30%>
   <img src="https://github.com/Helmssyss/SyncMagnet/assets/84701901/401539da-270f-4973-ab83-bbe938458234" width=30% height=30%>
</div>

## DESKTOP
<div align = "center">

   <img src="https://github.com/Helmssyss/SyncMagnet/assets/84701901/d3241bfc-a869-4abd-b01e-02f9b489cd43" width=45% height=45%>
   <img src="https://github.com/Helmssyss/SyncMagnet/assets/84701901/59189885-ba0e-42fe-90c9-c88a5fd7f64c" width=45% height=45%>


   ### [CHANGELOG](https://github.com/Helmssyss/SyncMagnet/blob/main/CHANGELOG.md)

</div>

# EN
## How to Run Project? (Only _Windows_)
- ### Install C++ Compiler
   -   For the C++ compiler go to https://www.msys2.org/docs/installer/
   -   After following the necessary steps, install the following libraries
         -   https://packages.msys2.org/package/mingw-w64-x86_64-pugixml?repo=mingw64
         -   https://packages.msys2.org/package/mingw-w64-x86_64-curl

- ### Install Python Interpreter (_Version 3.9.13_)
  -   For the Python interpreter, go to https://www.python.org/downloads/release/python-3913/
  -   Once installed, open the terminal in the directory where the project is located.
  -   Type the command `pip install .\requirements.txt` to install the libraries in the `requirements.txt` file.

- ### Compile the Project
  -   Open the project folder with terminal.
  -   Type `mingw32-make` to execute the commands written in the `Makefile` file in the project.
  -   If a successful build process is completed, the message `Build process is completed.` will appear.
  -   When the compilation process is successful, you can run the project by typing `python main.py` in the same file path.

# TR
## Proje Nasıl Çalıştırılır? (Sadece _Windows_)
- ### C++ Derleyicisini yükleyin
   -   C++ derleyicisi için bu adrese gidin https://www.msys2.org/docs/installer/
   -   Gerekli adımları uyguladıktan sonra aşağıdaki kütüphaneleri kurun
         -   https://packages.msys2.org/package/mingw-w64-x86_64-pugixml?repo=mingw64
         -   https://packages.msys2.org/package/mingw-w64-x86_64-curl

- ### Python Yorumlayıcısını Yükleyin (_Version 3.9.13_)
  -   Python yorumlayıcısı için şu adrese gidin https://www.python.org/downloads/release/python-3913/
  -   Kurulduktan sonra projenin bulunduğu dizinde terminali açın.
  -   `requirements.txt` dosyasındaki kütüphaneleri kurmak için `pip install .\requirements.txt` komutunu yazın.

- ### Projeyi Derleyin
  -   Proje klasörünü terminal ile açın.
  -   Projedeki `Makefile` dosyasında yazan komutları yerine getirmek için `mingw32-make` yazın.
  -   Başarılı bir derleme işlemi gerçekleşirse `Build process is completed.` yazısı çıkacak.
  -   Derleme işlemi başarılı olduğunda yine aynı dosya yolunda `python main.py` yazarak projeyi çalıştırabilirsiniz.
           
