from django.urls import path
from . import views

urlpatterns = [
    path('', views.person_list, name='person_list'),
    path('create/', views.person_create, name='person_create'),
]
