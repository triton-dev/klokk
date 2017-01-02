# Klokk
Dolgozói munkaidő rögzítő rendszer

## Célja
A dolgozók saját maguk a belépőkártyájuk felhasználásával rögzíthessék a kiadott és az elvégzett munka tényleges időráfordítását.

### Peremfeltételek
* A dolgozók költségehelyekhez vannak rendelve.
 - Egy dolgozó egyszerre egy költséghelyhez rendelhető.
* Minden dolgozónak van:
 - neve,
 - törzsszáma,
 - költséghelye,
 - (fényképe),
 - belépő kártyája. Amennyiben a belépő kártyája otthon maradt, akkor ideiglenes kártyát kap, erről később...
* Minden dolgozó valamilyen rendelésszámmal azonosított munkát kell végezzen. A rendelés minimum tartalmazza:
 - rendelésszám,
 - megnevezés,
 - cikkszám,
 - mennyiség,
 - kész
* A dolgozó csak olyan munkán dolgozhat, amihez előzőleg hozzárendelésre került.
* Egy dolgozó egyszerre egy rendelésen dolgozik.
* Az ideiglenes kártyával rendelkező dolgozótelőzőleg regisztrálni kell.
 - A kártya egy napig érvényes, utána automatikusan törlésre kerül.
* Munkakezdés előtt a dolgozó a kártyáját leolvastatja, majd az előzőleg meghatározott munkák közül kiválasztja azt, 
  amelyiket éppen el kell végeznie.
* Az aktuális munka befejeztével a kártyáját leolvastatja, majd
 - újabb munkát választ,
 - állásidő kódot választ,
 - egyéb jogcímet választ (pl: orvosi vizsgálat, oktatás, stb...)
 
 


