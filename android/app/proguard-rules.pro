# TensorFlow Lite sınıflarının silinmesini engelle
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }

# Eksik sınıflar için uyarıları kapat ve derlemeyi durdurma
-dontwarn org.tensorflow.lite.gpu.**
-dontwarn org.tensorflow.lite.**