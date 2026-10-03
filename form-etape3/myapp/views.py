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
