
# Projet Django — Étape 3 : ModelForm

Ce dépôt correspond à **l’étape 3** du cours Django CRUD.  
Il fait suite à :

- Étape 1 : Formulaire HTML manuel  
- Étape 2 : Form (`forms.Form`)  
- **Étape 3 : ModelForm (ce dépôt)**  
- Étape 4 : Generic Views  

Chaque étape est indépendante et peut être clonée séparément.

---

## Objectif pédagogique — Étape 3

Cette étape introduit **les ModelForms (`forms.ModelForm`)**, qui permettent :

- de générer automatiquement les champs du formulaire à partir du modèle  
- d’assurer une validation cohérente avec le modèle  
- de créer l’objet en base via `form.save()`  
- de réduire fortement le code dans les vues  
- d’éviter les incohérences entre modèle et formulaire  

---

## Installation

### 1. Cloner le projet

```bash
git clone https://github.com/<votre-nom>/<votre-repo>.git
cd <votre-repo>
```

---

## Créer un environnement virtuel

```bash
python -m venv .venv
```

Activer :

### Windows PowerShell
```bash
.\.venv\Scripts\activate
```

### macOS / Linux
```bash
source .venv/bin/activate
```

---

## 📦 Installer les dépendances

```bash
pip install -r requirements.txt
```

Pour régénérer ce fichier :

```bash
pip freeze > requirements.txt
```

---

## 🗄️ Créer la base de données

```bash
python manage.py migrate
```

---

## ▶️  Lancer le serveur

```bash
python manage.py runserver
```

Puis ouvrir :  
[http://127.0.0.1:8000/](http://127.0.0.1:8000/)

---

## 📁 Structure du projet

```
form-etape3/
    manage.py
    form/
        settings.py
        urls.py
        wsgi.py
        asgi.py
    myapp/
        models.py
        forms.py
        views.py
        urls.py
        templates/
            myapp/
                person_list.html
                person_create.html
```

---

## Code pédagogique — Étape 3

### ✔ Modèle

```python
class Person(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
```

### ✔ ModelForm

```python
class PersonForm(forms.ModelForm):
    class Meta:
        model = Person
        fields = ['first_name', 'last_name']
```

### ✔ Vue

```python
form = PersonForm(request.POST or None)
if form.is_valid():
    form.save()
    return redirect('person_list')
```

### ✔ Avantages par rapport à l’étape 2

- plus besoin d’écrire les champs du formulaire  
- validation automatique basée sur le modèle  
- création automatique de l’objet via `form.save()`  
- code plus court, plus propre, plus robuste  

---

## Fichiers ignorés

Le `.gitignore` exclut :

- `.venv/`
- `db.sqlite3`
- `__pycache__/`
- fichiers temporaires
- fichiers système

---

## Notes

Cette étape prépare la transition vers :

- **Étape 4 : Generic Views**  
  (CRUD complet en quelques lignes grâce aux vues génériques Django)

```
