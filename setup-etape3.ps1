# ================================
# Script d'installation Étape 3 Django (ModelForm)
#  — Projet pédagogique
# À lancer dans PowerShell : .\setup-etape3.ps1
# ================================

Write-Host "=== Création du projet Django Étape 3 ==="

# 1. Création du dossier
New-Item -ItemType Directory -Force -Name "form-etape3"
Set-Location "form-etape3"

# 2. Environnement virtuel
Write-Host "=== Création du venv ==="
python -m venv .venv
.\.venv\Scripts\activate

# 3. Installation Django
Write-Host "=== Installation Django ==="
pip install django

# 4. Création du projet
Write-Host "=== django-admin startproject form ==="
django-admin startproject form .

# 5. Création de l'app
Write-Host "=== python manage.py startapp myapp ==="
python manage.py startapp myapp

# 6. Ajout de l'app dans settings.py
Write-Host "=== Configuration settings.py ==="
$settings = "form\settings.py"

# Lire le fichier
$content = Get-Content $settings

# Trouver la ligne INSTALLED_APPS
$index = ($content | Select-String -Pattern "INSTALLED_APPS").LineNumber - 1

# Insérer 'myapp' juste après la ligne INSTALLED_APPS = [
$content[$index + 1] = "    'myapp',"

# Réécrire le fichier
$content | Set-Content $settings



# 7. Création du modèle Person
Write-Host "=== Création du modèle Person ==="
@"
from django.db import models

class Person(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.first_name} {self.last_name}"
"@ | Set-Content "myapp\models.py"

# 8. Création du ModelForm
Write-Host "=== Création du ModelForm ==="
@"
from django import forms
from .models import Person

class PersonForm(forms.ModelForm):
    class Meta:
        model = Person
        fields = ['first_name', 'last_name']
"@ | Set-Content "myapp\forms.py"

# 9. Création des vues
Write-Host "=== Création des vues ==="
@"
from django.shortcuts import render, redirect
from .models import Person
from .forms import PersonForm

def person_list(request):
    persons = Person.objects.all()
    return render(request, 'myapp/person_list.html', {'persons': persons})

def person_create(request):
    form = PersonForm(request.POST or None)
    if form.is_valid():
        form.save()
        return redirect('person_list')
    return render(request, 'myapp/person_create.html', {'form': form})
"@ | Set-Content "myapp\views.py"

# 10. URLs de l'app
Write-Host "=== Création des URLs ==="
@"
from django.urls import path
from . import views

urlpatterns = [
    path('', views.person_list, name='person_list'),
    path('create/', views.person_create, name='person_create'),
]
"@ | Set-Content "myapp\urls.py"

# 11. Inclusion des URLs dans form/urls.py
Write-Host "=== Inclusion des URLs dans form/urls.py ==="
@"
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('myapp.urls')),
]
"@ | Set-Content "form\urls.py"

# 12. Templates
Write-Host "=== Création des templates ==="
New-Item -ItemType Directory -Force -Path "myapp\templates\myapp"

@"
<h1>Liste des personnes</h1>

<ul>
{% for p in persons %}
    <li>{{ p.first_name }} {{ p.last_name }}</li>
{% endfor %}
</ul>

<a href="/create/">Ajouter une personne</a>
"@ | Set-Content "myapp\templates\myapp\person_list.html"

@"
<h1>Créer une personne</h1>

<form method="POST">
    {% csrf_token %}
    {{ form.as_p }}
    <button type="submit">Créer</button>
</form>

<a href="/">Retour</a>
"@ | Set-Content "myapp\templates\myapp\person_create.html"

# 13. Migrations
Write-Host "=== Migration ==="
python manage.py makemigrations
python manage.py migrate

# 14. Création du .gitignore
Write-Host "=== Création du .gitignore ==="
@"
.venv/
db.sqlite3
__pycache__/
*.pyc
.DS_Store
"@ | Set-Content ".gitignore"

# 15. Génération requirements.txt
Write-Host "=== Génération requirements.txt ==="
pip freeze > requirements.txt

Write-Host "=== Projet Étape 3 prêt ! ==="
Write-Host "Lancez : python manage.py runserver"
