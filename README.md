# Anı Panosu

İki kişilik, girişli bir anı panosu: sayfa sayfa anı defteri, fotoğraflar, harita, listeler ve günün sorusu.

Site tek bir `index.html` dosyasıdır ve GitHub Pages üzerinde çalışır. Kayıtlar ve fotoğraflar bu depoda değil, bir Supabase projesinde tutulur; yalnızca izin verilen iki e-posta giriş yapıp içeriği görebilir.

## Kurulum

1. Supabase'de bir proje açın ve SQL Editor'de `kurulum.sql` dosyasını çalıştırın (en alttaki iki e-postayı değiştirin).
2. Authentication bölümünde iki kullanıcıyı e-posta ve şifreyle ekleyin, yeni kayıtları kapatın.
3. `config.js` dosyasına proje adresini ve anon / publishable anahtarı yazın. Gizli (service_role) anahtarı buraya yazmayın.
